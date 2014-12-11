--- common/cmd_test.c.orig	2012-11-28 01:28:06 UTC
+++ common/cmd_test.c
@@ -29,9 +29,14 @@ static int do_test(cmd_tbl_t *cmdtp, int
 	char * const *ap;
 	int left, adv, expr, last_expr, neg, last_cmp;
 
-	/* args? */
-	if (argc < 3)
+	/*
+	 * If no args, that's bogus, return false.
+	 * If op is -z and no other args, answer is Yes, string is empty.
+	 */
+	if (argc < 2)
 		return 1;
+	else if (argc == 2)
+		return !(strcmp(argv[1], "-z") == 0);
 
 #ifdef DEBUG
 	{
