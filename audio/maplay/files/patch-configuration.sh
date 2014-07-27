*** configuration.sh.orig	Thu Jun 23 21:14:46 1994
--- configuration.sh	Thu Dec  9 05:21:02 1999
***************
*** 72,77 ****
--- 72,87 ----
       INCLUDEDIRS=
       LIBRARIES=
       AUDIO_INCLUDES='#include <sys/audioio.h>' ;;
+   FreeBSD*)
+      COMPILER='${CXX}'
+      if [ ${ARCH} = "i386" ]; then
+        COMPILERFLAGS='-DLINUX -DDAMN_INTEL_BYTE_ORDER'
+      else
+        COMPILERFLAGS='-DLINUX'
+      fi
+      INCLUDEDIRS=
+      LIBRARIES= 
+      AUDIO_INCLUDES='#include <sys/soundcard.h>' ;;
    Linux*)
       COMPILER=g++
       COMPILERFLAGS='-O2 -m486 -funroll-loops -DLINUX -DDAMN_INTEL_BYTE_ORDER'
***************
*** 95,98 ****
    echo $AUDIO_INCLUDES >audio_includes.h
  fi
  
! make all
--- 105,108 ----
    echo $AUDIO_INCLUDES >audio_includes.h
  fi
  
! make maplay
