#-*- mode: Fundamental; tab-width: 4; -*-
# ex:ts=4
#
# $FreeBSD$
#	$NetBSD: $
#
# Please view me with 4 column tabs!

.if !defined(_POSTMKINCLUDED)

# Please make sure all changes to this file are passed through the maintainer.
# Do not commit them yourself (unless of course you're the Port's Wraith ;).
Gnome_Include_MAINTAINER=	gnome@FreeBSD.org

# This section defines possible names of GNOME components and all information
# necessary for ports to use those components.

# Ports can use this as follows:
#
# USE_GNOME=	gnomeprint bonobo
#
# .include <bsd.port.mk>
#
# As a result proper LIB_DEPENDS/RUN_DEPENDS will be added and CONFIGURE_ENV
# and MAKE_ENV defined.

_USE_GNOME_ALL=	gnomehack gnomeprefix gnomehier gnomeaudio esound libghttp \
		glib12 gtk12 libxml gdkpixbuf imlib orbit gnomelibs \
		gnomecanvas oaf gnomemimedata gconf gnomevfs libcapplet \
		gnomeprint bonobo libgda gnomedb libglade gal glibwww gtkhtml \
		libpanel
_USE_GNOME_ALL+=glib20 atk pango gtk20 linc libidl orbit2 libglade2 libxml2 \
		libxslt bonoboactivation libbonobo gconf2 gnomevfs2 gail \
		libgnomecanvas libartlgpl2 libgnomeprint libgnomeprintui \
		libgnome libbonoboui libgnomeui atspi libgailgnome \
		libgtkhtml gnomedesktop libwnck vte libzvt librsvg2 eel2 \
		gnomepanel nautilus2 metacity gal2

SCROLLKEEPER_DIR=	/var/db/scrollkeeper
gnomehack_PRE_PATCH=	${FIND} ${WRKSRC} -name "Makefile.in*" | ${XARGS} ${REINPLACE_CMD} -e \
				's|[(]GNOME_datadir[)]/gnome/|(datadir)/|g ; \
				 s|[(]GNOME_datadir[)]/locale|(prefix)/share/locale|g ; \
				 s|[(]datadir[)]/locale|(prefix)/share/locale|g ; \
				 s|[(]libdir[)]/locale|(prefix)/share/locale|g ; \
				 s|[(]gnomedatadir[)]/gnome|(gnomedatadir)|g ; \
				 s|[(]datadir[)]/aclocal|(prefix)/share/aclocal|g ; \
				 s|[(]datadir[)]/gnome/|(datadir)/|g ; \
				 s|[(]libdir[)]/pkgconfig|(prefix)/libdata/pkgconfig|g ; \
				 s|[$$][(]localstatedir[)]/scrollkeeper|${SCROLLKEEPER_DIR}|g ; \
				 s|[(]libdir[)]/bonobo/servers|(prefix)/libdata/bonobo/servers|g'

gnomehier_RUN_DEPENDS=	${X11BASE}/share/gnome/.keep_me:${PORTSDIR}/misc/gnomehier
gnomehier_DETECT=	${X11BASE}/share/gnome/.keep_me

GNOME_HTML_DIR?=	${PREFIX}/share/doc
gnomeprefix_CONFIGURE_ENV=GTKDOC="false"
gnomeprefix_CONFIGURE_ARGS=--localstatedir=${PREFIX}/share/gnome \
			   --datadir=${PREFIX}/share/gnome \
			   --with-html-dir=${GNOME_HTML_DIR} \
			   --disable-gtk-doc \
			   --with-gconf-source=xml::${PREFIX}/etc/gconf/gconf.xml.defaults
gnomeprefix_USE_GNOME_IMPL=gnomehier

gnomeaudio_RUN_DEPENDS=	${X11BASE}/share/gnome/sounds/login.wav:${PORTSDIR}/audio/gnomeaudio
gnomeaudio_DETECT=	${X11BASE}/share/gnome/sounds/login.wav

