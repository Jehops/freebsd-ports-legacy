# New ports collection makefile for:	Gnome iconset
# Date created:				29 Feb 2004
# Whom:					Tom McLaughlin <tmclaugh@sdf.lonestar.org>
#
# $FreeBSD$
#

# Port logic gratuitously stolen from x11-themes/kde-icons-noia by
# lioux@.

PKGNAMEPREFIX=	gnome-icons-
MASTER_SITES?=	${MASTER_SITE_GNOME}
MASTER_SITE_SUBDIR?=	teams/art.gnome.org/themes/icon

NO_BUILD=	yes
USE_SIZE=	yes

REASON=		Themes may contain artwork not done by the author. \
		Keep FreeBSD safe if theme author violated copyrights.

USE_X_PREFIX=	yes

do-install:
	${MKDIR} ${PREFIX}/share/icons/${PORTNAME}
	cd ${WRKSRC} && ${FIND} . -type d ! -empty \
		-exec ${MKDIR} -m 0755 \
		${PREFIX}/share/icons/${PORTNAME}/"{}" \;
	cd ${WRKSRC} && ${FIND} . -type f \
		-exec ${INSTALL_DATA} ${WRKSRC}/"{}" \
		${PREFIX}/share/icons/${PORTNAME}/"{}" \;
