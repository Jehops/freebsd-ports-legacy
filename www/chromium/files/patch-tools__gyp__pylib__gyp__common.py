--- tools/gyp/pylib/gyp/common.py.orig	2012-03-30 01:29:20.000000000 +0300
+++ tools/gyp/pylib/gyp/common.py	2012-03-30 01:29:48.000000000 +0300
@@ -353,6 +353,8 @@
     'sunos5': 'solaris',
     'freebsd7': 'freebsd',
     'freebsd8': 'freebsd',
+    'freebsd9': 'freebsd',
+    'freebsd10': 'freebsd',
   }
   flavor = flavors.get(sys.platform, 'linux')
   return params.get('flavor', flavor)
