
$FreeBSD$

--- src/srs.h.orig
+++ src/srs.h
@@ -9,22 +9,17 @@
   License: GPL */
 
 #ifndef __SRS_H__
-
 #define __SRS_H__ 1
 
 #ifdef EXPERIMENTAL_SRS
 
 #include "mytypes.h"
-#include <srs_alt.h>
+#include <srs2.h>
 
 int eximsrs_init();
 int eximsrs_done();
 int eximsrs_forward(uschar **result, uschar *orig_sender, uschar *domain);
 int eximsrs_reverse(uschar **result, uschar *address);
-int eximsrs_db(BOOL reverse, uschar *srs_db);
-
-srs_result eximsrs_db_insert(srs_t *srs, char *data, uint data_len, char *result, uint result_len);
-srs_result eximsrs_db_lookup(srs_t *srs, char *data, uint data_len, char *result, uint result_len);
 
 #endif
 