ESD_CONFIG?=		${LOCALBASE}/bin/esd-config
esound_LIB_DEPENDS=	esd.2:${PORTSDIR}/audio/esound
esound_CONFIGURE_ENV=	ESD_CONFIG="${ESD_CONFIG}"
esound_MAKE_ENV=	ESD_CONFIG="${ESD_CONFIG}"
esound_DETECT=		${ESD_CONFIG}

libghttp_LIB_DEPENDS=	ghttp.1:${PORTSDIR}/www/libghttp
libghttp_DETECT=	${LOCALBASE}/etc/ghttpConf.sh

GLIB_CONFIG?=		${LOCALBASE}/bin/glib12-config
glib12_LIB_DEPENDS=	glib12.3:${PORTSDIR}/devel/glib12
glib12_CONFIGURE_ENV=	GLIB_CONFIG="${GLIB_CONFIG}"
glib12_MAKE_ENV=	GLIB_CONFIG="${GLIB_CONFIG}"
glib12_DETECT=		${GLIB_CONFIG}

GTK_CONFIG?=		${X11BASE}/bin/gtk12-config
gtk12_LIB_DEPENDS=	gtk12.2:${PORTSDIR}/x11-toolkits/gtk12
gtk12_CONFIGURE_ENV=	GTK_CONFIG="${GTK_CONFIG}"
gtk12_MAKE_ENV=		GTK_CONFIG="${GTK_CONFIG}"
gtk12_DETECT=		${GTK_CONFIG}
gtk12_USE_GNOME_IMPL=	glib12

XML_CONFIG?=		${LOCALBASE}/bin/xml-config
libxml_LIB_DEPENDS=	xml.5:${PORTSDIR}/textproc/libxml
libxml_CONFIGURE_ENV=	XML_CONFIG="${XML_CONFIG}"
libxml_MAKE_ENV=	XML_CONFIG="${XML_CONFIG}"
libxml_DETECT=		${XML_CONFIG}
libxml_USE_GNOME_IMPL=	glib12

ORBIT_CONFIG?=		${LOCALBASE}/bin/orbit-config
orbit_LIB_DEPENDS=	ORBit.2:${PORTSDIR}/devel/ORBit
orbit_CONFIGURE_ENV=	ORBIT_CONFIG="${ORBIT_CONFIG}"
orbit_MAKE_ENV=		ORBIT_CONFIG="${ORBIT_CONFIG}"
orbit_DETECT=		${ORBIT_CONFIG}
orbit_USE_GNOME_IMPL=	glib12

GDK_PIXBUF_CONFIG?=	${X11BASE}/bin/gdk-pixbuf-config
gdkpixbuf_LIB_DEPENDS=	gdk_pixbuf.2:${PORTSDIR}/graphics/gdk-pixbuf
gdkpixbuf_CONFIGURE_ENV=GDK_PIXBUF_CONFIG="${GDK_PIXBUF_CONFIG}"
gdkpixbuf_MAKE_ENV=	GDK_PIXBUF_CONFIG="${GDK_PIXBUF_CONFIG}"
gdkpixbuf_DETECT=	${GDK_PIXBUF_CONFIG}
gdkpixbuf_USE_GNOME_IMPL=gtk12

IMLIB_CONFIG?=		${X11BASE}/bin/imlib-config
imlib_LIB_DEPENDS=	Imlib.5:${PORTSDIR}/graphics/imlib
imlib_CONFIGURE_ENV=	IMLIB_CONFIG="${IMLIB_CONFIG}"
imlib_MAKE_ENV=		IMLIB_CONFIG="${IMLIB_CONFIG}"
imlib_DETECT=		${IMLIB_CONFIG}
imlib_USE_GNOME_IMPL=	gtk12

GNOME_CONFIG?=		${X11BASE}/bin/gnome-config
gnomelibs_LIB_DEPENDS=	gnome.5:${PORTSDIR}/x11/gnomelibs
gnomelibs_CONFIGURE_ENV=GNOME_CONFIG="${GNOME_CONFIG}"
gnomelibs_MAKE_ENV=	GNOME_CONFIG="${GNOME_CONFIG}"
gnomelibs_DETECT=	${GNOME_CONFIG}
gnomelibs_USE_GNOME_IMPL=esound gtk12 imlib libxml orbit

