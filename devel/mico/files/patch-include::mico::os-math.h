--- include/mico/os-math.h.orig	Mon Oct 13 13:49:32 2003
+++ include/mico/os-math.h	Sat Jan 29 19:25:49 2005
@@ -284,12 +284,23 @@
     : (sizeof (x) == sizeof (double)) ? __fpclassifyd(x) \
     : __fpclassifyl(x))
 #endif
-#ifndef isinf
+#ifndef HAVE_ISINF
 #define	isinf(x)	(fpclassify(x) == FP_INFINITE)
 #endif
-#ifndef isnan
+#ifndef HAVE_ISNAN
 #define	isnan(x)	(fpclassify(x) == FP_NAN)
 #endif
+#endif
+
+// configure wrong set HAVE_*
+#define asinl asin
+#define ldexpl ldexp
+#define frexpl frexp
+#define fmodl fmod
+
+#if __FreeBSD_version < 503105
+#define ceill ceil
+#define floorl floor
 #endif
 #endif // __FreeBSD__
 
