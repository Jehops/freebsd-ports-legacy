--- config.m4.orig	2007-07-31 15:02:00.000000000 +0200
+++ config.m4	2011-04-26 13:57:31.000000000 +0200
@@ -99,9 +99,12 @@
 dnl
 dnl configure options
 dnl
+PHP_ARG_ENABLE(odbc,,
+[  --enable-odbc           Enable ODBC support with selected driver])
+
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(adabas,,
-[  --with-adabas[=DIR]     Include Adabas D support [/usr/local]])
+[  --with-adabas[=DIR]     Include Adabas D support [/usr/local]], no, no)
 
   if test "$PHP_ADABAS" != "no"; then
     AC_MSG_CHECKING([for Adabas support])
@@ -128,7 +131,7 @@
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(sapdb,,
-[  --with-sapdb[=DIR]      Include SAP DB support [/usr/local]])
+[  --with-sapdb[=DIR]      Include SAP DB support [/usr/local]], no, no)
 
   if test "$PHP_SAPDB" != "no"; then
     AC_MSG_CHECKING([for SAP DB support])
@@ -146,7 +149,7 @@
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(solid,,
-[  --with-solid[=DIR]      Include Solid support [/usr/local/solid]])
+[  --with-solid[=DIR]      Include Solid support [/usr/local/solid]], no, no)
 
   if test "$PHP_SOLID" != "no"; then
     AC_MSG_CHECKING(for Solid support)
@@ -171,7 +174,7 @@
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(ibm-db2,,
-[  --with-ibm-db2[=DIR]    Include IBM DB2 support [/home/db2inst1/sqllib]])
+[  --with-ibm-db2[=DIR]    Include IBM DB2 support [/home/db2inst1/sqllib]], no, no)
 
   if test "$PHP_IBM_DB2" != "no"; then
     AC_MSG_CHECKING(for IBM DB2 support)
@@ -208,7 +211,7 @@
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(ODBCRouter,,
-[  --with-ODBCRouter[=DIR] Include ODBCRouter.com support [/usr]])
+[  --with-ODBCRouter[=DIR] Include ODBCRouter.com support [/usr]], no, no)
 
   if test "$PHP_ODBCROUTER" != "no"; then
     AC_MSG_CHECKING(for ODBCRouter.com support)
@@ -229,7 +232,7 @@
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(empress,,
 [  --with-empress[=DIR]    Include Empress support [\$EMPRESSPATH]
-                          (Empress Version >= 8.60 required)])
+                          (Empress Version >= 8.60 required)], no, no)
 
   if test "$PHP_EMPRESS" != "no"; then
     AC_MSG_CHECKING(for Empress support)
@@ -253,7 +256,7 @@
 PHP_ARG_WITH(empress-bcs,,
 [  --with-empress-bcs[=DIR]
                           Include Empress Local Access support [\$EMPRESSPATH]
-                          (Empress Version >= 8.60 required)])
+                          (Empress Version >= 8.60 required)], no, no)
 
   if test "$PHP_EMPRESS_BCS" != "no"; then
     AC_MSG_CHECKING(for Empress local access support)
@@ -291,7 +294,7 @@
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(birdstep,,
-[  --with-birdstep[=DIR]   Include Birdstep support [/usr/local/birdstep]])
+[  --with-birdstep[=DIR]   Include Birdstep support [/usr/local/birdstep]], no, no)
   
   if test "$PHP_BIRDSTEP" != "no"; then
     AC_MSG_CHECKING(for Birdstep support)
@@ -346,7 +349,7 @@
                           running this configure script:
                               CPPFLAGS=\"-DODBC_QNX -DSQLANY_BUG\"
                               LDFLAGS=-lunix
-                              CUSTOM_ODBC_LIBS=\"-ldblib -lodbc\"])
+                              CUSTOM_ODBC_LIBS=\"-ldblib -lodbc\"], no, no)
 
   if test "$PHP_CUSTOM_ODBC" != "no"; then
     AC_MSG_CHECKING(for a custom ODBC support)
@@ -366,7 +369,7 @@
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(iodbc,,
-[  --with-iodbc[=DIR]      Include iODBC support [/usr/local]])
+[  --with-iodbc[=DIR]      Include iODBC support [/usr/local]], no, no)
 
   if test "$PHP_IODBC" != "no"; then
     AC_MSG_CHECKING(for iODBC support)
@@ -387,7 +390,7 @@
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(esoob,,
-[  --with-esoob[=DIR]      Include Easysoft OOB support [/usr/local/easysoft/oob/client]])
+[  --with-esoob[=DIR]      Include Easysoft OOB support [/usr/local/easysoft/oob/client]], no, no)
 
   if test "$PHP_ESOOB" != "no"; then
     AC_MSG_CHECKING(for Easysoft ODBC-ODBC Bridge support)
@@ -407,7 +410,7 @@
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(unixODBC,,
-[  --with-unixODBC[=DIR]   Include unixODBC support [/usr/local]])
+[  --with-unixODBC[=DIR]   Include unixODBC support [/usr/local]], no, no)
 
   if test "$PHP_UNIXODBC" != "no"; then
     AC_MSG_CHECKING(for unixODBC support)
@@ -428,7 +431,7 @@
 
 if test -z "$ODBC_TYPE"; then
 PHP_ARG_WITH(dbmaker,,
-[  --with-dbmaker[=DIR]    Include DBMaker support])
+[  --with-dbmaker[=DIR]    Include DBMaker support], no, no)
 
   if test "$PHP_DBMAKER" != "no"; then
     AC_MSG_CHECKING(for DBMaker support)