gnomecanvas_LIB_DEPENDS=gnomecanvaspixbuf.1:${PORTSDIR}/graphics/gnomecanvas
gnomecanvas_DETECT=	${X11BASE}/etc/gnomecanvaspixbufConf.sh
gnomecanvas_USE_GNOME_IMPL=gnomelibs gdkpixbuf

OAF_CONFIG?=		${X11BASE}/bin/oaf-config
oaf_LIB_DEPENDS=	oaf.0:${PORTSDIR}/devel/oaf
oaf_CONFIGURE_ENV=	OAF_CONFIG="${OAF_CONFIG}"
oaf_MAKE_ENV=		OAF_CONFIG="${OAF_CONFIG}"
oaf_DETECT=		${OAF_CONFIG}
oaf_USE_GNOME_IMPL=	glib12 orbit libxml

gnomemimedata_BUILD_DEPENDS=${X11BASE}/libdata/pkgconfig/gnome-mime-data-2.0.pc:${PORTSDIR}/misc/gnomemimedata
gnomemimedata_RUN_DEPENDS=${X11BASE}/libdata/pkgconfig/gnome-mime-data-2.0.pc:${PORTSDIR}/misc/gnomemimedata
gnomemimedata_DETECT=	${X11BASE}/libdata/pkgconfig/gnome-mime-data-2.0.pc
gnomemimedata_USE_GNOME_IMPL=gnomehier

GCONF_CONFIG?=		${X11BASE}/bin/gconf-config
gconf_LIB_DEPENDS=	gconf-1.1:${PORTSDIR}/devel/gconf
gconf_CONFIGURE_ENV=	GCONF_CONFIG="${GCONF_CONFIG}"
gconf_MAKE_ENV=		GCONF_CONFIG="${GCONF_CONFIG}"
gconf_DETECT=		${GCONF_CONFIG}
gconf_USE_GNOME_IMPL=	oaf

GNOME_VFS_CONFIG?=	${X11BASE}/bin/gnome-vfs-config
gnomevfs_LIB_DEPENDS=	gnomevfs.0:${PORTSDIR}/devel/gnomevfs
gnomevfs_CONFIGURE_ENV=	GNOME_VFS_CONFIG="${GNOME_VFS_CONFIG}"
gnomevfs_MAKE_ENV=	GNOME_VFS_CONFIG="${GNOME_VFS_CONFIG}"
gnomevfs_DETECT=	${GNOME_VFS_CONFIG}
gnomevfs_USE_GNOME_IMPL=gnomemimedata gconf gnomelibs

libcapplet_LIB_DEPENDS=	capplet.5:${PORTSDIR}/x11/libcapplet
libcapplet_DETECT=	${X11BASE}/etc/cappletConf.sh
libcapplet_USE_GNOME_IMPL=gnomelibs

gnomeprint_LIB_DEPENDS=	gnomeprint.16:${PORTSDIR}/print/gnomeprint
gnomeprint_DETECT=	${X11BASE}/etc/printConf.sh
gnomeprint_USE_GNOME_IMPL=gnomelibs gnomecanvas

bonobo_LIB_DEPENDS=	bonobo.2:${PORTSDIR}/devel/bonobo
bonobo_DETECT=		${X11BASE}/etc/bonoboConf.sh
bonobo_USE_GNOME_IMPL=	oaf gnomeprint

GDA_CONFIG?=		${X11BASE}/bin/gda-config
libgda_LIB_DEPENDS=	gda-client.0:${PORTSDIR}/databases/libgda
libgda_CONFIGURE_ENV=	GDA_CONFIG="${GDA_CONFIG}"
libgda_MAKE_ENV=	GDA_CONFIG="${GDA_CONFIG}"
libgda_DETECT=		${GDA_CONFIG}
libgda_USE_GNOME_IMPL=	gconf bonobo

