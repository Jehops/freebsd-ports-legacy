--- frontpage/version5.0/fp_install.sh.orig	Mon Apr 16 07:39:25 2001
+++ frontpage/version5.0/fp_install.sh	Tue Feb 12 17:37:58 2002
@@ -12,7 +12,7 @@
 main() {
     initialize
     step1                               # setup environment
-    step2                               # untar
+#    step2                               # untar
     $FPDIR/set_default_perms.sh         # Run the external permissions script.
     step3                               # upgrade/install
     
@@ -52,7 +52,7 @@
     echo 
     
     migrateoldconfig        || error   # Migrate old frontpage.cnf (if any)
-    change_server           || error   # upgrade httpd
+#    change_server           || error   # upgrade httpd
     upgradeexistingservers  || error   # Check to see if servers need upgrading
     upgrade="yes"
     chownexistingservers    || error   # Now chown the webs
@@ -132,10 +132,12 @@
 {
     VERSION="5.0"
     PATH=".:/bin:/usr/bin:/sbin:/usr/sbin:/usr/ucb:/etc:/usr/bsd"
-    INSTALLDIRDEFAULT="/usr/local/frontpage"
+    AP_TARGET=`PREFIX/sbin/apxs -q TARGET`
+    AP_CONFDIR=`PREFIX/sbin/apxs -q SYSCONFDIR`
+    INSTALLDIRDEFAULT="PREFIX/frontpage"
     NEWHTTPDNEW="/usr/local/frontpage/version${VERSION}/apache-fp/httpd"
     DEFAULTHTTPD="/usr/local/apache/sbin/httpd"
-    FPDIR="/usr/local/frontpage/version${VERSION}"
+    FPDIR="PREFIX/frontpage/version${VERSION}"
 
     case "`echo 'x\c'`" in
        'x\c')   echo="echo -n"    nnl= ;;      #BSD
@@ -390,29 +392,9 @@
 {
     retval=0
     
-    cat <<EOF
-
-Where would you like to install the FrontPage Server Extensions.  If
-you select a location other than /usr/local/frontpage/ then a symbolic
-link will be created from /usr/local/frontpage/ to the location that
-is chosen.
-
-EOF
-    $echo "FrontPage Server Extensions directory [/usr/local/frontpage/]:  ${nnl}"
-    read installdir
-    
-    if [ "$installdir" = "" ]
-    then
         installdir=$INSTALLDIRDEFAULT
-    fi
     installdir=`dirname $installdir`/`basename $installdir`
 
-    if [ ! -d "$installdir" ]
-    then
-        echo "Creating $installdir" 
-        if mkdir "$installdir"
-        then
-            echo "Directory $installdir has been created." 
             if chmod "$prot" "$installdir"
             then
                 echo "Directory $installdir chmoded to $prot." 
@@ -420,22 +402,6 @@
                 echo "ERROR:  Unable to chmod $installdir to $prot." 
                 retval=1
             fi
-        else
-            echo "ERROR:  Unable to create $installdir!" 
-            retval=1
-        fi
-    else
-        echo "WARNING:  Directory $installdir already exists." 
-        echo "Installation will overwrite existing files." 
-        echo 
-        
-        myprompt 'yYnN' "Continue the installation (y/n)" "N"
-        echo 
-        if [ $answer = n ] || [ $answer = N ]
-        then
-            exit 0
-        fi
-    fi
     
     if [ "$installdir" != "/usr/local/frontpage" ]
     then
@@ -805,16 +771,22 @@
                 accessconffile="${configfiledir}${file}"
                 ;;
         esac
+	if [ ! -f $accessconffile ]
+	then
+	    echo "ERROR:  $accessconffile does not exist! Using $configfile instead."
+	    accessconffile=$configfile
+	fi
     else
         accessconffile="${configfiledir}access.conf"
         if [ ! -f $accessconffile ]
         then
+	    echo "ERROR: No AccessConfig directive found, add 'AccessConfig /dev/null' to $configfile"
             accessconffile=$configfile
         fi
     fi
     if [ "$accessconffile" != "" -a "$accessconffile" != "/dev/null" -a ! -f "$accessconffile" ]
     then
-        echo "$accessconffile does not exist."
+        echo "ERROR: $accessconffile does not exist!"
         return 1
     fi
 
@@ -1290,20 +1262,30 @@
     echo " " 
     
     webname="/"
+    defconfigfile="${AP_CONFDIR}/${AP_TARGET}.conf"
     
     configfile=""
     while ( [ "$configfile" = "" ] || [ ! -f $configfile ] )
     do
-        $echo "Server config filename:  ${nnl}" 
+        $echo "Server config filename:  [$defconfigfile] ${nnl}" 
         read configfile
+        if [ "$configfile" = "" ]
+        then
+            configfile=$defconfigfile
+        fi
     done
     httpdconfigfile=$configfile
     
+    defadmin="fpadmin"
     admin=""
     until [ "$admin" != "" ]
     do
-        $echo "FrontPage Administrator's user name:  ${nnl}" 
+        $echo "FrontPage Administrator's user name:  [$defadmin] ${nnl}" 
         read admin
+	if [ "$admin" = "" ]
+	then
+	    admin=$defadmin
+	fi
     done
     
     getHttpRootDirective $configfile Port
@@ -1316,9 +1298,23 @@
     done
     weconfigfile="${installdir}/we${port}.cnf"
     
+    getHttpRootDirective $configfile DocumentRoot
+    docroot=$param
+    if [ ! -d "$docroot" ]
+    then
+        echo "ERROR: $docroot does not exist!"
+        return 1
+    fi
+
     echo 
     getparam User $configfile $port "Getting User from "
     defwebowner=$param
+
+    if [ "$defwebowner" = "" ]
+    then
+	defwebowner=`$lsg ${docroot}${service} | $awk ' { print $3}'`
+    fi
+
     webowner=""
     until [ "$webowner" != "" ]
     do
@@ -1333,6 +1329,12 @@
     echo 
     getparam Group $configfile $port "Getting Group from "
     defgroup=$param
+
+    if [ "$defgroup" = "" ]
+    then
+	defgroup=`$lsg ${docroot}${service} | $awk ' { print $4}'`
+    fi
+
     webgroup=""
     until [ "$webgroup" != "" ]
     do
@@ -1464,7 +1466,7 @@
         return $retval
     fi
     
-    defaultconfigfile=$configfile
+    defaultconfigfile="${AP_CONFDIR}/${AP_TARGET}.conf"
     configfile=""
     while ( [ "$configfile" = "" ] || [ ! -f $configfile ] )
     do
@@ -1922,10 +1924,16 @@
                 resconffile="${configfiledir}${file}"
                 ;;
         esac
+	if [ ! -f $resconffile ]
+	then
+	    echo "ERROR:  $resconffile does not exist! Using $configfile instead."
+	    resconffile=$configfile
+	fi
     else
         resconffile="${configfiledir}srm.conf"
         if [ ! -f $resconffile ]
         then
+	    echo "ERROR: No ResourceConfig directive found, add 'ResourceConfig /dev/null' to $configfile"
             resconffile=$configfile
         fi
     fi
@@ -1999,7 +2007,7 @@
     
     param=`cat $configfile | $awk "
             /^[^#]* *< *${virtualhost}/,/^[^#]* *< *\/${virtualhost}/ { next }
-            /^[^#]* *${mc_string}[ $TAB]/  { print \\\$2 }"` 
+            /^[^#]* *${mc_string}[ $TAB]/  { print \\\$2 }" | sed -e 's/"//g'` 
             
     return 0
 }
@@ -2050,7 +2058,7 @@
                                     print ARRAY[i] 
                                 }
                             }
-                    } "`
+                    } " | sed -e 's/"//g'`
     
     if [ "$param" = "" ]
     then
