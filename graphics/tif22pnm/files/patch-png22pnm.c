--- png22pnm.c.orig	2003-03-18 17:14:51.000000000 +0100
+++ png22pnm.c	2012-05-04 07:36:40.000000000 +0200
@@ -40,6 +40,7 @@
 
 #include <math.h>
 #include <png.h>	/* includes zlib.h and setjmp.h */
+#include <pngpriv.h>
 #if 0
 #define VERSION "p2.37.4 (5 December 1999) +netpbm"
 #else
@@ -783,7 +784,7 @@
             (info_ptr->valid & PNG_INFO_tRNS)) {
           trans_mix = TRUE;
           for (i = 0 ; i < info_ptr->num_trans ; i++)
-            if (info_ptr->trans[i] != 0 && info_ptr->trans[i] != 255) {
+            if (info_ptr->trans_alpha[i] != 0 && info_ptr->trans_alpha[i] != 255) {
               trans_mix = FALSE;
               break;
             }
@@ -932,7 +933,7 @@
         pnm_type = PBM_TYPE;
         if (info_ptr->valid & PNG_INFO_tRNS) {
           for (i = 0 ; i < info_ptr->num_trans ; i++) {
-            if (info_ptr->trans[i] != 0 && info_ptr->trans[i] != maxval) {
+            if (info_ptr->trans_alpha[i] != 0 && info_ptr->trans_alpha[i] != maxval) {
               pnm_type = PGM_TYPE;
               break;
             }
@@ -1009,7 +1010,7 @@
         case PNG_COLOR_TYPE_GRAY:
           store_pixel (pnm_pixel, c, c, c,
 		((info_ptr->valid & PNG_INFO_tRNS) &&
-		 (c == gamma_correct (info_ptr->trans_values.gray, totalgamma))) ?
+		 (c == gamma_correct (info_ptr->trans_color.gray, totalgamma))) ?
 			0 : maxval);
           break;
 
@@ -1023,7 +1024,7 @@
                        info_ptr->palette[c].green, info_ptr->palette[c].blue,
                        (info_ptr->valid & PNG_INFO_tRNS) &&
                         c<info_ptr->num_trans ?
-                        info_ptr->trans[c] : maxval);
+                        info_ptr->trans_alpha[c] : maxval);
           break;
 
         case PNG_COLOR_TYPE_RGB:
@@ -1031,9 +1032,9 @@
           c3 = get_png_val (png_pixel);
           store_pixel (pnm_pixel, c, c2, c3,
 		((info_ptr->valid & PNG_INFO_tRNS) &&
-		 (c  == gamma_correct (info_ptr->trans_values.red, totalgamma)) &&
-		 (c2 == gamma_correct (info_ptr->trans_values.green, totalgamma)) &&
-		 (c3 == gamma_correct (info_ptr->trans_values.blue, totalgamma))) ?
+		 (c  == gamma_correct (info_ptr->trans_color.red, totalgamma)) &&
+		 (c2 == gamma_correct (info_ptr->trans_color.green, totalgamma)) &&
+		 (c3 == gamma_correct (info_ptr->trans_color.blue, totalgamma))) ?
 			0 : maxval);
           break;
 
