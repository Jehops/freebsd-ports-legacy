--- libgnomeprint/gnome-print.c.orig	Tue Jan  7 14:39:24 2003
+++ libgnomeprint/gnome-print.c	Tue Jan  7 14:39:35 2003
@@ -38,8 +38,8 @@
 #include <libgnomeprint/gnome-print-frgba.h>
 
 /* For the buffer stuff, remove when the buffer stuff is moved out here */
-#include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/mman.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
