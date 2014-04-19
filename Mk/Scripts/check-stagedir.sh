#!/bin/sh
# ports/Mk/Scripts/check-stagedir.sh - called from ports/Mk/bsd.stage.mk
# $FreeBSD$
#
# MAINTAINER: portmgr@FreeBSD.org
#
# This script serves 2 purposes:
# 1. Generate a plist
# 2. Test a plist for issues:
#  a. Files in STAGEDIR that are missing from plist
#  b. Files in plist missing from STAGEDIR
#  c. Files in plist which are owned by dependencies/MTREEs

set -e
export LC_ALL=C
ret=0

# lists an mtree file's contents, prefixed to dir.
listmtree() { # mtreefile prefix
	{
		echo '#mtree'
		sed 's/nochange$//;' $1
	} | tar -tf- | sed "s,^,$2/,;s,^$2/\.$,$2,;s,^$,/,"
}

# obtain operating mode from command line
makeplist=0
case "$1" in
	checkplist)	;;
	makeplist)	makeplist=1 ;;
	*) echo >&2 "Usage: $0 {checkplist|makelist}" ; exit 1 ;;
esac

# validate environment
envfault=
for i in STAGEDIR PREFIX LOCALBASE WRKDIR WRKSRC MTREE_FILE GNOME_MTREE_FILE \
    TMPPLIST PLIST_SUB_SED SCRIPTSDIR PACKAGE_DEPENDS WITH_PKGNG PKG_QUERY \
    PORT_OPTIONS NO_PREFIX_RMDIR
do
    if ! ( eval ": \${${i}?}" ) 2>/dev/null ; then
		envfault="${envfault}${envfault:+" "}${i}"
    fi
done
if [ -n "$envfault" ] ; then
	echo "Environment variables $envfault undefined. Aborting." \
	| fmt >&2
	exit 1
fi

set -u

