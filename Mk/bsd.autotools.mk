#-*- mode: makefile; tab-width: 4; -*-
# ex:ts=4
#
# $FreeBSD$
#
# Please view me with 4 column tabs!
#
# Please make sure all changes to this file are passed either through
# the maintainer, or portmgr@FreeBSD.org

Autotools_Include_MAINTAINER=	ade@FreeBSD.org

#---------------------------------------------------------------------------
# IMPORTANT!  READ ME!  YES, THAT MEANS YOU!
#
# The "versioned" autotools referenced here are for BUILDING other ports
# only.  THIS CANNOT BE STRESSED HIGHLY ENOUGH.  Things WILL BREAK if you
# try to use them for anything other than ports/ work.  This particularly
# includes use as a run-time dependency.
#
# If you need unmodified versions of autotools, such as for use in an
# IDE, then you MUST use the devel/gnu-* equivalents, and NOT these.
# See devel/anjuta and devel/kdevelop for examples.
#
# You have been WARNED!
#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
# Entry points into the autotools system
#---------------------------------------------------------------------------
#
# USE_AUTOMAKE_VER=<value>
#	- Port wishes to use automake, including the configuration step
#	- Implies GNU_CONFIGURE?=yes and WANT_AUTOMAKE_VER=<value>
#
# USE_ACLOCAL_VER=<value>
#	- Port wishes to use aclocal, including the configuration step
#	- Implies GNU_CONFIGURE?=yes and WANT_AUTOMAKE_VER=<value>
#
# WANT_AUTOMAKE_VER=<value>
#	- Port needs access to the automake build environment
#
# AUTOMAKE_ARGS=...
#	- Extra arguments passed to automake during configure step
#
# ACLOCAL_ARGS=...
#   - Arguments passed to aclocal during configure step
#	  Defaults to "--acdir=${ACLOCAL_DIR}" if USE_ACLOCAL_VER specified,
#	  empty (and unused) otherwise
#
#---------------------------------------------------------------------------
#
# USE_AUTOCONF_VER=<value>
#	- Port wishes to use autoconf, including the configuration step
#	- Implies GNU_CONFIGURE?=yes and WANT_AUTOCONF_VER=<value>
#
# USE_AUTOHEADER_VER=<value>
#	- Port wishes to use autoheader in the configuration step
#	- Implies USE_AUTOCONF_VER=<value>
#
# WANT_AUTOCONF_VER=<value>
#	- Port needs access to the autoconf build environment
#
# AUTOCONF_ARGS=...
#	- Extra arguments passed to autoconf during configure step
#
# AUTOHEADER_ARGS=...
#	- Extra arguments passed to autoheader during configure step
#
#---------------------------------------------------------------------------
#
# USE_LIBLTDL=yes
#	- Convenience knob to depend on the library from devel/libltdl15
#
# USE_LIBTOOL_VER=<value>
#	- Port wishes to use libtool, including the configuration step
#	- Port will use the ports version of libtool
#	- Implies GNU_CONFIGURE?=yes and WANT_LIBTOOL_VER=<value>
#
# USE_INC_LIBTOOL_VER=<value>
#	- Port wishes to use libtool, including the configuration step
#	- Port will use its own included version of libtool
#	- Implies GNU_CONFIGURE?=yes and WANT_LIBTOOL_VER=<value>
#
# WANT_LIBTOOL_VER=<value>
#	- Port needs access to the libtool build environment
#
# LIBTOOLFLAGS=<value>
#	- Arguments passed to libtool during configure step
#	  Currently defaults to "--disable-ltlibs", but this will be going
#	  away when libtool .la files are brought back
#
# LIBTOOLFILES=<list-of-files>
#	- A list of files to patch during libtool pre-configuration
#	  Defaults to "aclocal.m4" if autoconf is in use, otherwise "configure"
#
#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
# DEPRECATED ENTRY POINTS
#---------------------------------------------------------------------------
.for i in AUTOMAKE AUTOCONF AUTOHEADER LIBTOOL
. if defined(USE_${i})
BROKEN=	"USE_${i} deprecated: replace with USE_${i}_VER=..."
. endif
. if defined(WANT_${i})
BROKEN=	"WANT_${i} deprecated: replace with WANT_${i}_VER=..."
. endif
.endfor

#---------------------------------------------------------------------------
# AUTOMAKE/ACLOCAL
#---------------------------------------------------------------------------

