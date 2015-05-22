diff -ruN gpsman.tcl gpsman.tcl
--- gpsman.tcl	Tue May  9 02:37:24 2006
+++ gpsman.tcl	Wed May 10 17:56:02 2006
@@ -1,6 +1,6 @@
 #!/bin/sh
 # This is a Tcl/Tk script to be interpreted by wish (Tk8.3 or better): \
-exec wish "$0" -- "$@"
+exec %%WISH%% "$0" -- "$@"
 
 #
 #  gpsman --- GPS Manager: a manager for GPS receiver data
@@ -247,7 +247,7 @@
 }
 
  # path to directory containing program files
-set SRCDIR gmsrc
+set SRCDIR %%GPSMANDIR%%/gmsrc
 
 # all other defaults configuration is now done in file $SRCDIR/config.tcl
 
