--- talk/session/phone/linphonemediaengine.cc.orig	Wed Feb 22 16:32:44 2006
+++ talk/session/phone/linphonemediaengine.cc	Wed Feb 22 16:41:45 2006
@@ -139,7 +139,7 @@
  
 #ifdef HAVE_SPEEX
   ms_speex_codec_init();
-  rtp_profile_set_payload(&av_profile, 110, &speex_wb);
+  rtp_profile_set_payload(&av_profile, 110, &payload_type_speex_wb);
   codecs_.push_back(Codec(110, "speex", 8));
 #endif
 
@@ -149,7 +149,7 @@
   codecs_.push_back(Codec(102, "iLBC", 4));
 #endif
 
-  rtp_profile_set_payload(&av_profile, 0, &pcmu8000);
+  rtp_profile_set_payload(&av_profile, 0, &payload_type_pcmu8000);
   codecs_.push_back(Codec(0, "PCMU", 2));
   
 return true;
