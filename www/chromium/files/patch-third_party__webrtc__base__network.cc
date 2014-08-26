--- ./third_party/webrtc/base/network.cc.orig	2014-08-20 21:04:28.000000000 +0200
+++ ./third_party/webrtc/base/network.cc	2014-08-22 18:51:07.000000000 +0200
@@ -18,7 +18,7 @@
 // linux/if.h can't be included at the same time as the posix sys/if.h, and
 // it's transitively required by linux/route.h, so include that version on
 // linux instead of the standard posix one.
-#if defined(WEBRTC_LINUX)
+#if defined(WEBRTC_LINUX) && !defined(WEBRTC_BSD)
 #include <linux/if.h>
 #include <linux/route.h>
 #elif !defined(__native_client__)
@@ -462,7 +462,7 @@
 }
 #endif  // WEBRTC_WIN 
 
-#if defined(WEBRTC_LINUX)
+#if defined(WEBRTC_LINUX) && !defined(WEBRTC_BSD)
 bool IsDefaultRoute(const std::string& network_name) {
   FileStream fs;
   if (!fs.Open("/proc/net/route", "r", NULL)) {
@@ -502,7 +502,7 @@
       strncmp(network.name().c_str(), "vnic", 4) == 0) {
     return true;
   }
-#if defined(WEBRTC_LINUX)
+#if defined(WEBRTC_LINUX) && !defined(WEBRTC_BSD)
   // Make sure this is a default route, if we're ignoring non-defaults.
   if (ignore_non_default_routes_ && !IsDefaultRoute(network.name())) {
     return true;
