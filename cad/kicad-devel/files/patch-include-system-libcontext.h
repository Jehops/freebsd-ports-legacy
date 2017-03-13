--- include/system/libcontext.h.orig	2017-03-13 11:47:23.495919000 +0100
+++ include/system/libcontext.h	2017-03-13 11:51:12.678651000 +0100
@@ -23,13 +23,15 @@
 
 
-#if defined(__GNUC__) || defined(__APPLE__)
+#if defined(__GNUC__) || defined(__APPLE__) || defined(__FreeBSD__)
 
     #define LIBCONTEXT_COMPILER_gcc
 
-    #if defined(__linux__)
+    #if defined(__linux__) || defined(__FreeBSD__)
 	#ifdef __x86_64__
 	    #define LIBCONTEXT_PLATFORM_linux_x86_64
 	    #define LIBCONTEXT_CALL_CONVENTION
-
+	#elif __amd64__
+	    #define LIBCONTEXT_PLATFORM_linux_x86_64
+	    #define LIBCONTEXT_CALL_CONVENTION
 	#elif __i386__
 	    #define LIBCONTEXT_PLATFORM_linux_i386
