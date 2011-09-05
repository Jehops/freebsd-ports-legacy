--- solenv/inc/unxfbsd.mk.orig	2011-05-18 15:51:48.000000000 +0000
+++ solenv/inc/unxfbsd.mk	2011-08-25 20:23:28.830637378 +0000
@@ -27,178 +27,23 @@
 
 # Makefile for FreeBSD.
 
-ASM=
-AFLAGS=
-
-SOLAR_JAVA*=
-JAVAFLAGSDEBUG=-g
-
-# Include arch specific makefile.
+# arch specific defines
 .IF "$(CPUNAME)" == "INTEL"
-.INCLUDE : unxfbsdi.mk
+CDEFS+=-DX86
 .ENDIF
+
 .IF "$(CPUNAME)" == "X86_64"
-.INCLUDE : unxfbsdx.mk
+CDEFS+=-DX86_64
+BUILD64=1
 .ENDIF
 
-# filter for supressing verbose messages from linker
-#not needed at the moment
-#LINKOUTPUT_FILTER=" |& $(SOLARENV)/bin/msg_filter"
-
-# _PTHREADS is needed for the stl
-CDEFS+=$(PTHREAD_CFLAGS) -D_PTHREADS -D_REENTRANT -DNEW_SOLAR -D_USE_NAMESPACE=1
-
-# enable visibility define in "sal/types.h"
-.IF "$(HAVE_GCC_VISIBILITY_FEATURE)" == "TRUE"
-CDEFS += -DHAVE_GCC_VISIBILITY_FEATURE
-.ENDIF # "$(HAVE_GCC_VISIBILITY_FEATURE)" == "TRUE"
-
-# this is a platform with JAVA support
-.IF "$(SOLAR_JAVA)"!=""
-JAVADEF=-DSOLAR_JAVA
-.IF "$(debug)"==""
-JAVA_RUNTIME=-ljava
-.ELSE
-JAVA_RUNTIME=-ljava_g
-.ENDIF
-.ENDIF
+.INCLUDE : unxgcc.mk
 
-# name of C++ Compiler
-CXX*=g++
-# name of C Compiler
-CC*=gcc
-.IF "$(SYSBASE)"!=""
-CFLAGS_SYSBASE:=-isystem $(SYSBASE)/usr/include
-CXX+:=$(CFLAGS_SYSBASE)
-CC+:=$(CFLAGS_SYSBASE)
-.ENDIF          # "$(SYSBASE)"!=""
-CFLAGS+=-fmessage-length=0 -c
-
-# flags to enable build with symbols
-CFLAGSENABLESYMBOLS=-g
-
-# flags for the C++ Compiler
-CFLAGSCC= -pipe $(ARCH_FLAGS)
-# Flags for enabling exception handling
-CFLAGSEXCEPTIONS=-fexceptions -fno-enforce-eh-specs
 # Flags for disabling exception handling
-CFLAGS_NO_EXCEPTIONS=-fno-exceptions
-
-# -fpermissive should be removed as soon as possible
-CFLAGSCXX= -pipe $(ARCH_FLAGS)
-PICSWITCH:=-fpic
-.IF "$(HAVE_GCC_VISIBILITY_FEATURE)" == "TRUE"
-CFLAGSCXX += -fvisibility-inlines-hidden
-.ENDIF # "$(HAVE_GCC_VISIBILITY_FEATURE)" == "TRUE"
-
-# Compiler flags for compiling static object in multi threaded environment with graphical user interface
-CFLAGSOBJGUIMT=
-# Compiler flags for compiling static object in multi threaded environment with character user interface
-CFLAGSOBJCUIMT=
-# Compiler flags for compiling shared object in multi threaded environment with graphical user interface
-CFLAGSSLOGUIMT=$(PICSWITCH)
-# Compiler flags for compiling shared object in multi threaded environment with character user interface
-CFLAGSSLOCUIMT=$(PICSWITCH)
-# Compiler flags for profiling
-CFLAGSPROF=
-# Compiler flags for debugging
-CFLAGSDEBUG=-g
-CFLAGSDBGUTIL=
-# Compiler flags for disabling optimizations
-CFLAGSNOOPT=-O0
-# Compiler flags for describing the output path
-CFLAGSOUTOBJ=-o
-
-# -Wshadow does not work for C with nested uses of pthread_cleanup_push:
-CFLAGSWARNCC=-Wall -Wextra -Wendif-labels
-CFLAGSWARNCXX=$(CFLAGSWARNCC) -Wshadow -Wno-ctor-dtor-privacy \
-    -Wno-non-virtual-dtor
-CFLAGSWALLCC=$(CFLAGSWARNCC)
-CFLAGSWALLCXX=$(CFLAGSWARNCXX)
-CFLAGSWERRCC=-Werror
-
-# Once all modules on this platform compile without warnings, set
-# COMPILER_WARN_ERRORS=TRUE here instead of setting MODULES_WITH_WARNINGS (see
-# settings.mk): Currently this is not tested on FreeBSD
-#MODULES_WITH_WARNINGS :=
-
-# switches for dynamic and static linking
-STATIC		= -Wl,-Bstatic
-DYNAMIC		= -Wl,-Bdynamic
-
-# name of linker
-LINK*=$(CXX)
-LINKC*=$(CC)
+CFLAGS_NO_EXCEPTIONS+=-DBOOST_NO_EXCEPTIONS
 
 # default linker flags