GNOMEDB_CONFIG?=	${X11BASE}/bin/gnomedb-config
gnomedb_LIB_DEPENDS=	gnomedb.0:${PORTSDIR}/databases/gnomedb
gnomedb_CONFIGURE_ENV=	GNOMEDB_CONFIG="${GNOMEDB_CONFIG}"
gnomedb_MAKE_ENV=	GNOMEDB_CONFIG="${GNOMEDB_CONFIG}"
gnomedb_DETECT=		${GNOMEDB_CONFIG}
gnomedb_USE_GNOME_IMPL=	libgda

LIBGLADE_CONFIG?=	${X11BASE}/bin/libglade-config
libglade_LIB_DEPENDS=	glade.4:${PORTSDIR}/devel/libglade
libglade_CONFIGURE_ENV=	LIBGLADE_CONFIG="${LIBGLADE_CONFIG}"
libglade_MAKE_ENV=	LIBGLADE_CONFIG="${LIBGLADE_CONFIG}"
libglade_DETECT=	${LIBGLADE_CONFIG}
libglade_USE_GNOME_IMPL=gnomedb

gal_LIB_DEPENDS=	gal.23:${PORTSDIR}/x11-toolkits/gal
gal_DETECT=		${X11BASE}/etc/galConf.sh
gal_USE_GNOME_IMPL=	libglade

glibwww_LIB_DEPENDS=	glibwww.1:${PORTSDIR}/www/glibwww
glibwww_DETECT=		${X11BASE}/etc/glibwwwConf.sh
glibwww_USE_GNOME_IMPL=	gnomelibs

gtkhtml_LIB_DEPENDS=	gtkhtml-1.1.3:${PORTSDIR}/www/gtkhtml
gtkhtml_DETECT=		${X11BASE}/etc/gtkhtmlConf.sh
gtkhtml_USE_GNOME_IMPL=	glibwww gal libghttp libcapplet

libpanel_LIB_DEPENDS=	panel_applet.5:${PORTSDIR}/x11/libpanel
libpanel_DETECT=	${X11BASE}/etc/appletsConf.sh
libpanel_USE_GNOME_IMPL=gnomelibs
libpanel_GNOME_DESKTOP_VERSION=1

glib20_LIB_DEPENDS=	glib-2.0.200:${PORTSDIR}/devel/glib20
glib20_DETECT=		${LOCALBASE}/libdata/pkgconfig/glib-2.0.pc

atk_LIB_DEPENDS=	atk-1.0.200:${PORTSDIR}/devel/atk
atk_DETECT=		${LOCALBASE}/libdata/pkgconfig/atk.pc
atk_USE_GNOME_IMPL=	glib20

pango_LIB_DEPENDS=	pango-1.0.200:${PORTSDIR}/x11-toolkits/pango
pango_DETECT=		${X11BASE}/libdata/pkgconfig/pango.pc
pango_USE_GNOME_IMPL=	glib20

gtk20_LIB_DEPENDS=	gtk-x11-2.0.200:${PORTSDIR}/x11-toolkits/gtk20
gtk20_DETECT=		${X11BASE}/libdata/pkgconfig/gtk+-x11-2.0.pc
gtk20_USE_GNOME_IMPL=	atk pango

linc_LIB_DEPENDS=	linc.1:${PORTSDIR}/net/linc
linc_DETECT=		${LOCALBASE}/libdata/pkgconfig/linc.pc
linc_USE_GNOME_IMPL=	glib20

libidl_LIB_DEPENDS=	IDL-2.0:${PORTSDIR}/devel/libIDL
libidl_DETECT=		${LOCALBASE}/libdata/pkgconfig/libIDL-2.0.pc
libidl_USE_GNOME_IMPL=	glib20

orbit2_LIB_DEPENDS=	ORBit-2.0:${PORTSDIR}/devel/ORBit2
orbit2_DETECT=		${LOCALBASE}/libdata/pkgconfig/ORBit-2.0.pc
orbit2_USE_GNOME_IMPL=	libidl linc

