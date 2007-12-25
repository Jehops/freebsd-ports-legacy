diff -urN -x .svn ../../vendor/vpopmail/vutil.c ./vutil.c
--- ../../vendor/vpopmail/vutil.c	2007-12-25 05:03:25.000000000 +0200
+++ ./vutil.c	2007-12-25 07:31:16.000000000 +0200
@@ -76,13 +76,7 @@
   */
 
 int file_exists (char *filename) {
-    FILE *fs;
-    if( (fs=fopen(filename, "r")) !=NULL ) {
-        fclose(fs);
-        return 1;
-    } else {
-        return 0;
-    }
+    return(access(filename, R_OK) == 0);
 }
 
 //////////////////////////////////////////////////////////////////////
@@ -100,24 +94,15 @@
 {
     FILE *fs = NULL;
     char FileName[MAX_BUFF];
-    int result = 0;
     char TmpBuf2[MAX_BUFF];
 
     snprintf( FileName, MAX_BUFF, "%s/.qmail-%s", path, Name );
-    if ( (fs=fopen(FileName,"r"))==NULL) {
-//        printf( "   Unable to open list file: %s\n", Name );
-    }
-
-    else {
-        fgets( TmpBuf2, sizeof(TmpBuf2), fs);
-        if ( strstr( TmpBuf2, "ezmlm-reject") != 0 ||
-             strstr( TmpBuf2, "ezmlm-send")   != 0 ) {
-            result = 1;
-        }
-        fclose(fs);
-    }
-
-    return result;
+    if ( (fs=fopen(FileName,"r"))==NULL)
+        return(0);
+    fgets( TmpBuf2, sizeof(TmpBuf2), fs);
+    fclose(fs);
+    return ( strstr( TmpBuf2, "ezmlm-reject") != 0 ||
+        strstr( TmpBuf2, "ezmlm-send")   != 0 );
 }
 
 
