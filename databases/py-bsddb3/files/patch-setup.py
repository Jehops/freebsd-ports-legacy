--- setup.py.orig	Fri Sep 14 00:15:30 2001
+++ setup.py	Tue Feb  5 12:37:16 2002
@@ -68,8 +68,8 @@
     # figure out from the base setting where the lib and .h are
     if not incdir: incdir = os.path.join(BERKELEYDB_DIR, 'include')
     if not libdir: libdir = os.path.join(BERKELEYDB_DIR, 'lib')
-    if not '-ldb' in LIBS:
-        libname = ['db']
+    if not '-ldb3' in LIBS:
+        libname = ['db3']
     else:
         libname = []
     utils = []
@@ -93,7 +93,7 @@
     if not status and string.find(results, 'libdb.') >= 0:
         static = 1
 
-    if static:
+    if 0:
         print """\
 \aWARNING:
 \tIt appears that the old bsddb module is staticly linked in the