.if defined(USE_AUTOMAKE_VER)
WANT_AUTOMAKE_VER?=	${USE_AUTOMAKE_VER}
GNU_CONFIGURE?=		yes
.endif

.if defined(USE_ACLOCAL_VER)
WANT_AUTOMAKE_VER?=	${USE_ACLOCAL_VER}
GNU_CONFIGURE?=		yes
.endif

.if defined(WANT_AUTOMAKE_VER)
AUTOMAKE_SUFFIX=	${WANT_AUTOMAKE_VER}

# Make sure we specified a legal version of automake
#
. if !exists(${PORTSDIR}/devel/automake${AUTOMAKE_SUFFIX}/Makefile)
BROKEN=	"Unknown AUTOMAKE version: ${WANT_AUTOMAKE_VER}"
. endif

# Set up the automake environment
#
AUTOMAKE=			${LOCALBASE}/bin/automake${AUTOMAKE_SUFFIX}
AUTOMAKE_DIR=		${LOCALBASE}/share/automake${AUTOMAKE_SUFFIX}
ACLOCAL=			${LOCALBASE}/bin/aclocal${AUTOMAKE_SUFFIX}
ACLOCAL_DIR=		${LOCALBASE}/share/aclocal${AUTOMAKE_SUFFIX}
AUTOMAKE_PATH=		${LOCALBASE}/libexec/automake${AUTOMAKE_SUFFIX}:
AUTOMAKE_VARS=		ACLOCAL=${ACLOCAL} AUTOMAKE=${AUTOMAKE}
AUTOMAKE_VERSION=	${WANT_AUTOMAKE_VER}

AUTOMAKE_DEPENDS=	${AUTOMAKE}:${PORTSDIR}/devel/automake${AUTOMAKE_SUFFIX}
BUILD_DEPENDS+=		${AUTOMAKE_DEPENDS}

. if ${WANT_AUTOMAKE_VER} == 14
AUTOMAKE_ARGS+=		-i
. endif

. if defined(USE_ACLOCAL_VER)
ACLOCAL_ARGS?=		--acdir=${ACLOCAL_DIR}
. endif

.endif

#---------------------------------------------------------------------------
# AUTOCONF/AUTOHEADER
#---------------------------------------------------------------------------

.if defined(USE_AUTOHEADER_VER)
USE_AUTOCONF_VER?=	${USE_AUTOHEADER_VER}
.endif

.if defined(USE_AUTOCONF_VER)
WANT_AUTOCONF_VER?=	${USE_AUTOCONF_VER}
GNU_CONFIGURE?=		yes
.endif

# Sanity checking - we can't use a different version of
# autoheader and autoconf
#
.if defined(USE_AUTOHEADER_VER) && defined(USE_AUTOCONF_VER) && \
    ${USE_AUTOHEADER_VER} != ${USE_AUTOCONF_VER}
BROKEN=	"Incompatible autoheader ${USE_AUTOHEADER_VER} and autoconf ${USE_AUTOCONF_VER}"
.endif

.if defined(WANT_AUTOHEADER_VER) && defined(WANT_AUTOCONF_VER) && \
	${WANT_AUTOHEADER_VER} != ${WANT_AUTOCONF_VER}
BROKEN=	"Incompatible autoheader ${WANT_AUTOHEADER_VER} and autoconf ${WANT_AUTOCONF_VER}"
.endif

.if defined(WANT_AUTOCONF_VER)
AUTOCONF_SUFFIX=	${WANT_AUTOCONF_VER}

# Make sure we specified a legal version of autoconf
#
. if !exists(${PORTSDIR}/devel/autoconf${AUTOCONF_SUFFIX}/Makefile)
BROKEN=	"Unknown AUTOCONF version: ${WANT_AUTOCONF_VER}"
. endif

# Set up the autoconf/autoheader environment
#
AUTOCONF=			${LOCALBASE}/bin/autoconf${AUTOCONF_SUFFIX}
AUTOCONF_DIR=		${LOCALBASE}/share/autoconf${AUTOCONF_SUFFIX}
AUTOHEADER=			${LOCALBASE}/bin/autoheader${AUTOCONF_SUFFIX}
AUTOIFNAMES=		${LOCALBASE}/bin/ifnames${AUTOCONF_SUFFIX}
AUTOM4TE=			${LOCALBASE}/bin/autom4te${AUTOCONF_SUFFIX}
AUTORECONF=			${LOCALBASE}/bin/autoreconf${AUTOCONF_SUFFIX}
AUTOSCAN=			${LOCALBASE}/bin/autoscan${AUTOCONF_SUFFIX}
AUTOUPDATE=			${LOCALBASE}/bin/autoupdate${AUTOCONF_SUFFIX}
AUTOCONF_PATH=		${LOCALBASE}/libexec/autoconf${AUTOCONF_SUFFIX}:
AUTOCONF_VARS=		AUTOCONF=${AUTOCONF} AUTOHEADER=${AUTOHEADER} AUTOIFNAMES=${AUTOIFNAMES} AUTOM4TE=${AUTOM4TE} AUTORECONF=${AUTORECONF} AUTOSCAN=${AUTOSCAN} AUTOUPDATE=${AUTOUPDATE}
AUTOCONF_VERSION=	${WANT_AUTOCONF_VER}

