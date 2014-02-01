# HG changeset patch
# User John Eckersberg <jeckersb@redhat.com>
# Date 1390870108 18000
#      Mon Jan 27 19:48:28 2014 -0500
# Node ID 7179aa474f31e73834adda26b77bfc25bfe5143d
# Parent  3e6507fa0c26d20c09f8f468f2bd04aa2fd1b5b5
yaml_parser-{un,}roll-indent: fix int overflow in column argument

diff -r 3e6507fa0c26 -r 7179aa474f31 src/scanner.c
--- src/scanner.c	Mon Dec 24 03:51:32 2012 +0000
+++ src/scanner.c	Mon Jan 27 19:48:28 2014 -0500
@@ -615,11 +615,14 @@
  */
 
 static int
-yaml_parser_roll_indent(yaml_parser_t *parser, int column,
+yaml_parser_roll_indent(yaml_parser_t *parser, size_t column,
         int number, yaml_token_type_t type, yaml_mark_t mark);
 
 static int
-yaml_parser_unroll_indent(yaml_parser_t *parser, int column);
+yaml_parser_unroll_indent(yaml_parser_t *parser, size_t column);
+
+static int
+yaml_parser_reset_indent(yaml_parser_t *parser);
 
 /*
  * Token fetchers.
@@ -1206,7 +1209,7 @@
  */
 
 static int
-yaml_parser_roll_indent(yaml_parser_t *parser, int column,
+yaml_parser_roll_indent(yaml_parser_t *parser, size_t column,
         int number, yaml_token_type_t type, yaml_mark_t mark)
 {
     yaml_token_t token;
@@ -1216,7 +1219,7 @@
     if (parser->flow_level)
         return 1;
 
-    if (parser->indent < column)
+    if (parser->indent == -1 || parser->indent < column)
     {
         /*
          * Push the current indentation level to the stack and set the new
@@ -1254,7 +1257,7 @@
 
 
 static int
-yaml_parser_unroll_indent(yaml_parser_t *parser, int column)
+yaml_parser_unroll_indent(yaml_parser_t *parser, size_t column)
 {
     yaml_token_t token;
 
@@ -1263,6 +1266,15 @@
     if (parser->flow_level)
         return 1;
 
+    /*
+     * column is unsigned and parser->indent is signed, so if
+     * parser->indent is less than zero the conditional in the while
+     * loop below is incorrect.  Guard against that.
+     */
+    
+    if (parser->indent < 0)
+        return 1;
+
     /* Loop through the intendation levels in the stack. */
 
     while (parser->indent > column)
@@ -1283,6 +1295,41 @@
 }
 
 /*
+ * Pop indentation levels from the indents stack until the current
+ * level resets to -1.  For each intendation level, append the
+ * BLOCK-END token.
+ */
+
+static int
+yaml_parser_reset_indent(yaml_parser_t *parser)
+{
+    yaml_token_t token;
+
+    /* In the flow context, do nothing. */
+
+    if (parser->flow_level)
+        return 1;
+
+    /* Loop through the intendation levels in the stack. */
+
+    while (parser->indent > -1)
+    {
+        /* Create a token and append it to the queue. */
+
+        TOKEN_INIT(token, YAML_BLOCK_END_TOKEN, parser->mark, parser->mark);
+
+        if (!ENQUEUE(parser, parser->tokens, token))
+            return 0;
+
+        /* Pop the indentation level. */
+
+        parser->indent = POP(parser, parser->indents);
+    }
+
+    return 1;
+}
+
+/*
  * Initialize the scanner and produce the STREAM-START token.
  */
 
@@ -1338,7 +1385,7 @@
 
     /* Reset the indentation level. */
 
-    if (!yaml_parser_unroll_indent(parser, -1))
+    if (!yaml_parser_reset_indent(parser))
         return 0;
 
     /* Reset simple keys. */
@@ -1369,7 +1416,7 @@
 
     /* Reset the indentation level. */
 
-    if (!yaml_parser_unroll_indent(parser, -1))
+    if (!yaml_parser_reset_indent(parser))
         return 0;
 
     /* Reset simple keys. */
@@ -1407,7 +1454,7 @@
 
     /* Reset the indentation level. */
 
-    if (!yaml_parser_unroll_indent(parser, -1))
+    if (!yaml_parser_reset_indent(parser))
         return 0;
 
     /* Reset simple keys. */

