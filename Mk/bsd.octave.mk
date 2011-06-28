#-*- mode: makefile; tab-width: 4; -*-
# ex:ts=4
#
# $FreeBSD$
#
# bsd.octave.mk - Octave related macro
# Common code to install octave-forge packages.
# It is, in effect, a wrapper using the package handling already built
# into math/octave.


MASTER_SITES=	SF/octave/Octave%20Forge%20Packages/Individual%20Package%20Releases \
		SF/octave/Octave%20Forge%20Packages/R2009-06-07 \
		SF/octave/Octave%20Forge%20Packages/R2009-05-08
DISTNAME=	${OCTAVE_PKGNAME}-${PORTVERSION}

bsd_octave_mk_MAINTAINER=	stephen@FreeBSD.org

BUILD_DEPENDS+=	octave:${PORTSDIR}/math/octave
RUN_DEPENDS+=	octave:${PORTSDIR}/math/octave \
		gmake:${PORTSDIR}/devel/gmake
RUN_DEPENDS+=	${LOCALBASE}/share/octave/tarballs:${PORTSDIR}/math/octave-forge-base
LIB_DEPENDS+=	pcre:${PORTSDIR}/devel/pcre
USE_FORTRAN=	yes

USE_GMAKE=	yes

DIST_SUBDIR=	octave-forge
OCTAVE_PKGNAME=	${PORTNAME:S/octave-forge-//}
TARBALLS_DIR=	${LOCALBASE}/share/octave/tarballs

MAKE_ENV+=	PACKAGE=${WRKDIR}/${DISTNAME}.tar.gz

do-install:
	${MKDIR} ${TARBALLS_DIR}
	${INSTALL_DATA} ${WRKDIR}/${DISTNAME}.tar.gz ${TARBALLS_DIR}/.
	${RM} -f ${TARBALLS_DIR}/${OCTAVE_PKGNAME}.tar.gz
	PATH=${PREFIX}/bin:/usr/bin:/bin octave -H -q --no-site-file --eval "pkg('install','${TARBALLS_DIR}/${DISTNAME}.tar.gz')"
	${LN} -s ${DISTNAME}.tar.gz ${TARBALLS_DIR}/${OCTAVE_PKGNAME}.tar.gz

post-install:
	@${ECHO_CMD} "share/octave/tarballs/${DISTNAME}.tar.gz" >> ${TMPPLIST}
	@${ECHO_CMD} "@exec octave -H -q --no-site-file --eval \"pkg('install','${LOCALBASE}/share/octave/tarballs/${DISTNAME}.tar.gz')\" > /dev/null" >> ${TMPPLIST}
	@${ECHO_CMD} "share/octave/tarballs/${OCTAVE_PKGNAME}.tar.gz" >> ${TMPPLIST}
	@${ECHO_CMD} "@unexec octave -H -q --no-site-file --eval \"pkg('uninstall','${OCTAVE_PKGNAME}')\" > /dev/null" >> ${TMPPLIST}
	@if [ -e ${.CURDIR}/pkg-message ]; then ${CAT} ${.CURDIR}/pkg-message; fi