AUTOCONF_DEPENDS=	${AUTOCONF}:${PORTSDIR}/devel/autoconf${AUTOCONF_SUFFIX}
BUILD_DEPENDS+=		${AUTOCONF_DEPENDS}

.endif

#---------------------------------------------------------------------------
# LIBTOOL/LIBLTDL
#---------------------------------------------------------------------------

# Convenience function to save people having to depend directly on
# devel/libltdl15
#
.if defined(USE_LIBLTDL)
LIB_DEPENDS+=	ltdl.4:${PORTSDIR}/devel/libltdl15
.endif

.if defined(USE_LIBTOOL_VER)
GNU_CONFIGURE?=		yes
WANT_LIBTOOL_VER?=	${USE_LIBTOOL_VER}
.elif defined(USE_INC_LIBTOOL_VER)
GNU_CONFIGURE?=		yes
WANT_LIBTOOL_VER?=	${USE_INC_LIBTOOL_VER}
.endif

.if defined(WANT_LIBTOOL_VER)
LIBTOOL_SUFFIX=	${WANT_LIBTOOL_VER}

# Make sure we specified a legal version of libtool
#
. if !exists(${PORTSDIR}/devel/libtool${LIBTOOL_SUFFIX}/Makefile)
BROKEN=	"Unknown LIBTOOL version: ${WANT_LIBTOOL_VER}"
. endif

# Set up the libtool environment
#
LIBTOOL=			${LOCALBASE}/bin/libtool${LIBTOOL_SUFFIX}
LIBTOOLIZE=			${LOCALBASE}/bin/libtoolize${LIBTOOL_SUFFIX}
LIBTOOL_LIBEXECDIR=	${LOCALBASE}/libexec/libtool${LIBTOOL_SUFFIX}
LIBTOOL_SHAREDIR=	${LOCALBASE}/share/libtool${LIBTOOL_SUFFIX}
LIBTOOL_VERSION=	${WANT_LIBTOOL_VER}
LIBTOOL_M4=			${LOCALBASE}/share/aclocal/libtool${LIBTOOL_VERSION}.m4
LTMAIN=				${LIBTOOL_SHAREDIR}/ltmain.sh
. if ${LIBTOOL_VERSION} == 13
LTCONFIG=			${LIBTOOL_SHAREDIR}/ltconfig${LIBTOOL_VERSION}
. else
LTCONFIG=			${TRUE}
. endif
LIBTOOL_PATH=		${LIBTOOL_LIBEXECDIR}:
LIBTOOL_VARS=		LIBTOOL=${LIBTOOL} LIBTOOLIZE=${LIBTOOLIZE} LIBTOOL_M4=${LIBTOOL_M4} LTCONFIG=${LTCONFIG}

LIBTOOL_DEPENDS=	${LIBTOOL}:${PORTSDIR}/devel/libtool${LIBTOOL_SUFFIX}
BUILD_DEPENDS+=		${LIBTOOL_DEPENDS}

LIBTOOLFLAGS?=		--disable-ltlibs		# XXX: probably not useful
. if defined(USE_AUTOCONF_VER)
LIBTOOLFILES?=		aclocal.m4
. else
LIBTOOLFILES?=		configure
. endif

.endif

#---------------------------------------------------------------------------
# Environmental handling
# Now that we've got our environments defined for autotools, add them
# in so that the rest of the world can handle them
#
AUTOTOOLS_PATH=	${AUTOMAKE_PATH}${AUTOCONF_PATH}${LIBTOOL_PATH}
AUTOTOOLS_VARS=	${AUTOMAKE_VARS} ${AUTOCONF_VARS} ${LIBTOOL_VARS}

