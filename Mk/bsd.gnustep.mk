#
# $FreeBSD$
#
# This file contains some variable definitions that are supposed to
# make your life easier when dealing with ports related to the GNUstep.
#
#
# Options for user to customize in /etc/make.conf:
# ================================================
#
# WITH_GNUSTEP_XDPS=yes
#	use xdps as backend instead of xlib.
#
# WITH_GNUSTEP_LIBART=yes
#	use libart as backend instead of xlib.
#
#
# Options for a port before include this file:
# ============================================
#
# USE_GNUSTEP_BASE=yes
#	your port depends on the gnustep-base port.
#
# USE_GNUSTEP_GUI=yes
#	your port depends on the gnustep-gui port.
#
# USE_GNUSTEP_BACK=yes
#	your port depends on the gnustep-back port.
#
# USE_GNUSTEP_CONFIGURE=yes
#	call configure script with GNUstep.sh sourced in the current shell
#
# USE_GNUSTEP_BUILD=yes
#	call build target with GNUstep.sh sourced in the current shell
#
# USE_GNUSTEP_INSTALL=yes
#	call install target with GNUstep.sh sourced in the current shell
# 

# ---------------------------------------------------------------------------
.if !defined(_POSTMKINCLUDED)

GNUstep_Include_MAINTAINER=	dinoex@FreeBSD.org

BUILD_DEPENDS+=	${LOCALBASE}/lib/libcallback.a:${PORTSDIR}/devel/ffcall
LIB_DEPENDS+=	objc:${PORTSDIR}/${GNUSTEP_OBJC_PORT}

GNUSTEP_MAKE_PORT?=	devel/gnustep-make
GNUSTEP_OBJC_PORT?=	lang/gnustep-objc
GNUSTEP_BASE_PORT?=	lang/gnustep-base
GNUSTEP_GUI_PORT?=	x11-toolkits/gnustep-gui
GNUSTEP_BACK_PORT?=	x11-toolkits/gnustep-back
GNUSTEP_XDPS_PORT?=	x11-toolkits/gnustep-xdps
GNUSTEP_ART_PORT?=	x11-toolkits/gnustep-art

.if ${MACHINE_ARCH} == "i386"
GNU_ARCH=	ix86
.else
GNU_ARCH=	${MACHINE_ARCH}
.endif

PLIST_SUB+=	GNU_ARCH=${GNU_ARCH} OPSYS=${OPSYS:L} VERSION=${PORTVERSION}
PLIST_SUB+=	MAJORVERSION=${PORTVERSION:C/([0-9]).*/\1/1}

SYSTEMDIR=	${PREFIX}/System
SYSMAKEDIR=	${SYSTEMDIR}/Makefiles
COMBOPATH=	${GNU_ARCH}/${OPSYS:L}/gnu-gnu-gnu
.if defined(WITH_GNUSTEP_DEVEL)
SYSLIBDIR=	${SYSTEMDIR}/Library/Libraries
COMBOLIBDIR=	${SYSTEMDIR}/Library/Libraries
LOCALLIBDIR=	${PREFIX}/Local/Library/Libraries
PLIST_SUB+=	SYSTEMLIBRARY="System/Library"
PLIST_SUB+=	LOCALLIBRARY="Local/Library"
PLIST_SUB+=	NOFLAT=""
PLIST_SUB+=	GNUSTEP_DEVEL=""
PLIST_SUB+=	GNUSTEP_STABLE="@comment "
PKGNAMESUFFIX?=	-devel
.else
SYSLIBDIR=	${SYSTEMDIR}/Libraries/${GNU_ARCH}/${OPSYS:L}
COMBOLIBDIR=	${SYSTEMDIR}/Libraries/${COMBOPATH}
LOCALLIBDIR=	${PREFIX}/Local/Libraries/${COMBOPATH}
PLIST_SUB+=	SYSTEMLIBRARY="System"
PLIST_SUB+=	LOCALLIBRARY="Local"
PLIST_SUB+=	NOFLAT="${GNU_ARCH}/${OPSYS:L}/gnu-gnu-gnu/"
PLIST_SUB+=	GNUSTEP_DEVEL="@comment "
PLIST_SUB+=	GNUSTEP_STABLE=""
.else
.endif
BUNDLEDIR=	${SYSTEMDIR}/Library/Bundles
CC=		gcc32
CXX=		g++32

# ---------------------------------------------------------------------------
# using base
#
.if defined(USE_GNUSTEP_BASE)
BUILD_DEPENDS+=	${COMBOLIBDIR}/libgnustep-base.so:${PORTSDIR}/${GNUSTEP_BASE_PORT}
RUN_DEPENDS+=	${COMBOLIBDIR}/libgnustep-base.so:${PORTSDIR}/${GNUSTEP_BASE_PORT}
.endif

# ---------------------------------------------------------------------------
# using gui
#
.if defined(USE_GNUSTEP_GUI)
BUILD_DEPENDS+=	${COMBOLIBDIR}/libgnustep-gui.so:${PORTSDIR}/${GNUSTEP_GUI_PORT}
RUN_DEPENDS+=	${COMBOLIBDIR}/libgnustep-gui.so:${PORTSDIR}/${GNUSTEP_GUI_PORT}
.endif

