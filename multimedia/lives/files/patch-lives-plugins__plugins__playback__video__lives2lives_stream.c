--- ./lives-plugins/plugins/playback/video/lives2lives_stream.c.orig	2013-03-16 13:14:33.000000000 +0100
+++ ./lives-plugins/plugins/playback/video/lives2lives_stream.c	2013-12-05 19:12:38.654055182 +0100
@@ -8,7 +8,7 @@
 #include <inttypes.h>
 #include <sys/types.h>
 #include <sys/socket.h>
-
+#include <netinet/in.h>
 //////////////////////////////////////
 
 static int palette_list[3];
