$FreeBSD$

--- ../../hotspot/src/os/bsd/vm/os_bsd.cpp.orig	Wed Jun 13 16:16:36 2007
+++ ../../hotspot/src/os/bsd/vm/os_bsd.cpp	Wed Jun 13 16:36:13 2007
@@ -364,7 +364,7 @@
  *	  7: The default directories, normally /lib and /usr/lib.
  */
 #ifndef DEFAULT_LIBPATH
-#define DEFAULT_LIBPATH	"/lib:/usr/lib"
+#define DEFAULT_LIBPATH	"/lib:/usr/lib:%%LOCALBASE%%/lib"
 #endif
 
 #define EXTENSIONS_DIR	"/lib/ext"