# ---------------------------------------------------------------------------
# using any backend
#
.if defined(USE_GNUSTEP_BACK)
.if defined(WITH_GNUSTEP_XDPS)
GNUSTEP_WITH_XDPS=yes
.else
.if defined(WITH_GNUSTEP_LIBART)
USE_GNUSTEP_LIBART=yes
.else
USE_GNUSTEP_XLIB=yes
.endif
.endif
.endif

# ---------------------------------------------------------------------------
# Backend using xlib
#
.if defined(USE_GNUSTEP_XLIB)
BUILD_DEPENDS+=	${BACKBUNDLEDIR}/libgnustep-back:${PORTSDIR}/${GNUSTEP_BACK_PORT}
RUN_DEPENDS+=	${BACKBUNDLEDIR}/libgnustep-back:${PORTSDIR}/${GNUSTEP_BACK_PORT}

.if defined(WITH_GNUSTEP_DEVEL)
BACKBUNDLEDIR=	${BUNDLEDIR}/libgnustep-back.bundle
.else
BACKBUNDLEDIR=	${BUNDLEDIR}/libgnustep-back.bundle/${COMBOPATH}
.endif
MAKE_FLAGS+=	GUI_BACKEND_LIB=back
.endif

# ---------------------------------------------------------------------------
# Backend using xdps
#
.if defined(USE_GNUSTEP_XDPS)
BUILD_DEPENDS+=	${BACKBUNDLEDIR}/libgnustep-xdps:${PORTSDIR}/${GNUSTEP_XDPS_PORT}
RUN_DEPENDS+=	${BACKBUNDLEDIR}/libgnustep-xdps:${PORTSDIR}/${GNUSTEP_XDPS_PORT}

.if defined(WITH_GNUSTEP_DEVEL)
BACKBUNDLEDIR=	${BUNDLEDIR}/libgnustep-xdps.bundle
.else
BACKBUNDLEDIR=	${BUNDLEDIR}/libgnustep-xdps.bundle/${COMBOPATH}
.endif
MAKE_FLAGS+=	GUI_BACKEND_LIB=xdps
.endif

# ---------------------------------------------------------------------------
# Backend using libart
#
.if defined(USE_GNUSTEP_LIBART)
BUILD_DEPENDS+=	${BACKBUNDLEDIR}/libgnustep-art:${PORTSDIR}/${GNUSTEP_ART_PORT}
RUN_DEPENDS+=	${BACKBUNDLEDIR}/libgnustep-art:${PORTSDIR}/${GNUSTEP_ART_PORT}

.if defined(WITH_GNUSTEP_DEVEL)
BACKBUNDLEDIR=	${BUNDLEDIR}/libgnustep-art.bundle
.else
BACKBUNDLEDIR=	${BUNDLEDIR}/libgnustep-art.bundle/${COMBOPATH}
.endif
MAKE_FLAGS+=	GUI_BACKEND_LIB=art
.endif

# ---------------------------------------------------------------------------
# source GNUstep.sh
#
.if defined(USE_GNUSTEP_CONFIGURE)
do-configure:
	@(cd ${CONFIGURE_WRKSRC}; . ${SYSMAKEDIR}/GNUstep.sh; \
	    if ! ${SETENV} CC="${CC}" CXX="${CXX}" \
		CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
		INSTALL="/usr/bin/install -c -o ${BINOWN} -g ${BINGRP}" \
		INSTALL_DATA="${INSTALL} -c" \
		INSTALL_PROGRAM="${INSTALL} -c" \
		INSTALL_SCRIPT="${INSTALL_SCRIPT}" \
		${CONFIGURE_ENV} ./${CONFIGURE_SCRIPT} ${CONFIGURE_ARGS}; then \
		    ${ECHO} "===>  Script \"${CONFIGURE_SCRIPT}\" failed: here are the contents of \"${CONFIGURE_LOG}\""; \
		    ${CAT} ${CONFIGURE_LOG}; \
		    ${ECHO} "(end of \"${CONFIGURE_LOG}\")"; \
		    ${FALSE}; \
	    fi)
.endif

# ---------------------------------------------------------------------------
# source GNUstep.sh
#
.if defined(USE_GNUSTEP_BUILD)
BUILD_DEPENDS+=	${SYSMAKEDIR}/GNUstep.sh:${PORTSDIR}/${GNUSTEP_MAKE_PORT}

do-build:
	@(cd ${WRKSRC}; . ${SYSMAKEDIR}/GNUstep.sh; \
		${SETENV} ${MAKE_ENV} ${GMAKE} ${MAKE_FLAGS} ${MAKEFILE} ${ALL_TARGET})

.endif

# ---------------------------------------------------------------------------
# source GNUstep.sh
#
.if defined(USE_GNUSTEP_INSTALL)
RUN_DEPENDS+=	${SYSMAKEDIR}/GNUstep.sh:${PORTSDIR}/${GNUSTEP_MAKE_PORT}

do-install:
	@(cd ${WRKSRC}; . ${SYSMAKEDIR}/GNUstep.sh; \
		${SETENV} ${MAKE_ENV} ${GMAKE} ${MAKE_FLAGS} ${MAKEFILE} ${INSTALL_TARGET})
.if defined(PARALLEL_PACKAGE_BUILD) || defined(BATCH) || defined(CLEAN_ROOT)
	rm -rf /root/GNUstep
.endif

.endif

.endif

# eof
