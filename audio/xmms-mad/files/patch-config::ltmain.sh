--- config/ltmain.sh.orig	Mon Sep  2 23:58:38 2002
+++ config/ltmain.sh	Mon Sep  2 23:59:23 2002
@@ -4246,11 +4246,13 @@
 	  IFS="$save_ifs"
 	fi
 
+	if /usr/bin/false; then
 	# Install the pseudo-library for information purposes.
 	name=`$echo "X$file" | $Xsed -e 's%^.*/%%'`
 	instname="$dir/$name"i
 	$show "$install_prog $instname $destdir/$name"
 	$run eval "$install_prog $instname $destdir/$name" || exit $?
+	fi
 
 	# Maybe install the static library, too.
 	test -n "$old_library" && staticlibs="$staticlibs $dir/$old_library"