#### EXPAND TMPPLIST TO ABSOLUTE PATHS, SPLITTING FILES AND DIRS TO
#    Use file descriptors 1 and 3 so that the while loop can write
#    files to the pipe and dirs to a separate file.
if [ $makeplist = 0 ] ; then
	# check for orphans
	echo "===> Checking for items in STAGEDIR missing from pkg-plist"

	cwd=${PREFIX}
	while read line; do
		# Handle deactivated OPTIONS. Treat "@comment file" as being in
		# the plist so it does not show up as an orphan. PLIST_SUB uses
		# a @comment to deactive files. XXX: It would be better to
		# make all ports use @ignore instead of @comment.
		comment=
		if [ ${makeplist} -eq 0 -a -z "${line%%@comment *}" ]; then
			line="${line#@comment }"
			# Remove @comment so it can be parsed as a file,
			# but later prepend it again to create a list of
			# all files commented and uncommented.
			comment="@comment "
		fi

		case $line in
		@dirrm*|'@unexec rmdir'*)
			line="$(printf %s "$line" \
			    | sed -Ee 's/\|\|.*//;s|[0-9]*[[:space:]]*>[&]?[[:space:]]*[^[:space:]]+||g' \
				-e "/^@unexec[[:space:]]+rmdir/s|([^%])%D([^%])|\1${PREFIX}\2|g" \
				-e '/^@unexec[[:space:]]+rmdir/s|"(.*)"[[:space:]]+|\1|g' \
				-e 's/@unexec[[:space:]]+rmdir[[:space:]]+//' \
				-e 's/@dirrm(try)?[[:space:]]+//' \
				-e 's/[[:space:]]+$//')"
			case "$line" in
			/*) echo >&3 "${comment}${line%/}" ;;
			*)  echo >&3 "${comment}${cwd}/${line%/}" ;;
			esac
		;;
		# Handle [file] Keywords
		@info\ *|@sample\ *)
			set -- $line
			shift
			echo "${comment}${cwd}/$@"
		;;
		# Handle [dirrmty] Keywords
		@fc\ *|@fcfontsdir\ *|@fontsdir\ *)
			set -- $line
			shift
			echo "${comment}@dirrmtry ${cwd}/$@"
		;;

		# order matters here - we must check @cwd first because
		# otherwise the @cwd* would also match it first, shadowing the
		# @cwd) line.
		@cwd|@cd) cwd=${PREFIX} ;;
		@cwd*|@cd*)
			set -- $line
			cwd=$2
			# Don't set cwd=/ as it causes // in plist and
			# won't match later.
			[ "${cwd}" = "/" ] && cwd=
			;;
		@*) ;;
		/*) echo "${comment}${line}" ;;
		*)  echo "${comment}${cwd}/${line}" ;;
		esac
	done < ${TMPPLIST} 3>${WRKDIR}/.plist-dirs-unsorted | \
	    sort >${WRKDIR}/.plist-files
	unset TMPPLIST
	# Create the -no-comments files and trim out @comment from the plists.
	# This is used for various tests later.
	sed -e '/^@comment/d' ${WRKDIR}/.plist-dirs-unsorted \
	    >${WRKDIR}/.plist-dirs-unsorted-no-comments
	sed -i '' -e 's/^@comment //' ${WRKDIR}/.plist-dirs-unsorted
	sed -e '/^@comment/d' ${WRKDIR}/.plist-files \
	    >${WRKDIR}/.plist-files-no-comments
	sed -i '' -e 's/^@comment //' ${WRKDIR}/.plist-files
else
	# generate plist - pretend the plist had been empty
	: >${WRKDIR}/.plist-dirs-unsorted
	: >${WRKDIR}/.plist-files
	echo '/you/have/to/check/what/makeplist/gives/you'
fi

### PRODUCE MTREE FILE
{
	listmtree /etc/mtree/BSD.root.dist ""
	listmtree /etc/mtree/BSD.usr.dist /usr
	listmtree /etc/mtree/BSD.var.dist /var

	# Use MTREE_FILE if specified and it doesn't already match LOCALBASE
	if [ -n "${MTREE_FILE}" ]; then
		if [ "${PREFIX}" != "${LOCALBASE}" -o \
		    "${MTREE_FILE}" != "${PORTSDIR}/Templates/BSD.local.dist" \
		    ]; then
			listmtree "${MTREE_FILE}" "${PREFIX}"
		fi
	fi
	listmtree "${PORTSDIR}/Templates/BSD.local.dist" "${LOCALBASE}"

	if [ -n "${GNOME_MTREE_FILE}" ]; then
		listmtree "${GNOME_MTREE_FILE}" "${PREFIX}"
	fi
	unset MTREE_FILE GNOME_MTREE_FILE

	# Add in PREFIX if this port wants it
	if [ ${NO_PREFIX_RMDIR} -eq 0 ]; then
		a=${PREFIX}
		while :; do
			echo ${a}
			a=${a%/*}
			[ -z "${a}" ] && break
		done
	fi
} >${WRKDIR}/.mtree

### GATHER DIRS OWNED BY RUN-DEPENDS. WHY ARE WE SCREAMING?
: >${WRKDIR}/.run-depends-dirs
if [ -n "${WITH_PKGNG}" ]; then
	echo "${PACKAGE_DEPENDS}" | xargs ${PKG_QUERY} "%D" | \
	    sed -e 's,/$,,' | sort -u >>${WRKDIR}/.run-depends-dirs
else
	# Evaluate ACTUAL-PACKAGE-DEPENDS
	packagelist=
	package_depends=$(eval ${PACKAGE_DEPENDS})
	if [ -n "${package_depends}" ]; then
		# This ugly mess can go away with pkg_install EOL
		awk_script=$(cat <<'EOF'
			/Deinstall directory remove:/ {print $4}
			/UNEXEC 'rmdir "[^"]*" 2>\/dev\/null \|\| true'/ {
				gsub(/"%D\//, "\"", $0)
				match($0, /"[^"]*"/)
				dir=substr($0, RSTART+1, RLENGTH-2)
				print dir
			}
EOF
)
		echo "${package_depends}" | while read line; do
			${PKG_QUERY} -f ${line%%:*} | \
			    awk "${awk_script}" | \
			    sed -e "/^[^/]/s,^,${LOCALBASE}/,"
		done | sort -u >>${WRKDIR}/.run-depends-dirs
	fi
fi
unset PACKAGE_DEPENDS PKG_QUERY

### HANDLE PORTDOCS/PORTEXAMPLES
sed_portdocsexamples="/%%DOCSDIR%%/s!^!%%PORTDOCS%%!g; /%%EXAMPLESDIR%%/s!^!%%PORTEXAMPLES%%!g;"
if [ ${makeplist} -eq 0 ]; then
#	echo "=====> Using OPTIONS: ${PORT_OPTIONS}" | /usr/bin/fmt -w 79 | \
#	    sed -e '2,$s/^/                      /'
	# Handle magical PORT* features
	for option in DOCS EXAMPLES; do
		want_option=0
		case " ${PORT_OPTIONS} " in
		*\ ${option}\ *) want_option=1 ;;
		esac
		[ ${want_option} -eq 0 ] && \
		    sed_portdocsexamples="${sed_portdocsexamples} /^%%PORT${option}%%/d;"
	done
	unset PORT_OPTIONS
fi

sed_plist_sub=$(echo "${PLIST_SUB_SED}" | /bin/sh ${SCRIPTSDIR}/plist_sub_sed_sort.sh)
unset PLIST_SUB_SED
sed_files="s!${PREFIX}/!!g; ${sed_plist_sub} ${sed_portdocsexamples} \
    /^share\/licenses/d;"

sed_dirs="s!${PREFIX}/!!g; ${sed_plist_sub} s,^,@dirrmtry ,; \
    ${sed_portdocsexamples} \
    s!@dirrmtry \(/.*\)!@unexec rmdir \"\1\" >/dev/null 2>\&1 || :!; \
    /^@dirrmtry share\/licenses/d;"

# If checking orphans, send all output to a temp file so whitelisting can be
# done
: >${WRKDIR}/.staged-plist

### HANDLE FILES
find ${STAGEDIR} -type f -o -type l | sort | \
    sed -e "s,${STAGEDIR},," >${WRKDIR}/.staged-files
comm -13 ${WRKDIR}/.plist-files ${WRKDIR}/.staged-files | \
    sed -e "${sed_files}" \
     >>${WRKDIR}/.staged-plist || :

### HANDLE DIRS
cat ${WRKDIR}/.plist-dirs-unsorted ${WRKDIR}/.mtree \
    ${WRKDIR}/.run-depends-dirs | sort -u >${WRKDIR}/.traced-dirs
find ${STAGEDIR} -type d | sed -e "s,^${STAGEDIR},,;/^$/d" | \
    sort >${WRKDIR}/.staged-dirs
comm -13 ${WRKDIR}/.traced-dirs ${WRKDIR}/.staged-dirs \
    | sort -r | sed "${sed_dirs}" \
    >>${WRKDIR}/.staged-plist || :

# If just making plist, show results and exit successfully.
if [ ${makeplist} -eq 1 ]; then
	cat ${WRKDIR}/.staged-plist
	exit 0
fi

# Handle whitelisting
while read path; do
	case "${path}" in
	*.bak) ;;
	*.orig) ;;
	#*/info/dir|info/dir) ;;
	*)
		# An orphan was found, return non-zero status
		ret=1
		echo "Error: Orphaned: ${path}" >&2
	;;
	esac
