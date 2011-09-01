--- config.mk.orig	2011-07-10 22:24:25.000000000 +0200
+++ config.mk	2011-09-01 14:00:05.000000000 +0200
@@ -4,11 +4,11 @@
 # Customize below to fit your system
 
 # paths
-PREFIX = /usr/local
-MANPREFIX = ${PREFIX}/share/man
+PREFIX = %%PREFIX%% 
+MANPREFIX = %%MANPREFIX%%
 
-X11INC = /usr/X11R6/include
-X11LIB = /usr/X11R6/lib
+X11INC = %%LOCALBASE%%/include
+X11LIB = %%LOCALBASE%%/lib
 
 # Xinerama
 XINERAMALIBS = -L${X11LIB} -lXinerama
@@ -19,15 +19,15 @@
 LIBS = -L/usr/lib -lc -L${X11LIB} -lX11 ${XINERAMALIBS}
 
 # flags
-CPPFLAGS = -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}
+CPPFLAGS+= -DVERSION=\"${VERSION}\" ${XINERAMAFLAGS}
 #CFLAGS = -g -std=c99 -pedantic -Wall -O0 ${INCS} ${CPPFLAGS}
-CFLAGS = -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
+CFLAGS+= -std=c99 ${INCS} ${CPPFLAGS}
 #LDFLAGS = -g ${LIBS}
-LDFLAGS = -s ${LIBS}
+LDFLAGS+= ${LIBS}
 
 # Solaris
 #CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
 #LDFLAGS = ${LIBS}
 
 # compiler and linker
-CC = cc
+CC?= cc
