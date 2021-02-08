--- electron/shell/app/electron_main.cc.orig	2021-01-22 23:55:24 UTC
+++ electron/shell/app/electron_main.cc
@@ -32,12 +32,12 @@
 #include "shell/app/electron_main_delegate.h"
 #include "third_party/crashpad/crashpad/util/win/initial_client_data.h"
 
-#elif defined(OS_LINUX)  // defined(OS_WIN)
+#elif defined(OS_LINUX) || defined(OS_BSD)  // defined(OS_WIN)
 #include <unistd.h>
 #include <cstdio>
 #include "content/public/app/content_main.h"
 #include "shell/app/electron_main_delegate.h"  // NOLINT
-#else                                          // defined(OS_LINUX)
+#else                                          // defined(OS_LINUX) || defined(OS_BSD)
 #include <mach-o/dyld.h>
 #include <unistd.h>
 #include <cstdio>
@@ -210,7 +210,7 @@ int APIENTRY wWinMain(HINSTANCE instance, HINSTANCE, w
   return content::ContentMain(params);
 }
 
-#elif defined(OS_LINUX)  // defined(OS_WIN)
+#elif defined(OS_LINUX) || defined(OS_BSD)  // defined(OS_WIN)
 
 int main(int argc, char* argv[]) {
   FixStdioStreams();
@@ -231,7 +231,7 @@ int main(int argc, char* argv[]) {
   return content::ContentMain(params);
 }
 
-#else  // defined(OS_LINUX)
+#else  // defined(OS_LINUX) || defined(OS_BSD)
 
 int main(int argc, char* argv[]) {
   FixStdioStreams();