done < ${WRKDIR}/.staged-plist

sort -u ${WRKDIR}/.plist-dirs-unsorted-no-comments \
    >${WRKDIR}/.plist-dirs-sorted-no-comments

# Anything listed in plist and in restricted-dirs is a failure. I.e.,
# it's owned by a run-time dependency or one of the MTREEs.
echo "===> Checking for directories owned by dependencies or MTREEs"
cat ${WRKDIR}/.mtree ${WRKDIR}/.run-depends-dirs | sort -u \
    >${WRKDIR}/.restricted-dirs
: >${WRKDIR}/.invalid-plist-dependencies
comm -12 ${WRKDIR}/.plist-dirs-sorted-no-comments ${WRKDIR}/.restricted-dirs \
    | sort -r | sed "${sed_dirs}" \
    >>${WRKDIR}/.invalid-plist-dependencies || :
if [ -s "${WRKDIR}/.invalid-plist-dependencies" ]; then
	ret=1
	while read line; do
		echo "Error: Owned by dependency: ${line}" >&2
	done < ${WRKDIR}/.invalid-plist-dependencies
fi

echo "===> Checking for items in pkg-plist which are not in STAGEDIR"
: >${WRKDIR}/.invalid-plist-missing
comm -23 ${WRKDIR}/.plist-files-no-comments ${WRKDIR}/.staged-files | \
    sed -e "${sed_files}" \
    >>${WRKDIR}/.invalid-plist-missing || :

comm -23 ${WRKDIR}/.plist-dirs-sorted-no-comments ${WRKDIR}/.staged-dirs \
    | sort -r | sed "${sed_dirs}" \
    >>${WRKDIR}/.invalid-plist-missing || :
if [ -s "${WRKDIR}/.invalid-plist-missing" ]; then
	ret=1
	while read line; do
		echo "Error: Missing: ${line}" >&2
	done < ${WRKDIR}/.invalid-plist-missing
fi

if [ ${ret} -ne 0 ]; then
	echo "===> Error: Plist issues found." >&2
	if [ "${PREFIX}" != "${LOCALBASE}" ]; then
	    echo "===> Warning: Test was done with PREFIX != LOCALBASE"
	    echo "===> Warning: The port may not be properly installing into PREFIX"
	fi
fi

exit ${ret}
