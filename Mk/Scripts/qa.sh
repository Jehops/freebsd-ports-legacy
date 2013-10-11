#!/bin/sh
# MAINTAINER: portmgr@FreeBSD.org
# $FreeBSD$

if [ -z "${STAGEDIR}" -o -z "${PREFIX}" -o -z "${LOCALBASE}" ]; then
	echo "STAGEDIR, PREFIX, LOCALBASE required in environment." >&2
	exit 1
fi

warn() {
	echo "Warning: $@" >&2
}

err() {
	echo "Error: $@" >&2
}

shebang() {
	rc=0
	for f in `find ${STAGEDIR} -type f`; do
		interp=$(sed -n -e '1s/^#![[:space:]]*\([^[:space:]]*\).*/\1/p' $f)
		case "$interp" in
		"") ;;
		/usr/bin/env) ;;
		${LOCALBASE}/*) ;;
		${PREFIX}/*) ;;
		/usr/bin/awk) ;;
		/usr/bin/sed) ;;
		/bin/sh) ;;
		*)
			err "${interp} is an invalid shebang you need USES=shebangfix for ${f#${STAGEDIR}${PREFIX}/}"
			rc=1
			;;
		esac
	done
}

symlinks() {
	rc=0
	for l in `find ${STAGEDIR} -type l`; do
		link=$(readlink ${l})
		case "${link}" in
		${STAGEDIR}*) err "Bad symlinks ${l} pointing inside the stage directory"
			rc=1
			;;
		esac
	done
}

paths() {
	rc=0
	dirs="${STAGEDIR} ${WRKDIR}"
	for f in `find ${STAGEDIR} -type f`;do
		for d in ${dirs}; do
			if grep -q ${d} ${f} ; then
				err "${f} is referring to ${d}"
				rc=1
			fi
		done
	done
}

# For now do not raise an error, just warnings
stripped() {
	[ -x /usr/bin/file ] || return
	for f in `find ${STAGEDIR} -type f`; do
		output=`/usr/bin/file ${f}`
		case "${output}" in
		*:*\ ELF\ *,\ not\ stripped*) warn "${f} is not stripped";;
		esac
	done
}

desktopfileutils() {
	if [ -z "${USESDESKTOPFILEUTILS}" ]; then
		grep -q MimeType= ${STAGEDIR}${PREFIX}/share/applications/*.desktop 2>/dev/null &&
		warn "you need USES=desktop-file-utils"
	else
		grep -q MimeType= ${STAGEDIR}${PREFIX}/share/applications/*.desktop 2>/dev/null ||
		warn "you may not need USES=desktop-file-utils"
	fi
	return 0
}

sharedmimeinfo() {
	if [ -z "${USESSHAREDMIMEINFO}" ]; then
		find ${STAGEDIR}${PREFIX}/share/mime/packages/*.xml ! -name "freedesktop\.org\.xml" -quit 2>/dev/null &&
		warn "you need USES=shared-mime-info"
	else
		find ${STAGEDIR}${PREFIX}/share/mime/packages/*.xml ! -name "freedesktop\.org\.xml" -quit 2>/dev/null ||
		warn "you may not need USES=shared-mime-info"
	fi
	return 0
}

checks="shebang symlinks paths stripped desktopfileutils sharedmimeinfo"

ret=0
cd ${STAGEDIR}
for check in ${checks}; do
	${check} || ret=1
done

exit $ret
