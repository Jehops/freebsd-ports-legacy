#!/bin/sh
#
# distclean
# Compare distfiles in /usr/ports/distfiles
# with currently instaled ports collection
# and removes outdated files
#
# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42, (c) Poul-Henning Kamp):
# Maxim Sobolev <sobomax@altavista.net wrote this file.  As long as you retain
# this notice you can do whatever you want with this stuff. If we meet some
# day, and you think this stuff is worth it, you can buy me a beer in return.
#
# Maxim Sobolev
# ----------------------------------------------------------------------------
#
# $FreeBSD: /tmp/pcvs/ports/Tools/scripts/distclean.sh,v 1.3 2000-06-06 10:05:06 sobomax Exp $
#
# MAINTAINER= sobomax@FreeBSD.org

PATH=/sbin:/bin:/usr/bin

echo "Distfiles clean utility v0.40 by Maxim Sobolev <sobomax@altavista.net>."
echo "Assumes that your ports in /usr/ports and distfiles in /usr/ports/distfiles."
echo ""

umask 077

FN_PORTS=`mktemp -t dclean` || exit 1
FN_DISTFILES=`mktemp -t dclean` || exit 1
FN_RESULTS_SCRIPT=`mktemp -t dclean` || exit 1

echo -n "Building ports md5 index..."
find /usr/ports/ -name "md5" -type f | xargs cat | grep "^MD5 ("| sort | uniq > $FN_PORTS
echo "Done."
P_MD5_COUNT=`wc -l $FN_PORTS | sed "s| $FN_PORTS|| ; s| ||g"`
echo "Found $P_MD5_COUNT md5 entries in your ports directory."

echo -n "Building distfiles md5 index..."
find /usr/ports/distfiles/ -type f | xargs md5 | sed 's|/usr/ports/distfiles/||' | sort > $FN_DISTFILES
echo "Done."
D_MD5_COUNT=`wc -l $FN_DISTFILES | sed "s| $FN_DISTFILES|| ; s| ||g"`
echo "Found $D_MD5_COUNT distfile(s) in your distfiles directory."

echo -n "Comparing results..."
diff -d $FN_DISTFILES $FN_PORTS | grep "^<" | sed 's|.*(|rm -i /usr/ports/distfiles/| ; s|).*||' > $FN_RESULTS_SCRIPT
echo "Done."
R_MD5_COUNT=`wc -l $FN_RESULTS_SCRIPT | sed "s| $FN_RESULTS_SCRIPT|| ; s| ||g"`
echo "$R_MD5_COUNT distfile(s) doesn't have corresponding md5 entries in ports directory."
/bin/sh $FN_RESULTS_SCRIPT

echo -n "Finishing..."
rm -f $FN_RESULTS_SCRIPT $FN_PORTS $FN_DISTFILES
echo "Done."

