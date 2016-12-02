--- src/main.cpp.orig	2016-11-13 15:20:00 UTC
+++ src/main.cpp
@@ -317,3 +317,10 @@ int main(int argc, char *argv[])
 #endif
     return errorcode;
 }
+
+// Missing in libxccrt.so function __cxa_deleted_virtual, see FreeBSD Bug#200863
+extern "C" void __cxa_deleted_virtual()
+{
+  abort();
+}
+
