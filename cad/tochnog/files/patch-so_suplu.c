--- so_suplu.c.orig	Thu Nov  9 15:59:39 2000
+++ so_suplu.c	Sat Feb  4 20:21:59 2006
@@ -22,14 +22,16 @@
 #if ( SUPERLU_USE || SUPERLU_MT_USE || SUPERLU_DIST_USE )
 
 #if SUPERLU_USE 
-#include "dsp_defs.h"
+#include "slu_ddefs.h"
 #elif SUPERLU_MT_USE
+#include "slu_mt_util.h"
 #include "pdsp_defs.h"
 #elif SUPERLU_DIST_USE
 #include <math.h>
+#include "superlu_util.h"
 #include "superlu_ddefs.h"
 #endif
-#include "util.h"
+
  
 long int solve_superlu( double *superlu_A, int *superlu_asub,
   int *superlu_xa, int superlu_nnz, double solve_b[], long int solve_nlocal,
@@ -53,6 +55,10 @@
   int *perm_r, *perm_c;
   int perm_spec;
   int nrhs;
+#if SUPERLU_USE
+  SuperLUStat_t stat;
+  superlu_options_t options;
+#endif
 #endif
 
   /* Create Matrix A in the format expected by SuperLU */
@@ -94,8 +100,8 @@
   nrhs = 1;
 #if ( SUPERLU_USE || SUPERLU_MT_USE )
   dCreate_Dense_Matrix( &B, n, nrhs, solve_b, n, DN, _D, GE ); 
-  if ( !(perm_r = intMalloc(1000+n)) ) ABORT("Not enough memory for SuperLU.");
-  if ( !(perm_c = intMalloc(1000+n)) ) ABORT("Not enough memory for SuperLU.");
+  if ( !(perm_r = intMalloc(1000+n)) ) USER_ABORT("Not enough memory for SuperLU.");
+  if ( !(perm_c = intMalloc(1000+n)) ) USER_ABORT("Not enough memory for SuperLU.");
     /* Get column permutation vector perm_c[] */
   perm_spec = 1;
   get_perm_c( perm_spec, &A, perm_c );
@@ -103,7 +109,9 @@
 
   /* Solve */
 #if SUPERLU_USE 
-  dgssv( &A, perm_c, perm_r, &L, &U, &B, &info );
+  /* Initialize the statistics variables. */
+  StatInit(&stat);
+  dgssv(&options, &A, perm_c, perm_r, &L, &U, &B, &stat, &info );
 #elif SUPERLU_MT_USE
   pdgssv( nthread, &A, perm_c, perm_r, &L, &U, &B, &info );
 #elif SUPERLU_DIST_USE
