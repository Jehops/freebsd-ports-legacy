--- ./ros/env.csh.orig	2008-09-03 07:44:21.000000000 +0200
+++ ./ros/env.csh	2008-10-01 00:02:45.000000000 +0200
@@ -1,16 +1,18 @@
 #!/bin/csh -f
 
-setenv CASROOT "Open CASCADE location/ros"
+setenv CASROOT %%CASROOT%%
 set OS_NAME=`uname`
 if ( $?PATH ) then
-      setenv PATH $CASROOT/../3rdparty/$OS_NAME/tcltk/bin:$CASROOT/$OS_NAME/bin:$PATH
+      setenv PATH %%LOCALBASE%%/bin:$CASROOT/$OS_NAME/bin:$PATH
 else
-      setenv PATH $CASROOT/../3rdparty/$OS_NAME/tcltk/bin:$CASROOT/$OS_NAME/bin
+      setenv PATH %%LOCALBASE%%/bin:$CASROOT/$OS_NAME/bin
 endif
-if ( $?LD_LIBRARY_PATH ) then
+if ( $OS_NAME != "FreeBSD" ) then
+  if ( $?LD_LIBRARY_PATH ) then
       setenv LD_LIBRARY_PATH $CASROOT/../3rdparty/$OS_NAME/tcltk/lib:$CASROOT/$OS_NAME/lib:$LD_LIBRARY_PATH
-else
+  else
       setenv LD_LIBRARY_PATH $CASROOT/../3rdparty/$OS_NAME/tcltk/lib:$CASROOT/$OS_NAME/lib
+  endif
 endif
 setenv CSF_MDTVFontDirectory $CASROOT/src/FontMFT
 setenv CSF_LANGUAGE us
@@ -30,7 +32,7 @@
 setenv CSF_STEPDefaults $CASROOT/src/XSTEPResource
 setenv CSF_XmlOcafResource $CASROOT/src/XmlOcafResource
 
-setenv TCLHOME $CASROOT/../3rdparty/$OS_NAME/tcltk
+setenv TCLHOME %%LOCALBASE%%
 setenv TCLLIBPATH $TCLHOME/lib
 if ( $OS_NAME == "SunOS" ) then
       setenv ITK_LIBRARY $TCLLIBPATH/itk3.2
@@ -38,6 +40,12 @@
       setenv TIX_LIBRARY $TCLLIBPATH/tix8.1
       setenv TK_LIBRARY $TCLLIBPATH/tk8.4
       setenv TCL_LIBRARY $TCLLIBPATH/tcl8.4
+else if ( $OS_NAME == "FreeBSD" ) then
+      setenv ITK_LIBRARY $TCLLIBPATH/itk%%ITKMM%%
+      setenv ITCL_LIBRARY $TCLLIBPATH/itcl%%ITCLMM%%
+      setenv TIX_LIBRARY $TCLLIBPATH/Tix%%TIX_MM%%
+      setenv TK_LIBRARY %%TK_LIBDIR%%
+      setenv TCL_LIBRARY %%TCL_LIBDIR%%
 else if ( $OS_NAME == "Linux" ) then
       setenv ITK_LIBRARY $TCLLIBPATH/itk3.2
       setenv ITCL_LIBRARY $TCLLIBPATH/itcl3.2
