--- src/modules.c.orig	Mon Jun  2 11:31:15 2003
+++ src/modules.c	Mon Jun  2 11:31:44 2003
@@ -120,4 +120,4 @@
 #ifndef STATIC
-char moddir[121] = "modules/";
+char moddir[121] = __PREFIX__ "/lib/eggdrop/";
 #endif
 
