--- kdm/backend/dm.h
+++ kdm/backend/dm.h
@@ -102,7 +102,6 @@
 # define Jmp_buf sigjmp_buf
 #endif
 
-#include <utmp.h>
 #ifdef HAVE_UTMPX
 # include <utmpx.h>
 # define STRUCTUTMP struct utmpx
@@ -113,15 +112,16 @@
 # define ENDUTENT endutxent
 # define ut_time ut_tv.tv_sec
 #else
+# include <utmp.h>
 # define STRUCTUTMP struct utmp
 # define UTMPNAME utmpname
 # define SETUTENT setutent
 # define GETUTENT getutent
 # define PUTUTLINE pututline
 # define ENDUTENT endutent
-#endif
-#ifndef HAVE_STRUCT_UTMP_UT_USER
-# define ut_user ut_name
+# ifndef HAVE_STRUCT_UTMP_UT_USER
+#  define ut_user ut_name
+# endif
 #endif
 #ifndef WTMP_FILE
 # ifdef _PATH_WTMPX
