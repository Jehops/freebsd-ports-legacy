#
# $FreeBSD$
#

STAGEDIR?=	${WRKDIR}/stage
DESTDIRNAME?=	DESTDIR

MAKE_ARGS+=	${DESTDIRNAME}=${STAGEDIR}

.if !target(stage-dir)
stage-dir:
	@${MKDIR} ${STAGEDIR}${PREFIX}
.if !defined(NO_MTREE)
	@${MTREE_CMD} ${MTREE_ARGS} ${STAGEDIR}${PREFIX} > /dev/null
.if defined(USE_LINUX) && ${PREFIX} != ${LINUXBASE_REL}
	@${MKDIR} ${STAGEDIR}${LINUXBASE_REL}
	@${MTREE_CMD} ${MTREE_LINUX_ARGS} ${STAGEDIR}${LINUXBASE_REL} > /dev/null
.endif
.endif
.endif

# Compress all manpage not already compressed which are not hardlinks
# Find all manpages which are not compressed and are hadlinks, and only get the list of inodes concerned, for each of them compress the first one found and recreate the hardlinks for the others
# Fixes all dead symlinks left by the previous round
.if !target(compress-man)
compress-man:
	@${ECHO_CMD} "====> Compressing man pages" ; \
	mdirs="${STAGEDIR}${MANPREFIX}/man"; \
	for dir in `cat ${LOCALBASE}/etc/man.d/*.conf ${STAGEDIR}${PREFIX}/etc/man.d/*.conf 2>/dev/null| awk -vstagedir=${STAGEDIR} '{ print stagedir$$2 }'` ; do \
		[ -d $$dir ] && mdirs="$$mdirs $$dir" ;\
	done ; \
	for dir in $$mdirs; do \
		${FIND} $$dir -type f \! -name "*.gz" -links 1 -exec ${GZIP_CMD} {} \; ; \
		${FIND} $$dir -type f \! -name "*.gz" \! -links 1 -print -exec ${STAT} -f '%i' {} \; | \
			${SORT} -u | while read inode ; do \
				unset ref ; \
				for f in $$(${FIND} -type f -inum $${inode} -print); do \
					if [ -z $$ref ]; then \
						ref=$${f}.gz ; \
						${GZIP_CMD} $${f} ; \
						continue ; \
					fi ; \
					${RM} -f $${f} ; \
					(cd $${f%/*}; ${LN} -f $${ref##*/} $${f##*/}.gz) ; \
				done ; \
			done ; \
		${FIND} $$dir -type l \! -name "*.gz" | while read link ; do \
				dest=$$(readlink $$link) ; \
				rm -f $$link ; \
				(cd $${link%/*} ; ${LN} -sf $${dest##*/}.gz $${link##*/}.gz) ;\
		done; \
	done
.endif

.if !target(add-plist-info)
add-plist-info:
.for i in ${INFO}
.if !defined(WITH_PKGNG)
	@${ECHO_CMD} "@cwd ${PREFIX}" >> ${TMPPLIST}
	@${ECHO_CMD} "@unexec install-info --quiet --delete %D/${INFO_PATH}/$i.info %D/${INFO_PATH}/dir" \
		>> ${TMPPLIST}
	@${ECHO_CMD} "@unexec [ \`info -d %D/${INFO_PATH}  --output - 2>/dev/null | grep -c '^*'\` -eq 1 ] && rm -f %D/${INFO_PATH}/dir || :"\
		>> ${TMPPLIST}
	@${LS} ${STAGEDIR}${PREFIX}/${INFO_PATH}/$i.info* | ${SED} -e s:${STAGEDIR}${PREFIX}/::g >> ${TMPPLIST}
	@${ECHO_CMD} "@exec install-info --quiet %D/${INFO_PATH}/$i.info %D/${INFO_PATH}/dir" \
		>> ${TMPPLIST}
.else
	@${LS} ${STAGEDIR}${PREFIX}/${INFO_PATH}/$i.info* | ${SED} -e s:${STAGEDIR}${PREFIX}/:@info\ :g >> ${TMPPLIST}
.endif
.endfor
.endif

.if !target(makeplist)
makeplist: stage
	@{ ${ECHO_CMD} "#mtree"; ${CAT} ${MTREE_FILE}; } | ${TAR} tf - | \
		awk '{ sub(/^\.$$/, "", $$1); \
		if ($$1 == "") print "${PREFIX}"; else print "${PREFIX}/"$$1; }' \
		> ${WRKDIR}/.mtree
	@a=${PREFIX}; \
		while :; do \
			a=$${a%/*} ; \
			[ -z "$${a}" ] && break ; \
			${ECHO_CMD} $${a} >> ${WRKDIR}/.mtree ; \
		done
	@${FIND} ${STAGEDIR} -type f -o -type l | ${SORT} | ${SED} -e "s,${STAGEDIR},,g" \
		-e "s,${DOCSDIR},%%PORTDOCS%%%%DOCSDIR%%,g" \
		-e "s,${EXAMPLESDIR},%%PORTEXAMPLES%%%%EXAMPLESDIR%%,g" \
		-e "s,${DATADIR},%%DATADIR%%,g" \
		-e "s,${PREFIX}/,,g" | ${GREP} -v "^share/licenses" || ${TRUE}
	@${FIND} ${STAGEDIR} -type d | ${SED} -e "s,${STAGEDIR},,g" \
		| while read line; do \
		${GREP} -qw "^$${line}$$" ${WRKDIR}/.mtree || { \
			[ -n "$${line}" ] && ${ECHO_CMD} "@dirrmtry $${line}"; \
		}; \
		done | ${SORT} -r | ${SED} \
		-e "s,\(.*\)${DOCSDIR},%%PORTDOCS%%\1%%DOCSDIR%%,g" \
		-e "s,\(.*\)${EXAMPLESDIR},%%PORTEXAMPLES%%\1%%EXAMPLESDIR%%,g" \
		-e "s,${DATADIR},%%DATADIR%%,g" \
		-e "s,${PREFIX}/,,g" | ${GREP} -v "^@dirrmtry share/licenses" || ${TRUE}
.endif
