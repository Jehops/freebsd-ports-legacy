--- mxEXPERIMENTAL.py.orig	Sat Aug 21 20:34:49 2004
+++ mxEXPERIMENTAL.py	Sat Aug 21 20:38:15 2004
@@ -133,7 +133,7 @@
 
             mx_Extension('mx.Number.mxNumber.mxNumber',
                          ['mx/Number/mxNumber/mxNumber.c'],
-                         include_dirs=['mx/Number/mxNumber'],
+                         include_dirs=['mx/Number/mxNumber', 'LIBGMPH'],
                          libraries=['gmp'],
                          optional_libraries=[('mpfr', ['gmp.h', 'mpfr.h']),
                                              ]),
@@ -156,7 +156,6 @@
     'mx/Number/README',
     'mx/Number/mxNumber/mxNumber.h',
     'mx/Number/mxNumber/mxh.h',
-    'mx/Number/mxNumber/gmp.h',
 
     # mxTidy
     'mx/Tidy/Doc/mxTidy.html',
