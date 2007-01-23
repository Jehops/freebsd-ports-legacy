MASTER_SITE_SUBDIR?=		xfce-4.4.0

configenv_CONFIGURE_ENV=	CPPFLAGS="${CPPFLAGS} -I${LOCALBASE}/include -L${LOCALBASE}/lib"

libexo_LIB_DEPENDS=		exo-0.3:${PORTSDIR}/x11/libexo

libgui_LIB_DEPENDS=		xfcegui4.6:${PORTSDIR}/x11-toolkits/libxfce4gui

libutil_LIB_DEPENDS=		xfce4util.4:${PORTSDIR}/x11/libxfce4util

libmcs_LIB_DEPENDS=		xfce4mcs-manager.3:${PORTSDIR}/x11/libxfce4mcs

mcsmanager_BUILD_DEPENDS=	xfce-mcs-manager:${PORTSDIR}/sysutils/xfce4-mcs-manager
mcsmanager_RUN_DEPENDS=		xfce-mcs-manager:${PORTSDIR}/sysutils/xfce4-mcs-manager

panel_BUILD_DEPENDS=		xfce4-panel:${PORTSDIR}/x11-wm/xfce4-panel
panel_RUN_DEPENDS=		xfce4-panel:${PORTSDIR}/x11-wm/xfce4-panel

thunar_BUILD_DEPENDS=		thunar:${PORTSDIR}/x11-fm/thunar
thunar_RUN_DEPENDS=		thunar:${PORTSDIR}/x11-fm/thunar

wm_BUILD_DEPENDS=		xfwm4:${PORTSDIR}/x11-wm/xfce4-wm
wm_RUN_DEPENDS=			xfwm4:${PORTSDIR}/x11-wm/xfce4-wm

.for component in ${USE_XFCE}
BUILD_DEPENDS+=	${${component}_BUILD_DEPENDS}
LIB_DEPENDS+=	${${component}_LIB_DEPENDS}
RUN_DEPENDS+=	${${component}_RUN_DEPENDS}
CONFIGURE_ENV+=	${${component}_CONFIGURE_ENV}
.endfor
