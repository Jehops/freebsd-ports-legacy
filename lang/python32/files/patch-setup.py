--- setup.py.orig	Tue Jun 17 11:51:28 2003
+++ setup.py	Fri Jul  4 17:33:05 2003
@@ -15,7 +15,7 @@
 from distutils.command.install_lib import install_lib
 
 # This global variable is used to hold the list of modules to be disabled.
-disabled_module_list = []
+disabled_module_list = ["_tkinter", "gdbm", "mpz", "pyexpat"]
 
 def add_dir_to_list(dirlist, dir):
     """Add the directory 'dir' to the list 'dirlist' (at the front) if
@@ -1127,7 +1127,7 @@
           ext_modules=[Extension('struct', ['structmodule.c'])],
 
           # Scripts to install
-          scripts = ['Tools/scripts/pydoc', 'Tools/scripts/idle']
+          scripts = []
         )
 
 # --install-platlib
