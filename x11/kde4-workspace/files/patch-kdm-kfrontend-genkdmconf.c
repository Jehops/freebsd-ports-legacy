--- kdm/kfrontend/genkdmconf.c
+++ kdm/kfrontend/genkdmconf.c
@@ -44,9 +44,6 @@
 #include <limits.h>
 #include <sys/stat.h>
 #include <sys/param.h>
-#ifdef BSD
-# include <utmp.h>
-#endif
 
 #define WANT_CONF_GEN
 #include <config.ci>
@@ -1790,7 +1787,7 @@
 #else
 # ifdef BSD
 			delstr( file, "\n"
-"exec sessreg -a -l $DISPLAY -x */Xservers -u " _PATH_UTMP " $USER\n" ) |
+"exec sessreg -a -l $DISPLAY -x */Xservers $USER\n" ) |
 # endif
 #endif /* _AIX */
 			delstr( file, "\n"
@@ -1839,7 +1836,7 @@
 #else
 # ifdef BSD
 		delstr( file, "\n"
-"exec sessreg -d -l $DISPLAY -x */Xservers -u " _PATH_UTMP " $USER\n" ) |
+"exec sessreg -d -l $DISPLAY -x */Xservers $USER\n" ) |
 # endif
 #endif /* _AIX */
 		delstr( file, "\n"
