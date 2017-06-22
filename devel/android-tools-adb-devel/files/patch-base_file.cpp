--- base/file.cpp.orig	2017-06-20 10:50:27 UTC
+++ base/file.cpp
@@ -19,6 +19,10 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <libgen.h>
+#include <limits.h> // PATH_MAX
+#include <stdio.h> // BUFSIZ
+#include <stdlib.h> // realpath
+#include <string.h> // strerror
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <unistd.h>
@@ -36,6 +39,9 @@
 #if defined(__APPLE__)
 #include <mach-o/dyld.h>
 #endif
+#if defined(__DragonFly__) || defined(__FreeBSD__)
+#include <sys/sysctl.h>
+#endif
 #if defined(_WIN32)
 #include <windows.h>
 #define O_CLOEXEC O_NOINHERIT
@@ -251,6 +257,17 @@ std::string GetExecutablePath() {
   if (result == 0 || result == sizeof(path) - 1) return "";
   path[PATH_MAX - 1] = 0;
   return path;
+#elif defined(KERN_PROC_PATHNAME)
+  char path[PATH_MAX + 1];
+  size_t path_len = sizeof(path);
+  int mib[] = {
+    CTL_KERN,
+    KERN_PROC,
+    KERN_PROC_PATHNAME,
+    getpid()
+  };
+  int rc = sysctl(mib, arraysize(mib), path, &path_len, NULL, 0);
+  return rc ? "" : path;
 #else
 #error unknown OS
 #endif
