--- rtengine/opthelper.h.orig	2017-01-05 02:25:57 UTC
+++ rtengine/opthelper.h
@@ -69,7 +69,7 @@
         #define ALIGNED64
         #define ALIGNED16
     #endif
-    #if !defined(__clang__) && defined _OPENMP
+    #if defined(_OPENMP)
         #define _RT_NESTED_OPENMP
     #endif
 #endif