libglade2_LIB_DEPENDS=	glade-2.0.0:${PORTSDIR}/devel/libglade2
libglade2_DETECT=	${X11BASE}/libdata/pkgconfig/libglade-2.0.pc
libglade2_USE_GNOME_IMPL=libxml2 gtk20

libxml2_LIB_DEPENDS=	xml2.5:${PORTSDIR}/textproc/libxml2
libxml2_DETECT=		${LOCALBASE}/libdata/pkgconfig/libxml-2.0.pc

libxslt_LIB_DEPENDS=	xslt.1:${PORTSDIR}/textproc/libxslt
libxslt_DETECT=		${LOCALBASE}/libdata/pkgconfig/libxslt.pc
libxslt_USE_GNOME_IMPL=	libxml2

bonoboactivation_LIB_DEPENDS=	bonobo-activation.4:${PORTSDIR}/devel/bonobo-activation
bonoboactivation_DETECT=	${LOCALBASE}/libdata/pkgconfig/bonobo-activation-2.0.pc
bonoboactivation_USE_GNOME_IMPL=libxml2 orbit2

libbonobo_LIB_DEPENDS=	bonobo-2.0:${PORTSDIR}/devel/libbonobo
libbonobo_DETECT=	${LOCALBASE}/libdata/pkgconfig/libbonobo-2.0.pc
libbonobo_USE_GNOME_IMPL=bonoboactivation

gconf2_LIB_DEPENDS=	gconf-2.5:${PORTSDIR}/devel/gconf2
gconf2_DETECT=		${X11BASE}/libdata/pkgconfig/gconf-2.0.pc
gconf2_USE_GNOME_IMPL=	orbit2 libxml2 gtk20

gnomevfs2_LIB_DEPENDS=	gnomevfs-2.0:${PORTSDIR}/devel/gnomevfs2
gnomevfs2_DETECT=	${X11BASE}/libdata/pkgconfig/gnome-vfs-2.0.pc
gnomevfs2_USE_GNOME_IMPL=gconf2 libbonobo gnomemimedata

gail_LIB_DEPENDS=	gailutil.17:${PORTSDIR}/x11-toolkits/gail
gail_DETECT=		${X11BASE}/libdata/pkgconfig/gail.pc
gail_USE_GNOME_IMPL=	libgnomecanvas

libgnomecanvas_LIB_DEPENDS=	gnomecanvas-2.200:${PORTSDIR}/graphics/libgnomecanvas
libgnomecanvas_DETECT=		${X11BASE}/libdata/pkgconfig/libgnomecanvas-2.0.pc
libgnomecanvas_USE_GNOME_IMPL=	libglade2 libartlgpl2

libartlgpl2_LIB_DEPENDS=	art_lgpl_2.5:${PORTSDIR}/graphics/libart_lgpl2
libartlgpl2_DETECT=		${LOCALBASE}/libdata/pkgconfig/libart-2.0.pc

libgnomeprint_LIB_DEPENDS=	gnomeprint-2-2.0:${PORTSDIR}/print/libgnomeprint
libgnomeprint_DETECT=		${X11BASE}/libdata/pkgconfig/libgnomeprint-2.0.pc
libgnomeprint_USE_GNOME_IMPL=	libbonobo libartlgpl2 gtk20

libgnomeprintui_LIB_DEPENDS=	gnomeprintui-2-2.0:${PORTSDIR}/x11-toolkits/libgnomeprintui
libgnomeprintui_DETECT=		${X11BASE}/libdata/pkgconfig/libgnomeprintui-2.0.pc
libgnomeprintui_USE_GNOME_IMPL=	libgnomeprint libgnomecanvas

libgnome_LIB_DEPENDS=	gnome-2.200:${PORTSDIR}/x11/libgnome
libgnome_DETECT=	${X11BASE}/libdata/pkgconfig/libgnome-2.0.pc
libgnome_USE_GNOME_IMPL=libxslt gnomevfs2 esound

