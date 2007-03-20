--- machdef.mk.orig	Fri Sep 29 02:47:44 2000
+++ machdef.mk	Fri Sep 29 02:50:54 2000
@@ -27,33 +27,32 @@
 #
 # e93 will install its single executable "e93" in $PREFIX/bin
 # and it will place a directory called "e93lib" in $PREFIX/lib
-PREFIX=/usr/local
 
 
 # The following lines may need to be altered if the Tcl
 # files are located elsewhere on your system:
-TCL_INCLUDE=-I/usr/local/include
-TCL_LIB=-L/usr/local/lib
+TCL_INCLUDE=-I${LOCALBASE}/include/tcl8.4
+TCL_LIB=-L${LOCALBASE}/lib
 # uncomment and change if you want to link with specific versions of Tcl/Tk
-#TCL_VERSION=8.3
+TCL_VERSION=84
+TK_INCLUDE=-I${LOCALBASE}/include/tk8.4
 
 
 # The following lines may need to be altered if the X include and library
 # files are located elsewhere on your system:
-X_INCLUDE=-I/usr/X11R6/include
-X_LIB=-L/usr/X11R6/lib
+X_INCLUDE=-I${X11BASE}/include
+X_LIB=-L${X11BASE}/lib
 
 
 # if your system needs some extra libraries, add them here:
-EXTRALIBS=-lm -ldl
+EXTRALIBS=-lm 
 
 # Uncomment this line if running Solaris:
 #MACHINESPEC=-DSOLARIS
 
 # set compiler to use
-CC=gcc
 
 
 # set some compiler options
-OPTIONS=-O2 -Wall -x c++ -g
+OPTIONS=-Wall -x c++
 #OPTIONS = -Wall -O2 -x c++ -mcpu=21164a -Wa,-m21164a -g
