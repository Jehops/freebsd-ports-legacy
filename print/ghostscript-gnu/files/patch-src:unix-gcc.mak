--- src/unix-gcc.mak.orig	Tue Jun  5 16:54:10 2001
+++ src/unix-gcc.mak	Fri Jun 15 04:11:50 2001
@@ -27,14 +27,15 @@
 # source, generated intermediate file, and object directories
 # for the graphics library (GL) and the PostScript/PDF interpreter (PS).
 
-BINDIR=./bin
-GLSRCDIR=./src
-GLGENDIR=./obj
-GLOBJDIR=./obj
-PSSRCDIR=./src
-PSLIBDIR=./lib
-PSGENDIR=./obj
-PSOBJDIR=./obj
+.CURDIR?=.
+BINDIR=${.CURDIR}/bin
+GLSRCDIR=${.CURDIR}/src
+GLGENDIR=${.CURDIR}/obj
+GLOBJDIR=${.CURDIR}/obj
+PSSRCDIR=${.CURDIR}/src
+PSLIBDIR=${.CURDIR}/lib
+PSGENDIR=${.CURDIR}/obj
+PSOBJDIR=${.CURDIR}/obj
 
 # Do not edit the next group of lines.
 
@@ -53,17 +54,17 @@
 # the directories also define the default search path for the
 # initialization files (gs_*.ps) and the fonts.
 
-INSTALL = $(GLSRCDIR)/instcopy -c
-INSTALL_PROGRAM = $(INSTALL) -m 755
-INSTALL_DATA = $(INSTALL) -m 644
+INSTALL_PROGRAM = $(BSD_INSTALL_SCRIPT)
+INSTALL_DATA = $(BSD_INSTALL_DATA)
 
-prefix = /usr/local
+prefix = $(PREFIX)
 exec_prefix = $(prefix)
 bindir = $(exec_prefix)/bin
 scriptdir = $(bindir)
 libdir = $(exec_prefix)/lib
 mandir = $(prefix)/man
 man1ext = 1
+man1dir = $(mandir)/man$(man1ext)
 datadir = $(prefix)/share
 gsdir = $(datadir)/ghostscript
 gsdatadir = $(gsdir)/$(GS_DOT_VERSION)
@@ -129,7 +130,7 @@
 # You may need to change this if the IJG library version changes.
 # See jpeg.mak for more information.
 
-JSRCDIR=jpeg
+JSRCDIR=${.CURDIR}/jpeg
 JVERSION=6
 
 # Choose whether to use a shared version of the IJG JPEG library (-ljpeg).
@@ -149,14 +150,14 @@
 # You may need to change this if the libpng version changes.
 # See libpng.mak for more information.
 
-PSRCDIR=libpng
+PSRCDIR=${LOCALBASE}/include
 PVERSION=10008
 
 # Choose whether to use a shared version of the PNG library, and if so,
 # what its name is.
 # See gs.mak and Make.htm for more information.
 
-SHARE_LIBPNG=0
+SHARE_LIBPNG=1
 LIBPNG_NAME=png
 
 # Define the directory where the zlib sources are stored.
@@ -168,7 +169,7 @@
 # what its name is (usually libz, but sometimes libgz).
 # See gs.mak and Make.htm for more information.
 
-SHARE_ZLIB=0
+SHARE_ZLIB=1
 #ZLIB_NAME=gz
 ZLIB_NAME=z
 
@@ -183,7 +184,7 @@
 
 # Define the name of the C compiler.
 
-CC=gcc
+CC?=cc
 
 # Define the name of the linker for the final link step.
 # Normally this is the same as the C compiler.
@@ -218,7 +219,7 @@
 #   gcc to accept ANSI-style function prototypes and function definitions.
 XCFLAGS=
 
-CFLAGS=$(CFLAGS_STANDARD) $(GCFLAGS) $(XCFLAGS)
+#CFLAGS=$(CFLAGS_STANDARD) $(GCFLAGS) $(XCFLAGS)
 
 # Define platform flags for ld.
 # SunOS 4.n may need -Bstatic.
@@ -227,7 +228,7 @@
 #	-R /usr/local/xxx/lib:/usr/local/lib
 # giving the full path names of the shared library directories.
 # XLDFLAGS can be set from the command line.
-XLDFLAGS=
+XLDFLAGS=-L${LOCALBASE}/lib
 
 LDFLAGS=$(XLDFLAGS) -fno-common
 
@@ -260,7 +261,7 @@
 # Note that x_.h expects to find the header files in $(XINCLUDE)/X11,
 # not in $(XINCLUDE).
 
-XINCLUDE=-I/X11R6/include
+XINCLUDE=-I${X11BASE}/include
 
 # Define the directory/ies and library names for the X11 library files.
 # XLIBDIRS is for ld and should include -L; XLIBDIR is for LD_RUN_PATH
@@ -272,12 +273,12 @@
 # Solaris and other SVR4 systems with dynamic linking probably want
 #XLIBDIRS=-L/usr/openwin/lib -R/usr/openwin/lib
 # X11R6 (on any platform) may need
-#XLIBS=Xt SM ICE Xext X11
+XLIBS=Xt SM ICE Xext X11
 
 #XLIBDIRS=-L/usr/local/X/lib
-XLIBDIRS=-L/usr/X11R6/lib
+XLIBDIRS=-L${X11BASE}/lib
 XLIBDIR=
-XLIBS=Xt Xext X11
+#XLIBS=Xt Xext X11
 
 # Define whether this platform has floating point hardware:
 #	FPU_TYPE=2 means floating point is faster than fixed point.
