Index: aclocal.m4
diff -u aclocal.m4.orig aclocal.m4
--- aclocal.m4.orig	Tue Nov 23 06:30:12 2004
+++ aclocal.m4	Tue Nov 23 13:59:16 2004
@@ -506,17 +506,22 @@
 	fi
 
 	saved_LIBS=$LIBS
-        for dbname in db-4.2 db4.2 db42 db-4.1 db4.1 db41 db-4.0 db4.0 db-4 db40 db4 db-3.3 db3.3 db33 db-3.2 db3.2 db32 db-3.1 db3.1 db31 db-3 db30 db3 db
+        for dbname in ${with_bdb} db-4.2 db4.2 db42 db-4.1 db4.1 db41 db-4.0 db4.0 db-4 db40 db4 db-3.3 db3.3 db33 db-3.2 db3.2 db32 db-3.1 db3.1 db31 db-3 db30 db3 db
           do
 	    LIBS="$saved_LIBS -l$dbname"
-	    AC_TRY_LINK([#include <db.h>],
+	    AC_TRY_LINK([#include <stdio.h>
+#include <db.h>],
 	    [db_create(NULL, NULL, 0);],
 	    BDB_LIBADD="$BDB_LIBADD -l$dbname"; dblib="berkeley"; dbname=db,
             dblib="no")
+	    if test "$dblib" != "no"; then
+	      break
+	    fi
           done
         if test "$dblib" = "no"; then
 	    LIBS="$saved_LIBS -ldb"
-	    AC_TRY_LINK([#include <db.h>],
+	    AC_TRY_LINK([#include <stdio.h>
+#include <db.h>],
 	    [db_open(NULL, 0, 0, 0, NULL, NULL, NULL);],
 	    BDB_LIBADD="$BDB_LIBADD -ldb"; dblib="berkeley"; dbname=db,
             dblib="no")
@@ -1819,9 +1824,12 @@
 
     if test -n "$SNMP_LIBS" && test -n "$SNMP_PREFIX"; then
       CPPFLAGS="$CPPFLAGS -I${SNMP_PREFIX}/include"
-      LIB_UCDSNMP=$SNMP_LIBS
+      LIB_UCDSNMP="$SNMP_LIBS -lwrap"
+      PERLLIBDIR=`$PERL -e 'use Config; print "$Config{archlibexp}/CORE";'`
+      LDFLAGS_UCDSNMP="-L${PERLLIBDIR} -R${PERLLIBDIR}"
       AC_DEFINE(HAVE_NETSNMP,1,[Do we have Net-SNMP support?])
       AC_SUBST(LIB_UCDSNMP)
+      AC_SUBST(LDFLAGS_UCDSNMP)
       AC_MSG_RESULT(yes)
     else
       AC_MSG_RESULT(no)
@@ -1847,7 +1855,7 @@
     LIB_UCDSNMP=""
     if test "$with_snmp" != no; then
       AC_DEFINE(HAVE_UCDSNMP,1,[Do we have UCD-SNMP support?])
-      LIB_UCDSNMP="-lucdagent -lucdmibs -lsnmp"
+      LIB_UCDSNMP="-lucdagent -lucdmibs -lsnmp -lkvm -ldevstat -lwrap"
       AC_CHECK_LIB(rpm, rpmdbOpen,
 		 LIB_UCDSNMP="${LIB_UCDSNMP} -lrpm -lpopt",,-lpopt)
     fi
