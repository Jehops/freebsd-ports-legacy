#!/bin/sh
#
# distclean
# Compare distfiles in /usr/ports/distfiles
# with currently instaled ports collection
# and removes outdated files
#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42, (c) Poul-Henning Kamp):
# Maxim Sobolev <sobomax@FreeBSD.org> wrote this file.  As long as you retain
# this notice you can do whatever you want with this stuff. If we meet some
# day, and you think this stuff is worth it, you can buy me a beer in return.
#
# Maxim Sobolev
# ----------------------------------------------------------------------------
#
# $FreeBSD: /tmp/pcvs/ports/Tools/scripts/distclean.sh,v 1.10 2001-07-30 14:24:12 sobomax Exp $
#
# MAINTAINER= sobomax@FreeBSD.org

PATH=/sbin:/bin:/usr/bin

cleanup() {
	rm -f $FN_RESULTS_SCRIPT $FN_PORTS $FN_DISTFILES
	echo "Terminated."
	exit 1
}

echo "Distfiles clean utility by Maxim Sobolev <sobomax@FreeBSD.org>."
echo "Assumes that your ports in /usr/ports and distfiles in /usr/ports/distfiles."
echo ""

if [ x"$1" = x"-f" ]; then
	RM_FLAG="-f"	
else
	RM_FLAG="-i"
	echo "Use \"`basename $0` -f\" to remove the files without prompting for confirmation."
	echo ""
fi

umask 077

FN_PORTS=`mktemp -t dclean` || exit 1
FN_DISTFILES=`mktemp -t dclean` || exit 1
FN_RESULTS_SCRIPT=`mktemp -t dclean` || exit 1

trap cleanup 1 2 3 4 5 6 7 8 10 11 12 13 14 15 16 21 22 23 24 25 26 27 28 29 \
	     30 31

echo -n "Building ports md5 index..."
find /usr/ports/ -name "distinfo" -or -name "distinfo.i386" -or -name "distinfo.alpha" -type f | xargs cat | grep "^MD5 ("| sort | uniq > $FN_PORTS
echo "Done."
P_MD5_COUNT=`wc -l $FN_PORTS | sed "s| $FN_PORTS|| ; s| ||g"`
echo "Found $P_MD5_COUNT md5 entries in your ports directory."

echo -n "Building distfiles md5 index..."
find /usr/ports/distfiles/ -type f | xargs md5 | sed 's|/usr/ports/distfiles/||' | sort > $FN_DISTFILES
echo "Done."
D_MD5_COUNT=`wc -l $FN_DISTFILES | sed "s| $FN_DISTFILES|| ; s| ||g"`
echo "Found $D_MD5_COUNT distfile(s) in your distfiles directory."

echo -n "Comparing results..."
diff -d $FN_DISTFILES $FN_PORTS | grep "^<" | sed 's|.*(|rm '$RM_FLAG' /usr/ports/distfiles/| ; s|).*||' > $FN_RESULTS_SCRIPT
echo "Done."
R_MD5_COUNT=`wc -l $FN_RESULTS_SCRIPT | sed "s| $FN_RESULTS_SCRIPT|| ; s| ||g"`
echo "$R_MD5_COUNT distfile(s) doesn't have corresponding md5 entries in ports directory."
/bin/sh $FN_RESULTS_SCRIPT

echo -n "Finishing..."
rm -f $FN_RESULTS_SCRIPT $FN_PORTS $FN_DISTFILES
echo "Done."

