--- src/psfile.cpp~	Fri Apr 13 19:36:27 2007
+++ src/psfile.cpp	2007-07-17 01:11:44 +0200
@@ -19,7 +19,9 @@
 #include "psfile.h"
 #include "streamhandle.h"
 #include "stream.h"
+extern "C" {
 #include <ffmpeg/avcodec.h>
+}
 
 psfile::psfile(const std::string &filename, inbuffer &b, int initial_offset)
     : mpgfile(filename, b, initial_offset)
@@ -100,7 +102,7 @@
       streamnumber[sid]=audiostream(audiostreams);
       stream *S=&s[audiostream(audiostreams++)];
       S->id=sid;
-      S->dec=&ac3_decoder;
+      S->dec=&liba52_decoder;
       S->type=streamtype::ac3audio;
       if (audiostreams>=MAXAUDIOSTREAMS)
         break;
