--- src/wnnfns.c-	Wed Apr 30 15:45:08 2003
+++ src/wnnfns.c	Wed Apr 30 15:45:20 2003
@@ -1816,6 +1816,9 @@
   return Qt;
 }
 
+/* $B$3$N(Btype cast$B$OHs>o$K4m81!#(Bjl.c$B$,;H$C$F$$$k$N$G%^%M$7$F$$$k$@$1!#(B
+   $B99$K(B js_*()$B7O$r8F$S=P$7$F$k!D(B */
+#include "mt_jlib.h"	/* for WNN_ENV_INT */
 DEFUN ("wnn-nihongo-kosei", Fwnn_nihongo_kosei, Swnn_nihongo_kosei, 1, 1, 0,
        "For Wnn7.")
      (mode)
@@ -1824,9 +1827,6 @@
   int   snum;
   if ((snum = check_wnn_server_type()) == -1) return Qnil;
   if(!wnnfns_buf[snum]) return Qnil;
-  /* $B$3$N(Btype cast$B$OHs>o$K4m81!#(Bjl.c$B$,;H$C$F$$$k$N$G%^%M$7$F$$$k$@$1!#(B
-     $B99$K(B js_*()$B7O$r8F$S=P$7$F$k!D(B */
-#include "mt_jlib.h"	/* for WNN_ENV_INT */
   if(js_set_henkan_hinsi_group( (WNN_ENV_INT*)wnnfns_buf[snum]->env,
 				HINSI_NO_GOYOU,
 				HINSI_NO_GOYOU_START,
