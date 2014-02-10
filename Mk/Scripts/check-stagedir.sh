#!/bin/sh
# ports/Mk/Scripts/check-stagedir.sh - called from ports/Mk/bsd.stage.mk
# $FreeBSD$

set -e
export LC_ALL=C

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
	orphans)	;;
	makeplist)	makeplist=1 ;;
	*) echo >&2 "Usage: $0 {orphans|makelist}" ; exit 1 ;;
esac

# validate environment
envfault=
for i in STAGEDIR PREFIX LOCALBASE WRKDIR WRKSRC MTREE_FILE \
    TMPPLIST DOCSDIR EXAMPLESDIR PLIST_SUB
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
	cwd=${PREFIX}
	while read line; do
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
			/*) echo >&3 "$line" ;;
			*)  echo >&3 "$cwd/$line" ;;
			esac
		;;
		@info*)
			set -- $line
			shift
			echo "$cwd/$@"
		;;
		# order matters here - we must check @cwd first because
		# otherwise the @cwd* would also match it first, shadowing the
		# @cwd) line.
		@cwd|@cd) cwd=${PREFIX} ;;
		@cwd*|@cd*) set -- $line ; cwd=$2 ;;
		@*) ;;
		/*) echo "$line" ;;
		*)  echo "$cwd/$line" ;;
		esac
	done < ${TMPPLIST} 3>${WRKDIR}/.plist-dirs-unsorted | sort >${WRKDIR}/.plist-files
else
	# generate plist - pretend the plist had been empty
	: >${WRKDIR}/.plist-dirs-unsorted
	: >${WRKDIR}/.plist-files
	echo '/you/have/to/check/what/makeplist/gives/you'
fi

### PRODUCE MTREE FILE
{
	listmtree /etc/mtree/BSD.root.dist ""
	#listmtree /etc/mtree/BSD.usr.dist /usr
	listmtree /etc/mtree/BSD.var.dist /var

	if [ -n "${MTREE_FILE}" ]; then
		listmtree "${MTREE_FILE}" "${PREFIX}"
	fi

	a=${PREFIX}
	while :; do
		echo ${a}
		a=${a%/*}
		[ -z "${a}" ] && break
	done
} > ${WRKDIR}/.mtree

for i in $PLIST_SUB
do
	echo $i
done | awk -F= '{print length($2), $1, $2 | "sort -nr" }' | while read l k v
do
	if [ $l -ne 0 ]
	then
		echo "s,${v},%%${k}%%,g;"
	fi
done > ${WRKDIR}/.plist_sub

sed_plist_sub=`cat ${WRKDIR}/.plist_sub`

### HANDLE FILES
find ${STAGEDIR} -type f -o -type l | sort | sed -e "s,${STAGEDIR},," >${WRKDIR}/.staged-files
comm -13 ${WRKDIR}/.plist-files ${WRKDIR}/.staged-files \
	| sed \
	-e "s,${DOCSDIR},%%PORTDOCS%%%%DOCSDIR%%,g" \
	-e "s,${EXAMPLESDIR},%%PORTEXAMPLES%%%%EXAMPLESDIR%%,g" \
	-e "s,${PREFIX}/,,g" \
	-e "${sed_plist_sub}" | grep -v "^share/licenses" || [ $? = 1 ]

### HANDLE DIRS
cat ${WRKDIR}/.plist-dirs-unsorted ${WRKDIR}/.mtree | sort -u >${WRKDIR}/.traced-dirs
find ${STAGEDIR} -type d | sed -e "s,^${STAGEDIR},,;/^$/d" | sort >${WRKDIR}/.staged-dirs
comm -13 ${WRKDIR}/.traced-dirs ${WRKDIR}/.staged-dirs \
	| sort -r | sed \
	-e 's,^,@dirrmtry ,' \
	-e "s,\(.*\)${DOCSDIR},%%PORTDOCS%%\1%%DOCSDIR%%,g" \
	-e "s,\(.*\)${EXAMPLESDIR},%%PORTEXAMPLES%%\1%%EXAMPLESDIR%%,g" \
	-e "s,${PREFIX}/,,g" \
	-e "${sed_plist_sub}" \
	-e 's,@dirrmtry \(/.*\),@unexec rmdir >/dev/null 2>\&1 \1 || :,' | grep -v "^@dirrmtry share/licenses" || [ $? = 1 ]
