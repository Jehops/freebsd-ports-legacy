--- apr-0.9.4/build/apr_threads.m4.orig	Sun Nov 16 08:42:33 2003
+++ apr-0.9.4/build/apr_threads.m4	Fri Jan 23 12:25:00 2004
@@ -110,6 +110,7 @@
 
 AC_CACHE_CHECK([for CFLAGS needed for pthreads], [apr_cv_pthreads_cflags],
 [apr_ptc_cflags=$CFLAGS
+ if test "x$ac_cv_pthreads_cflags" = "x"; then
  for flag in none -kthread -pthread -pthreads -mthreads -Kthread -threads; do 
     CFLAGS=$apr_ptc_cflags
     test "x$flag" != "xnone" && CFLAGS="$CFLAGS $flag"
@@ -118,6 +119,11 @@
       break
     ])
  done
+ else
+  if test "$ac_cv_pthreads_cflags" != "none"; then
+   apr_cv_pthreads_cflags="$ac_cv_pthreads_cflags"
+  fi
+ fi
  CFLAGS=$apr_ptc_cflags
 ])
 
@@ -136,6 +142,7 @@
 
 AC_CACHE_CHECK([for LIBS needed for pthreads], [apr_cv_pthreads_lib], [
   apr_ptc_libs=$LIBS
+  if test "x$ac_cv_pthreads_lib" = "x"; then
   for lib in -lpthread -lpthreads -lc_r; do
     LIBS="$apr_ptc_libs $lib"
     APR_PTHREADS_TRY_RUN([
@@ -143,6 +150,9 @@
       break
     ])
   done
+  else
+    test "x$ac_cv_pthreads_lib" != "xnone" && apr_cv_pthreads_lib="-l$ac_cv_pthreads_lib"
+  fi
   LIBS=$apr_ptc_libs
 ])
 
