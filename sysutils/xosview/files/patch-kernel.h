--- bsd/kernel.h.orig	Fri May 29 14:21:36 1998
+++ bsd/kernel.h	Tue Aug 21 10:50:17 2001
@@ -52,7 +52,7 @@
 
 #ifdef HAVE_SWAPCTL
 void
-BSDGetSwapCtlInfo(int* total, int* free);
+BSDGetSwapCtlInfo(long* total, long* free);
 #endif
 
 int
@@ -67,7 +67,11 @@
 #endif
 
 
-#define NUM_INTR	16
+#if defined(XOSVIEW_FREEBSD) && defined(__alpha__)
+# define NUM_INTR	256
+#else
+# define NUM_INTR	16
+#endif
 
 int
 BSDIntrInit();
