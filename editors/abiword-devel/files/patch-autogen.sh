
$FreeBSD$

--- autogen.sh.orig	Fri Sep 28 12:06:00 2001
+++ autogen.sh	Fri Nov 23 16:33:29 2001
@@ -10,20 +10,20 @@
 
 set -e
 
-automake --version | perl -ne 'if (/\(GNU automake\) ([0-9].[0-9])/) {print;  if ($1 < 1.4) {exit 1;}}'
+automake14 --version | perl -ne 'if (/\(GNU automake\) ([0-9].[0-9])/) {print;  if ($1 < 1.4) {exit 1;}}'
 
 if [ $? -ne 0 ]; then
     echo "Error: you need automake 1.4 or later.  Please upgrade."
     exit 1
 fi
 
-if test ! -d `aclocal --print-ac-dir`; then
+if test ! -d `aclocal14 --print-ac-dir`; then
   echo "Bad aclocal (automake) installation"
   exit 1
 fi
 
 for script in `cd ac-helpers/fallback; echo *.m4`; do
-  if test -r `aclocal --print-ac-dir`/$script; then
+  if test -r `aclocal14 --print-ac-dir`/$script; then
     # Perhaps it was installed recently
     rm -f ac-helpers/$script
   else
@@ -34,13 +34,13 @@
 
 # Produce aclocal.m4, so autoconf gets the automake macros it needs
 echo "Creating aclocal.m4..."
-aclocal -I ac-helpers
+aclocal14 -I ac-helpers
 
-# autoheader
+# autoheader14
 
 # Produce all the `Makefile.in's, verbosely, and create neat missing things
 # like `libtool', `install-sh', etc.
-automake --add-missing --verbose --foreign
+automake14 --add-missing --verbose --foreign
 
 # If there's a config.cache file, we may need to delete it.  
 # If we have an existing configure script, save a copy for comparison.
@@ -50,7 +50,7 @@
 
 # Produce ./configure
 echo "Creating configure..."
-autoconf
+autoconf213
 
 echo ""
 echo "You can run ./configure now."
