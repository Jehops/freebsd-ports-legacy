
$FreeBSD$

--- bin/runide.sh.orig	Mon Jun  2 11:23:48 2003
+++ bin/runide.sh	Mon Jun  2 11:26:50 2003
@@ -157,7 +157,7 @@
         
         -hotspot|-client|-server|-classic|-native|-green) thread_flag=$1;;
         -J-hotspot|-J-client|-J-server|-J-classic|-J-native|-J-green) thread_flag=`expr $1 : '-J\(.*\)'`;;
-        -J*) jopt=`expr "$1" : '-J\(.*\)'`; jargs="$jargs \"$jopt\"";;
+        -J*) jopt=`expr -- "$1" : '-J\(.*\)'`; jargs="$jargs \"$jopt\"";;
         *) args="$args \"$1\"" ;;
     esac
     shift