.if defined(AUTOTOOLS_PATH) && (${AUTOTOOLS_PATH} != "")
AUTOTOOLS_ENV+=	PATH=${AUTOTOOLS_PATH}${PATH}
CONFIGURE_ENV+=	PATH=${AUTOTOOLS_PATH}${PATH}
MAKE_ENV+=		PATH=${AUTOTOOLS_PATH}${PATH}
SCRIPTS_ENV+=	PATH=${AUTOTOOLS_PATH}${PATH}
. if defined(WANT_AUTOMAKE_VER)
AUTOMAKE_ENV+=	PATH=${AUTOTOOLS_PATH}${PATH}
. endif
. if defined(WANT_AUTOCONF_VER)
AUTOCONF_ENV+=	PATH=${AUTOTOOLS_PATH}${PATH}
. endif
. if defined(WANT_AUTOHEADER_VER)
AUTOHEADER_ENV+=PATH=${AUTOTOOLS_PATH}${PATH}
. endif
.endif

.if defined(AUTOTOOLS_VARS) && (${AUTOTOOLS_VARS} != "")
AUTOTOOLS_ENV+=	${AUTOTOOLS_VARS}
CONFIGURE_ENV+=	${AUTOTOOLS_VARS}
MAKE_ENV+=		${AUTOTOOLS_VARS}
SCRIPTS_ENV+=	${AUTOTOOLS_VARS}
. if defined(WANT_AUTOMAKE_VER)
AUTOMAKE_ENV+=	${AUTOTOOLS_VARS}
. endif
. if defined(WANT_AUTOCONF_VER)
AUTOCONF_ENV+=	${AUTOTOOLS_VARS}
. endif
. if defined(WANT_AUTOHEADER_VER)
AUTOHEADER_ENV+=${AUTOTOOLS_VARS}
. endif
.endif

#---------------------------------------------------------------------------
# Make targets
#---------------------------------------------------------------------------

# run-autotools
#
# Part of the configure set - run appropriate programs prior to
# the actual configure target if autotools are in use
#
.if !target(run-autotools)
run-autotools:
. if defined(USE_ACLOCAL_VER)
	@(cd ${CONFIGURE_WRKSRC} && ${SETENV} ${AUTOTOOLS_ENV} ${ACLOCAL} \
		${ACLOCAL_ARGS})
. endif
. if defined(USE_AUTOMAKE_VER)
	@(cd ${CONFIGURE_WRKSRC} && ${SETENV} ${AUTOTOOLS_ENV} ${AUTOMAKE} \
		${AUTOMAKE_ARGS})
. endif
. if defined(USE_AUTOCONF_VER)
	@(cd ${CONFIGURE_WRKSRC} && ${SETENV} ${AUTOTOOLS_ENV} ${AUTOCONF} \
		${AUTOCONF_ARGS})
. endif
. if defined(USE_AUTOHEADER_VER)
	@(cd ${CONFIGURE_WRKSRC} && ${SETENV} ${AUTOTOOLS_ENV} ${AUTOHEADER} \
		${AUTOHEADER_ARGS})
. endif
.endif

# patch-autotools
#
# Special target to automatically make libtool using ports use the
# libtool port.  See above for default values of LIBTOOLFILES.
#
.if !target(patch-autotools)
patch-autotools:
. if defined(USE_INC_LIBTOOL_VER)
	@(cd ${PATCH_WRKSRC}; \
	for file in ${LIBTOOLFILES}; do \
		${CP} $$file $$file.tmp; \
		${SED} -e "s^\$$ac_aux_dir/ltconfig^${LTCONFIG}^g" \
			   -e "/^ltmain=/!s^\$$ac_aux_dir/ltmain.sh^${LIBTOOLFLAGS} ${LTMAIN}^g" \
			$$file.tmp > $$file; \
		${RM} $$file.tmp; \
	done);
. elif defined(USE_LIBTOOL_VER)
	@(cd ${PATCH_WRKSRC}; \
	for file in ${LIBTOOLFILES}; do \
		${CP} $$file $$file.tmp; \
		${SED} -e "s^\$$ac_aux_dir/ltconfig^${LTCONFIG}^g" \
			     -e "/^ltmain=/!s^\$$ac_aux_dir/ltmain.sh^${LIBTOOLFLAGS} ${LTMAIN}^g" \
			     -e '/^LIBTOOL=/s^\$$(top_builddir)/libtool^${LIBTOOL}^g' \
			$$file.tmp > $$file; \
		${RM} $$file.tmp; \
	done);
. else
	@${DO_NADA}
. endif
.endif
