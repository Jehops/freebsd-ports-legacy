--- setup.py.orig	Tue Jan 11 13:04:34 2005
+++ setup.py	Sat Jan 15 16:24:38 2005
@@ -242,7 +242,7 @@
              ['share/locale/nl/LC_MESSAGES/linkchecker.mo']),
          ('share/linkchecker',
              ['config/linkcheckerrc', 'config/logging.conf', ]),
-         ('share/linkchecker/examples',
+         ('share/examples/linkchecker',
              ['cgi/lconline/leer.html.en', 'cgi/lconline/leer.html.de',
               'cgi/lconline/index.html', 'cgi/lconline/lc_cgi.html.en',
               'cgi/lconline/lc_cgi.html.de', 'cgi/lconline/check.js',
@@ -250,10 +250,8 @@
       ]
 
 if os.name == 'posix':
-    data_files.append(('share/man/man1', ['doc/en/linkchecker.1']))
-    data_files.append(('share/man/de/man1', ['doc/de/linkchecker.1']))
-    data_files.append(('share/man/fr/man1', ['doc/fr/linkchecker.1']))
-    data_files.append(('share/linkchecker/examples',
+    data_files.append(('man/man1', ['doc/en/linkchecker.1']))
+    data_files.append(('share/examples/linkchecker',
               ['config/linkchecker-completion', 'config/linkcheck-cron.sh']))
 elif os.name == 'nt':
     data_files.append(('share/linkchecker/doc',