libbonoboui_LIB_DEPENDS=	bonoboui-2.0:${PORTSDIR}/x11-toolkits/libbonoboui
libbonoboui_DETECT=		${X11BASE}/libdata/pkgconfig/libbonoboui-2.0.pc
libbonoboui_USE_GNOME_IMPL=	libgnomecanvas libgnome

libgnomeui_LIB_DEPENDS=		gnomeui-2.200:${PORTSDIR}/x11-toolkits/libgnomeui
libgnomeui_DETECT=		${X11BASE}/libdata/pkgconfig/libgnomeui-2.0.pc
libgnomeui_USE_GNOME_IMPL=	libbonoboui

atspi_LIB_DEPENDS=	spi.1:${PORTSDIR}/x11-toolkits/at-spi
atspi_DETECT=		${X11BASE}/libdata/pkgconfig/cspi-1.0.pc
atspi_USE_GNOME_IMPL=	gail libbonobo

libgailgnome_RUN_DEPENDS=	${X11BASE}/lib/gtk-2.0/modules/libgail-gnome.so
libgailgnome_DETECT=		${X11BASE}/libdata/pkgconfig/libgail-gnome.pc
libgailgnome_USE_GNOME_IMPL=	libgnomeui atspi

libgtkhtml_LIB_DEPENDS=	gtkhtml-2.0:${PORTSDIR}/www/libgtkhtml
libgtkhtml_DETECT=	${X11BASE}/libdata/pkgconfig/libgtkhtml-2.0.pc
libgtkhtml_USE_GNOME_IMPL=libxslt gnomevfs2 gail

gnomedesktop_LIB_DEPENDS=	gnome-desktop-2.3:${PORTSDIR}/x11/gnomedesktop
gnomedesktop_DETECT=		${X11BASE}/libdata/pkgconfig/gnome-desktop-2.0.pc
gnomedesktop_USE_GNOME_IMPL=	libgnomeui
gnomedesktop_GNOME_DESKTOP_VERSION=2

libwnck_LIB_DEPENDS=	wnck-1.9:${PORTSDIR}/x11-toolkits/libwnck
libwnck_DETECT=		${X11BASE}/libdata/pkgconfig/libwnck-1.0.pc
libwnck_USE_GNOME_IMPL=	gtk20

vte_LIB_DEPENDS=	vte.4:${PORTSDIR}/x11-toolkits/vte
vte_DETECT=		${X11BASE}/libdata/pkgconfig/vte.pc
vte_USE_GNOME_IMPL=	gtk20

libzvt_LIB_DEPENDS=	zvt-2.0.0:${PORTSDIR}/x11-toolkits/libzvt
libzvt_DETECT=		${X11BASE}/libdata/pkgconfig/libzvt-2.0.pc
libzvt_USE_GNOME_IMPL=	gtk20

librsvg2_LIB_DEPENDS=	rsvg-2.4:${PORTSDIR}/graphics/librsvg2
librsvg2_DETECT=	${X11BASE}/libdata/pkgconfig/librsvg-2.0.pc
librsvg2_USE_GNOME_IMPL=libartlgpl2 libxml2 gtk20

eel2_LIB_DEPENDS=	eel-2.4:${PORTSDIR}/x11-toolkits/eel2
eel2_DETECT=		${X11BASE}/libdata/pkgconfig/eel-2.0.pc
eel2_USE_GNOME_IMPL=	gnomevfs2 libgnomeui gail

gnomepanel_LIB_DEPENDS=	panel-applet-2.0:${PORTSDIR}/x11/gnomepanel
gnomepanel_DETECT=	${X11BASE}/libdata/pkgconfig/libpanelapplet-2.0.pc
gnomepanel_USE_GNOME_IMPL=libwnck gnomedesktop
gnomepanel_GNOME_DESKTOP_VERSION=2

nautilus2_LIB_DEPENDS=	nautilus.2:${PORTSDIR}/x11-fm/nautilus2
nautilus2_DETECT=	${X11BASE}/libdata/pkgconfig/libnautilus.pc
nautilus2_USE_GNOME_IMPL=librsvg2 eel2 gnomedesktop
nautilus2_GNOME_DESKTOP_VERSION=2

