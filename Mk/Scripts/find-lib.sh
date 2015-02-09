#!/bin/sh
# MAINTAINER: portmgr@FreeBSD.org
# $FreeBSD$

if [ -z "${LIB_DIRS}" -o -z "${LOCALBASE}" ]; then
	echo "LIB_DIRS, LOCALBASE required in environment." >&2
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "$0: no argument provided." >&2
fi

lib=$1
dirs="${LIB_DIRS} `cat ${LOCALBASE}/libdata/ldconfig/* 2>/dev/null || :`"

resolv_symlink() {
	local file tgt
	file=${1}
	if [ ! -L ${file} ] ; then
		echo ${file}
		return
	fi

	tgt=`readlink ${file}`
	case $tgt in
	/*)
		echo $tgt
		return
		;;
	esac

	file=${file%/*}/${tgt}
	absolute_path ${file}
}

absolute_path() {
	local file myifs target
	file=$1

	myifs=${IFS}
	IFS='/'
	set -- ${file}
	IFS=${myifs}
	for el; do
		case $el in
		.) continue ;;
		'') continue ;;
		..) target=${target%/*} ;;
		*) target="${target}/${el}" ;;
		esac
	done
	echo ${target}
}

for libdir in ${dirs} ; do
	test -f ${libdir}/${lib} || continue
	libfile=`resolv_symlink ${libdir}/${lib}`
	[ `file -b -L --mime-type ${libfile}` = "application/x-sharedlib" ] || continue
	echo $libfile
	break
done
