--- check/alc/test_demux_label1_rx.c.orig	Tue Jul 22 19:37:39 2003
+++ check/alc/test_demux_label1_rx.c	Wed Oct 15 17:13:17 2003
@@ -26,6 +26,10 @@
 
 #include <stdio.h>
 
+#ifdef FREEBSD
+#include <sys/types.h>
+#endif
+
 #ifdef WIN32
 #include <winsock2.h>
 #else
