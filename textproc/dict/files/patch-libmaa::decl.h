--- libmaa/decl.h.orig	Fri Aug  2 12:43:15 2002
+++ libmaa/decl.h	Sat Jan 11 18:39:01 2003
@@ -28,7 +28,7 @@
 declarations for standard library calls.  We provide them here for
 situations that we know about. */
 
-#if defined(__sparc__) && !defined(linux)
+#if defined(__sparc__) && !(defined(linux) || defined(__FreeBSD__))
 #include <sys/resource.h>
 				/* Both SunOS and Solaris */
 extern int    getrusage( int who, struct rusage * );