metacity_LIB_DEPENDS=	metacity-private.0:${PORTSDIR}/x11-wm/metacity
metacity_DETECT=	${X11BASE}/libdata/pkgconfig/libmetacity-private.pc
metacity_USE_GNOME_IMPL=gconf2 glade2

gal2_LIB_DEPENDS=	gal-2.0.1:${PORTSDIR}/x11-toolkits/gal2
gal2_DETECT=		${X11BASE}/libdata/pkgconfig/gal-2.0.pc
gal2_USE_GNOME_IMPL=gnomeui libgnomeprintui

# End component definition section

# This section defines tests for optional software.  These work off four
# types of variables:  WANT_GNOME, WITH_GNOME, HAVE_GNOME and USE_GNOME.
# The logic of this is that a port can WANT support for a package; a user
# specifies if they want ports compiled WITH certain features; this section
# tests if we HAVE these features; and the port is then free to USE them.

# The logic of this section is like this:
#
# .if defined(WANT_GNOME) && !defined(WITHOUT_GNOME)
#   .for foo in ALL_GNOME_COMPONENTS
#     .if defined(WITH_GNOME)
#       HAVE_GNOME += foo
#     .elif (foo installed)
#       HAVE_GNOME += foo
#     .else
#       Print option message
#     .endif
#   .endfor
# .endif
#
# Although it apears a little more convoluted in the tests.

# Ports can make use of this like so:
#
# WANT_GNOME=		yes
#
# .include <bsd.port.pre.mk>
#
# .if ${HAVE_GNOME:Mfoo}!=""
# ... Do some things ...
# USE_GNOME=		foo
# .else
# ... Do some other things ...
# .endif

# If the user has not defined GNOME_DESKTOP_VERSION, let's try to prevent
# them from shooting themself in the foot.  We will try to make an 
# intelligent choice on the user's behalf.
.if exists(${gnomepanel_DETECT})
GNOME_DESKTOP_VERSION?=	2
.elif exists(${libpanel_DETECT})
GNOME_DESKTOP_VERSION?=	1
.endif

# We also check each component to see if it has a desktop requirement.  If
# it does, and its requirement disagrees with the user's chosen desktop,
# do not add the component to the HAVE_GNOME list.

_USE_GNOME_SAVED:=${USE_GNOME}
_USE_GNOME_DESKTOP=yes
HAVE_GNOME?=
.if (defined(WANT_GNOME) && !defined(WITHOUT_GNOME))
. for component in ${_USE_GNOME_ALL}
.      if defined(GNOME_DESKTOP_VERSION) && \
	defined(${component}_GNOME_DESKTOP_VERSION)
.         if ${GNOME_DESKTOP_VERSION}==${${component}_GNOME_DESKTOP_VERSION}
HAVE_GNOME+=	${component}
.         else
_USE_GNOME_DESKTOP=no
.         endif
.      else
.         if exists(${${component}_DETECT})
HAVE_GNOME+=	${component}
.         elif defined(WITH_GNOME)
.            if ${WITH_GNOME}=="yes" || ${WITH_GNOME:M${component}}!="" \
		|| ${WITH_GNOME}=="1"
HAVE_GNOME+=	${component}
.            endif
.         endif
.       endif
. endfor
.elif defined(WITHOUT_GNOME)
.  if ${WITHOUT_GNOME}!="yes" && ${WITHOUT_GNOME}!="1"
.    for component in ${_USE_GNOME_ALL}
.      if ${WITHOUT_GNOME:M${component}}==""
.        if exists(${${component}_DETECT})
HAVE_GNOME+=	${component}
.        endif
.      endif
.    endfor
.  endif
.endif

.endif
# End of optional part.

.if defined(_POSTMKINCLUDED)

