#-*- mode: Fundamental; tab-width: 4; -*-
# ex:ts=4
#
# $FreeBSD$
#
# Please view me with 4 column tabs!

# Please make sure all changes to this file are past through the maintainer. 
# Do not commit them yourself (unless of course you're the Port's Wraith ;).
KDE_MAINTAINER=		will@FreeBSD.org

# This section contains the USE_ definitions.
# XXX: Write HAVE_ definitions sometime.

# USE_QT_VER		- Says that the port uses the Qt toolkit.  Possible values:
#					  1, 2, or 3; each specify the major version of Qt to use.
#					  This implies USE_NEWGCC.
# USE_KDELIBS_VER	- Says that the port uses KDE libraries.  Possible values:
#					  1, 2, or 3; each specify the major version of KDE to use.
#					  This implies USE_QT of the appropriate version.
# USE_KDEBASE_VER	- Says that the port uses the KDE base.  Possible values:
#					  1, 2, or 3; each specify the major version of KDE to use.
#					  This implies USE_KDELIBS of the appropriate version.

#
# WARNING!  ACHTUNG!  DANGER WILL ROBINSON!
# DO NOT USE USE_[QT,KDELIBS,KDEBASE}_VER=3 UNLESS YOU ARE INVOLVED IN THE
# KDE/FREEBSD PROJECT AND/OR YOU KNOW WHAT YOU ARE DOING!
#

# Compat shims.
.if defined(USE_QT)
USE_QT_VER=		1
pre-everything::
	@${ECHO} ">>> Warning:  this port needs to be updated as it uses the old-style USE_QT variable!"
.endif
.if defined(USE_QT2)
USE_QT_VER=		2
pre-everything::
	@${ECHO} ">>> Warning:  this port needs to be updated as it uses the old-style USE_QT2 variable!"
.endif

# USE_KDEBASE_VER section
.if defined(USE_KDEBASE_VER)

# kdebase 1.x common stuff
.if ${USE_KDEBASE_VER} == 1
RUN_DEPENDS+=	kcontrol:${PORTSDIR}/x11/kdebase11
USE_KDELIBS_VER=1

.elif ${USE_KDEBASE_VER} == 3

# kdebase 3.x common stuff
LIB_DEPENDS+=	konq:${PORTSDIR}/x11/kdebase
USE_KDELIBS_VER=3

.else

# kdebase 2.x common stuff -- DEFAULT
LIB_DEPENDS+=	konq.4:${PORTSDIR}/x11/kdebase2
USE_KDELIBS_VER=2

.endif
.endif
# End of USE_KDEBASE_VER

# USE_KDELIBS_VER section
.if defined(USE_KDELIBS_VER)

# kdelibs 1.x common stuff 
.if ${USE_KDELIBS_VER} == 1
LIB_DEPENDS+=	kdecore.3:${PORTSDIR}/x11/kdelibs11
USE_QT_VER=		1

.elif ${USE_KDELIBS_VER} == 3

# kdelibs 3.x common stuff
LIB_DEPENDS+=	kdecore:${PORTSDIR}/x11/kdelibs
USE_QT_VER=		3

.else

# kdelibs 2.x common stuff -- DEFAULT
LIB_DEPENDS+=	kdecore.4:${PORTSDIR}/x11/kdelibs2
USE_QT_VER=		2

.endif
.endif
# End of USE_KDELIBS_VER section

# USE_QT_VER section
.if defined(USE_QT_VER)

# Qt 1.x common stuff
.if ${USE_QT_VER} == 1
LIB_DEPENDS+=	qt.3:${PORTSDIR}/x11-toolkits/qt145
USE_NEWGCC=		yes
MOC?=			${X11BASE}/bin/moc
.if defined(PREFIX)
QTDIR=			${PREFIX}
.else
QTDIR=			${X11BASE}
.endif
CONFIGURE_ENV+=	MOC="${MOC}" QTDIR="${QTDIR}"

.elif ${USE_QT_VER} == 3

QTCPPFLAGS?=
QTCGFLIBS?=

# Qt 3.x common stuff
MOC?=			${X11BASE}/bin/moc
LIB_DEPENDS+=	qt:${PORTSDIR}/x11-toolkits/qt
USE_NEWGCC=		yes
QTCPPFLAGS+=	-I/usr/include -I${LOCALBASE}/include -I${PREFIX}/include \
				-I${X11BASE}/include/qt
QTCFGLIBS+=		-Wl,-export-dynamic -L${LOCALBASE}/lib -L${X11BASE}/lib -ljpeg
				-lqt
.if !defined(QT_NONSTANDARD)
CONFIGURE_ARGS+=--with-qt-includes=${X11BASE}/include/qt \
				--with-qt-libraries=${X11BASE}/lib \
				--with-extra-libs=${LOCALBASE}/lib
CONFIGURE_ENV+=	MOC="${MOC}" CPPFLAGS="${QTCPPFLAGS}" LIBS="${QTCFGLIBS}"
.endif

.else

QTCPPFLAGS?=
QTCGFLIBS?=

# Qt 2.x common stuff -- DEFAULT
LIB_DEPENDS+=	qt2.4:${PORTSDIR}/x11-toolkits/qt23
USE_NEWGCC=		yes
QTNAME=			qt2
MOC?=			${X11BASE}/bin/moc2
QTCPPFLAGS+=	-I/usr/include -D_GETOPT_H -D_PTH_H_ -D_PTH_PTHREAD_H_ \
				-I${LOCALBASE}/include -I${PREFIX}/include -I${X11BASE}/include/qt2
QTCFGLIBS+=		-Wl,-export-dynamic -L${LOCALBASE}/lib -L${X11BASE}/lib -ljpeg -lgcc -lstdc++
.if !defined(QT_NONSTANDARD)
CONFIGURE_ARGS+=--with-qt-includes=${X11BASE}/include/qt2 \
				--with-qt-libraries=${X11BASE}/lib \
				--with-extra-libs=${LOCALBASE}/lib
CONFIGURE_ENV+=	MOC="${MOC}" LIBQT="-l${QTNAME}" \
				CPPFLAGS="${QTCPPFLAGS}" LIBS="${QTCFGLIBS}"
.endif
.endif
.endif
# End of USE_QT_VER section

# End of use part.
