
$FreeBSD$

--- libcharset/autoconf/ltmain.sh	2001/08/27 09:21:11	1.1
+++ libcharset/autoconf/ltmain.sh	2001/08/27 09:21:41
@@ -4175,10 +4175,12 @@
 	fi
 
 	# Install the pseudo-library for information purposes.
+	if /usr/bin/false; then
 	name=`$echo "X$file" | $Xsed -e 's%^.*/%%'`
 	instname="$dir/$name"i
 	$show "$install_prog $instname $destdir/$name"
 	$run eval "$install_prog $instname $destdir/$name" || exit $?
+	fi
 
 	# Maybe install the static library, too.
 	test -n "$old_library" && staticlibs="$staticlibs $dir/$old_library"
