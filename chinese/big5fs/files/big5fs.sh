#!/bin/sh

case "$1" in
start)
	if [ -x @@PREFIX@@/modules/big5cd9660.ko ]; then
		echo -n ' Big5-cd9660'
		kldload /usr/local/modules/big5cd9660.ko
	fi
	if [ -x @@PREFIX@@/modules/big5msdos.ko ]; then
		echo -n ' Big5-msdos'
		kldload /usr/local/modules/big5msdos.ko
	fi
	;;
stop)
	kldunload -v -n big5cd9660 && echo -n ' Big5-cd9660'
	kldunload -v -n big5msdos && echo -n ' Big5-msdos'
	;;
*)
	echo "Usage: big5fs.sh {start|stop}" >&2
	exit 1
	;;
esac
