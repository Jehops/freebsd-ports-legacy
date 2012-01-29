--- server/mozc_server.cc.orig	2012-01-29 13:42:31.175805998 +0900
+++ server/mozc_server.cc	2012-01-29 13:49:16.896805385 +0900
@@ -32,6 +32,9 @@
 #ifdef OS_WINDOWS
 #include <windows.h>
 #endif
+#ifdef __FreeBSD__
+#include <signal.h>
+#endif
 
 #include "base/base.h"
 #include "base/process.h"
@@ -50,6 +53,23 @@
 mozc::SessionServer *g_session_server = NULL;
 }
 
+#ifdef __FreeBSD__
+static void sig_func(int num)
+{
+  VLOG(1) << "signal " << num << " recieved.";
+  switch (num) {
+  case SIGINT:
+  case SIGHUP:
+  case SIGTERM:
+    if (g_session_server)
+      g_session_server->Terminate();
+    break;
+  default:
+    break;
+  }
+}
+#endif
+
 namespace mozc {
 namespace {
 
@@ -132,6 +152,12 @@
       return -1;
     }
 
+#ifdef __FreeBSD__
+    ::signal(SIGINT, sig_func);
+    ::signal(SIGHUP, sig_func);
+    ::signal(SIGTERM, sig_func);
+#endif
+
 #if defined(OS_WINDOWS)
     // On Windows, ShutdownSessionCallback is not called intentionally in order
     // to avoid crashes oritinates from it. See b/2696087.
