--- lexed/srtex.yy.c.orig	Tue Jun 10 20:21:05 2003
+++ lexed/srtex.yy.c	Tue Jun 10 20:22:54 2003
@@ -1,4 +1,5 @@
-# include "stdio.h"
+# include <stdio.h>
+# include <unistd.h>
 # define U(x) ((x)&0377)
 # define NLSTATE yyprevious=YYNEWLINE
 # define BEGIN yybgin = yysvec + 1 +
@@ -17,7 +18,7 @@
 int yymorfg;
 extern char *yysptr, yysbuf[];
 int yytchar;
-FILE *yyin ={stdin}, *yyout ={stdout};
+FILE *yyin ={STDIN_FILENO}, *yyout ={STDOUT_FILENO};
 extern int yylineno;
 struct yysvf { 
 	struct yywork *yystoff;
