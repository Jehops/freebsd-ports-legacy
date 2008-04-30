# ex:ts=4 sw=4
#
# New ports collection makefile for:	twiki infrastructure
# Date created:		17 April 2008
# Whom:				Andrew Pantyukhin <infofarmer@FreeBSD.org>
#
# $FreeBSD$
#

#
# For more info, please go to http://wiki.FreeBSD.org/TWiki
#

PORTVERSION?=	0.0.${SVNREV}
.if ${PORTNAME} == twiki
PNAME=	core
.else
USE_BZIP2=	yes
PKGNAMEPREFIX?=	twiki-
PNAME=	${PORTNAME}
FILESDIR?=	${.CURDIR}/../twiki/files
.endif
MASTER_SITES?=	CENKES/myports/twiki
CATEGORIES?=	www
SVNURL?=	http://svn.twiki.org/svn/twiki/trunk/${PNAME}
NO_BUILD=	yes
TWDIR?=		${PREFIX}/share/twiki/${PNAME}
WWWDIR?=	${PREFIX}/www/twiki
PLIST_SUB+=	TWDIR="share/twiki/${PNAME}"
SUB_LIST+=	TWDIR="${TWDIR}" WWWOWN="${WWWOWN}" WWWGRP="${WWWGRP}"
SUB_FILES+=	pkg-install pkg-deinstall
MAINTAINER?=	infofarmer@FreeBSD.org
DIST_SUBDIR?=	twiki
RUN_DEPENDS+=	${TWDEP:C/([^=<>]*)([=<>]*)(.*)/twiki-\1\20.0.\3:${PORTSDIR}\/www\/twiki-\1/}

make-dist:
	@${MKDIR} ${WRKDIR}/
	@cd ${WRKDIR}/ && svn export -r ${SVNREV} ${SVNURL} && \
		${MV} ${PNAME} ${DISTNAME} && \
		${FIND} . -type d -empty | ${SED} -e 's|$$|/.keep_me|' | \
		${XARGS} ${TOUCH} && \
		${TAR} cjvf ${DISTNAME}.tar.bz2 ${DISTNAME}

create-plist:	extract
	@${FIND} -s ${WRKSRC} -not -type d |\
		${SED} -e 's|^${WRKSRC}|%%TWDIR%%|' > ${PLIST}
	@${FIND} -ds ${WRKSRC} -type d -not -name ${DISTNAME} | \
		${SED} -e "s,^${WRKSRC},@dirrm %%TWDIR%%," >> ${PLIST}
	@${ECHO_CMD} '@dirrm %%TWDIR%%' >> ${PLIST}
	@${ECHO_CMD} '@dirrmtry share/twiki' >> ${PLIST}

do-install:
	@${INSTALL} -d ${TWDIR}/
	@cd ${WRKSRC}/ && ${COPYTREE_SHARE} . ${TWDIR}/
	@${SETENV} ${SCRIPTS_ENV} ${SH} ${PKGINSTALL} ${PKGNAME} POST-INSTALL

make-twdep:
	@echo "TWDEP=`cat ${WRKSRC}/lib/TWiki/*/${PORTNAME}/DEPENDENCIES |\
		grep -v ',cpan,'|cut -f1-2 -d, | ${SED} -e 's|.*::||;s|,||g' |\
		tr '\n' ' ' | sed 's| $$||'`"
	@echo "RUN_DEPENDS=`cat ${WRKSRC}/lib/TWiki/*/${PORTNAME}/DEPENDENCIES |\
		grep ',cpan,' | cut -f1-2 -d, | ${SED} -e 's|::|-|' | while read a; do\
			n=p5-$${a%%,*}; v=$${a##*,}; \
			o=\`echo ${PORTSDIR}/*/$$n\`; : $${o:=${PORTSDIR}/X/$$n}; \
			echo $$n$$v:'$${PORTSDIR}'$${o##${PORTSDIR}}; done`"


make-port:
	@for n in ${name} ${names}; do\
	cd ../ &&\
	nnam="$${n%%:*}" &&\
	nver="$${n##$$nnam}" &&\
	nver="$${nver##:}" &&\
	pnam="twiki-$$nnam" &&\
	if [ -d $$pnam ]; then continue; fi &&\
	mkdir $$pnam/ && cd $$pnam/ &&\
	echo "# New ports collection makefile for:	$$pnam" > Makefile &&\
	date '+# Date created:%t%t%e %B %Y' >> Makefile &&\
	echo '#' >> Makefile &&\
	echo '# $$''FreeBSD$$' >> Makefile &&\
	echo '#' >> Makefile &&\
	echo >> Makefile &&\
	echo "PORTNAME=	$$nnam" >> Makefile &&\
	echo "SVNREV=		$$nver" >> Makefile &&\
	echo >> Makefile &&\
	echo 'COMMENT=	' >> Makefile &&\
	echo >> Makefile &&\
	echo '.include "$${.CURDIR}/../twiki/bsd.twiki.mk"' >> Makefile &&\
	echo '.include <bsd.port.mk>' >> Makefile &&\
	wrksrc=`make -V WRKSRC` &&\
	make make-dist &&\
	mv work/*bz2 ${_DISTDIR}/ &&\
	make makesum create-plist &&\
	page="$$wrksrc/data/TWiki/$$nnam.txt" &&\
	if [ -e $$page ]; then \
	grep -m1 'Set SHORTDESC' $$page |\
		sed -e 's|.*N = ||;s|<nop>||g;s|! |. |g;s|!||g;s|=||g' |\
		fmt -w 70 > pkg-descr &&\
	echo >> pkg-descr &&\
	grep -m1 Author $$page|grep '^|' |cut -f3 -d'|' |\
		sed -E 's|TWiki:Main[./]||g;s|^|Author: |;s|  | |g;s| $$||;\
		s|([a-z]) |\1, |;s|([a-z])([A-Z])|\1 \2|g' >> pkg-descr &&\
	echo "WWW: http://twiki.org/cgi-bin/view/Plugins/$$nnam" >> pkg-descr;\
	fi; done