# Hack USE_GNOME to the modular nfrastructure for port mataintainers that
# didn't do so themselves.  This will allow us to get rid of the old
# GNOME porting infrastructure more quickly.
.if defined(USE_GNOME)
. if ${USE_GNOME}=="yes"
USE_GNOME=gnomeprefix gnomehack gtkhtml libpanel
. endif
.if defined(USE_GTK)
USE_GNOME=	gtk12
.endif
.if defined(USE_ESOUND)
USE_GNOME=	esound
.endif
.if defined(USE_IMLIB)
USE_GNOME=	imlib
.endif
.if defined(USE_GLIB)
USE_GNOME=	glib12
.endif
.if defined(USE_GNOMECTRL)
USE_GNOME=	gnomeprefix gnomehack libcapplet
.endif

# Set a reasonable (overrideable) configure target for GNOME apps.
CONFIGURE_TARGET?=	--build=${MACHINE_ARCH}-portbld-freebsd${OSREL}

# First of all expand all USE_GNOME_IMPL recursively
. for component in ${_USE_GNOME_ALL}
.  for subcomponent in ${${component}_USE_GNOME_IMPL}
${component}_USE_GNOME_IMPL+=${${subcomponent}_USE_GNOME_IMPL}
.  endfor
. endfor

# Then use already expanded USE_GNOME_IMPL to expand USE_GNOME.
# Also, check to see if each component has a desktop requirement.  If it does,
# and if the user's chosen desktop is not of the same version, mark the
# port as broken.
. for component in ${USE_GNOME}
.      if defined(GNOME_DESKTOP_VERSION) && \
	defined(${component}_GNOME_DESKTOP_VERSION)
.         if ${GNOME_DESKTOP_VERSION}!=${${component}_GNOME_DESKTOP_VERSION}
BROKEN=	${PORTNAME} wants to use the GNOME 
BROKEN+=${${component}_GNOME_DESKTOP_VERSION} desktop, but you wish to use 
BROKEN+=the GNOME ${GNOME_DESKTOP_VERSION} desktop.
.         endif
.      endif
.  if ${_USE_GNOME_ALL:M${component}}==""
BROKEN=	"Unknown component ${component}"
.  endif
_USE_GNOME+=	${${component}_USE_GNOME_IMPL} ${component}
. endfor

# Then traverse through all components, check which of them
# exist in ${_USE_GNOME} and set variables accordingly
. for component in ${_USE_GNOME_ALL}
_COMP_TEST=	${_USE_GNOME:M${component}}
.  if ${_COMP_TEST:S/${component}//}!=${_COMP_TEST:S/  / /g}
BUILD_DEPENDS+=	${${component}_BUILD_DEPENDS}
LIB_DEPENDS+=	${${component}_LIB_DEPENDS}
RUN_DEPENDS+=	${${component}_RUN_DEPENDS}

CONFIGURE_ARGS+=${${component}_CONFIGURE_ARGS}
CONFIGURE_ENV+=	${${component}_CONFIGURE_ENV}
MAKE_ENV+=	${${component}_MAKE_ENV}

.    if defined(${component}_PRE_PATCH)
GNOME_PRE_PATCH+=	${${component}_PRE_PATCH}
.    endif

.  endif
. endfor
.endif

.if defined(GNOME_PRE_PATCH) && !target(pre-patch)
USE_REINPLACE=	yes

pre-patch:
	@${GNOME_PRE_PATCH}
.endif

.if defined(WANT_GNOME)
USE_GNOME?=
.if ${_USE_GNOME_SAVED}==${USE_GNOME}
PLIST_SUB+=	GNOME:="@comment " NOGNOME:=""
.else
PLIST_SUB+=	GNOME:="" NOGNOME:="@comment "
.if defined(GNOME_DESKTOP_VERSION)
.if ${_USE_GNOME_DESKTOP}=="yes"
PLIST_SUB+=	GNOMEDESKTOP:="" NOGNOMEDESKTOP:="@comment "
.else
PLIST_SUB+=	GNOMEDESKTOP:="@comment " NOGNOMEDESKTOP:=""
.endif
.endif
.endif
.endif

.endif
# End of use part.
