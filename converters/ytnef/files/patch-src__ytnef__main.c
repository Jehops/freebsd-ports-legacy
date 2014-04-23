--- src/ytnef/main.c.orig	2004-06-04 18:40:47.000000000 +0400
+++ src/ytnef/main.c	2014-04-01 22:00:33.027598870 +0400
@@ -68,7 +68,7 @@
                 case 'v': verbose++;
                           break;
                 case 'h': PrintHelp();
-                          return;
+                          return 0;
                 case 'f': savefiles = 1;
                           filepath = argv[i+1];
                           i++;
@@ -103,11 +103,12 @@
         TNEF.Debug = verbose;
         if (TNEFParseFile(argv[i], &TNEF) == -1) {
             printf("ERROR processing file\n");
-            continue;
+            return 1;
         }
         ProcessTNEF(TNEF);
         TNEFFree(&TNEF);
     }
+    return 0;
 }
 
 void ProcessTNEF(TNEFStruct TNEF) {