-LINKFLAGSDEFS*=#-Wl,-z,defs
-LINKFLAGSRUNPATH_URELIB=-Wl,-rpath,\''$$ORIGIN'\'
-LINKFLAGSRUNPATH_UREBIN=-Wl,-rpath,\''$$ORIGIN/../lib:$$ORIGIN'\'
-    #TODO: drop $ORIGIN once no URE executable is also shipped in OOo
-LINKFLAGSRUNPATH_OOO=-Wl,-rpath,\''$$ORIGIN:$$ORIGIN/../ure-link/lib'\'
-LINKFLAGSRUNPATH_SDK=-Wl,-rpath,\''$$ORIGIN/../../ure-link/lib'\'
-LINKFLAGSRUNPATH_BRAND=-Wl,-rpath,\''$$ORIGIN:$$ORIGIN/../basis-link/program:$$ORIGIN/../basis-link/ure-link/lib'\'
-LINKFLAGSRUNPATH_OXT=
-LINKFLAGSRUNPATH_NONE=
-LINKFLAGS=-Wl,-z,combreloc $(LINKFLAGSDEFS)
-
-# linker flags for linking applications
-LINKFLAGSAPPGUI= -Wl,-export-dynamic
-LINKFLAGSAPPCUI= -Wl,-export-dynamic
-
-# linker flags for linking shared libraries
-LINKFLAGSSHLGUI= -shared
-LINKFLAGSSHLCUI= -shared
-
-LINKFLAGSTACK=
-LINKFLAGSPROF=
-LINKFLAGSDEBUG=-g
-LINKFLAGSOPT=
-
-# linker flags for optimization (symbol hashtable)
-# for now, applied to symbol scoped libraries, only
-LINKFLAGSOPTIMIZE*=-Wl,-O1
-LINKVERSIONMAPFLAG=$(LINKFLAGSOPTIMIZE) -Wl,--version-script
-
-SONAME_SWITCH=-Wl,-h
-
-# Sequence of libs does matter !
-
-STDLIBCPP=-lstdc++
-
-# default objectfilenames to link
-STDOBJVCL=$(L)/salmain.o
-STDOBJGUI=
-STDSLOGUI=
-STDOBJCUI=
-STDSLOCUI=
-
-# libraries for linking applications
-STDLIBGUIMT=-lX11 $(PTHREAD_LIBS) -lm
-STDLIBCUIMT=$(PTHREAD_LIBS) -lm
-# libraries for linking shared libraries
-STDSHLGUIMT=-lX11 -lXext $(PTHREAD_LIBS) -lm
-STDSHLCUIMT=$(PTHREAD_LIBS) -lm
-
-LIBSALCPPRT*=-Wl,--whole-archive -lsalcpprt -Wl,--no-whole-archive
-
-# name of library manager
-LIBMGR=ar
-LIBFLAGS=-r
-
-# tool for generating import libraries
-IMPLIB=
-IMPLIBFLAGS=
-
-MAPSYM=
-MAPSYMFLAGS=
-
-RC=irc
-RCFLAGS=-fo$@ $(RCFILES)
-RCLINK=
-RCLINKFLAGS=
-RCSETVERSION=
+LINKFLAGSDEFS:=
 
 # platform specific identifier for shared libs
-DLLPRE=lib
-DLLPOST=.so
+DLLPOSTFIX=fb
