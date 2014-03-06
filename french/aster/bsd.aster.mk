# Created by: Thierry Thomas (<thierry@pompo.net>)
# $FreeBSD$
#
# Common variables used by ports related to Code_Aster

DISTVERSIONPREFIX=	full-src-
DISTVERSIONSUFFIX=	.noarch
MASTER_SITES=	http://www.code-aster.org/FICHIERS/
DISTNAME=	aster-${DISTVERSIONPREFIX}${ASTER_DISTVERSION}${DISTVERSIONSUFFIX}
DISTINFO_FILE=	${.CURDIR}/../../french/aster/distinfo

BROKEN=		Unfetchable
ASTER_VER=	10.8.0
ASTER_DISTVERSION=	${ASTER_VER}-3
EXTRACT_WRKSRC=	${WRKDIR}/aster-${DISTVERSIONPREFIX}${ASTER_VER}/SRC

.if ${PORTNAME} == metis-edf
DVSFX=		${DISTVERSIONSUFFIX}
.elif ${PORTNAME} == homard
DVSFX=		.all
.endif

.if ${PORTNAME} != aster
post-extract:
	(cd ${WRKDIR} &&	\
	${EXTRACT_CMD} ${EXTRACT_BEFORE_ARGS} ${EXTRACT_WRKSRC}/${PORTNAME}${DVPFX}-${DISTVERSION}${DVSFX}${EXTRACT_SUFX} ${EXTRACT_AFTER_ARGS})
.endif
