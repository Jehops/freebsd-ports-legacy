--- brainworkshop.pyw.orig	2008-10-29 02:52:28.000000000 +0300
+++ brainworkshop.pyw	2008-10-29 02:53:14.000000000 +0300
@@ -52,9 +52,7 @@
         hasattr(sys, "importers") # old py2exe
         or imp.is_frozen("__main__")) # tools/freeze
 def get_main_dir():
-    if main_is_frozen():
-        return os.path.dirname(sys.executable)
-    return sys.path[0]    
+    return '/'
 
 CONFIGFILE_DEFAULT_CONTENTS = """
 ######################################################################
@@ -242,6 +240,9 @@
 try: CONFIGFILE = sys.argv[sys.argv.index('--configfile') + 1]
 except: pass
 
+if not os.path.exists(FOLDER_DATA):
+	os.mkdir(FOLDER_DATA)
+
 if not os.path.isfile(os.path.join(get_main_dir(), FOLDER_DATA, CONFIGFILE)):
     newconfigfile = open(os.path.join(os.path.join(get_main_dir(), FOLDER_DATA, CONFIGFILE)), 'w')
     newconfigfile.write(CONFIGFILE_DEFAULT_CONTENTS)
@@ -425,16 +426,7 @@
     print >> sys.stderr, ''.join(str_list)
     sys.exit(1)
 
-try:
-    from pyglet.media import avbin
-except:
-    USE_MUSIC = False
-    str_list = []
-    str_list.append('\nAVBin not detected. Music disabled.\n')
-    str_list.append('Download AVBin from: http://code.google.com/p/avbin/\n\n')
-    str_list.append(str(sys.exc_info()))
-    #print >> sys.stderr, ''.join(str_list)
-    print ''.join(str_list)
+USE_MUSIC = False
     
 # Initialize resources (sounds and images)
 #
