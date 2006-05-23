--- src/tabe_tsidbint.c.orig	Sun Nov 11 07:33:07 2001
+++ src/tabe_tsidbint.c	Mon May  1 00:47:55 2006
@@ -27,6 +27,7 @@
 #endif
 
 #include "tabe.h"
+#define DB_VERSION (DB_VERSION_MAJOR*100000+DB_VERSION_MINOR*1000+DB_VERSION_PATCH)
 
 static void tabeTsiDBClose(struct TsiDB *tsidb);
 static int  tabeTsiDBRecordNumber(struct TsiDB *tsidb);
@@ -69,7 +70,7 @@
 {
   DB *dbp=NULL;
 
-#ifdef HAVE_DB3
+#if DB_VERSION >= 300000
   /* create a db handler */
   if ((errno = db_create(&dbp, NULL, 0)) != 0) {
     fprintf(stderr, "db_create: %s\n", db_strerror(errno));
@@ -82,26 +83,32 @@
       return(NULL);
     }
     else {
-#ifndef HAVE_DB3
-      errno = db_open(db_name, DB_BTREE, DB_CREATE, 0644, NULL, NULL, &dbp);
-#else
+#if DB_VERSION >= 401025
+      errno = dbp->open(dbp, NULL, db_name, NULL, DB_BTREE, DB_CREATE, 0644);
+#elif DB_VERSION >= 300000
       errno = dbp->open(dbp, db_name, NULL, DB_BTREE, DB_CREATE, 0644);
+#else
+      errno = db_open(db_name, DB_BTREE, DB_CREATE, 0644, NULL, NULL, &dbp);
 #endif
     }
   }
   else {
     if (flags & DB_FLAG_READONLY) {
-#ifndef HAVE_DB3
-      errno = db_open(db_name, DB_BTREE, DB_RDONLY, 0444, NULL, NULL, &dbp);
-#else
+#if DB_VERSION >= 401025
+      errno = dbp->open(dbp, NULL, db_name, NULL, DB_BTREE, DB_RDONLY, 0444);
+#elif DB_VERSION >= 300000
       errno = dbp->open(dbp, db_name, NULL, DB_BTREE, DB_RDONLY, 0444);
+#else
+      errno = db_open(db_name, DB_BTREE, DB_RDONLY, 0444, NULL, NULL, &dbp);
 #endif
     }
     else {
-#ifndef HAVE_DB3
-      errno = db_open(db_name, DB_BTREE, 0, 0644, NULL, NULL, &dbp);
-#else
+#if DB_VERSION >= 401025
+      errno = dbp->open(dbp, NULL, db_name, NULL, DB_BTREE, 0, 0644);
+#elif DB_VERSION >= 300000
       errno = dbp->open(dbp, db_name, NULL, DB_BTREE, 0, 0644);
+#else
+      errno = db_open(db_name, DB_BTREE, 0, 0644, NULL, NULL, &dbp);
 #endif
     }
   }
@@ -112,10 +119,10 @@
   }
   if (errno < 0) {
     /* DB specific errno */
-#ifndef HAVE_DB3
-    fprintf(stderr, "tabeTsiDBOpen(): DB error opening DB File %s.\n", db_name);
-#else
+#if DB_VERSION >= 300000
     fprintf(stderr, "tabeTsiDBOpen(): %s.\n", db_strerror(errno));
+#else
+    fprintf(stderr, "tabeTsiDBOpen(): DB error opening DB File %s.\n", db_name);
 #endif
     return(NULL);
   }
@@ -265,12 +272,18 @@
   switch(tsidb->type) {
   case DB_TYPE_DB:
     dbp = (DB *)tsidb->dbp;
+#if DB_VERSION >= 403000
+    errno = dbp->stat(dbp, NULL, &sp, 0);
+#elif DB_VERSION >= 303011
+    errno = dbp->stat(dbp, &sp, 0);
+#else
     errno = dbp->stat(dbp, &sp, NULL, 0);
+#endif
     if (!errno) {
-#ifndef HAVE_DB3
-      return(sp->bt_nrecs);
-#else
+#if DB_VERSION >= 300000
       return(sp->bt_ndata);  /* or sp->bt_nkeys? */
+#else
+      return(sp->bt_nrecs);
 #endif
     }
     break;
@@ -502,14 +515,10 @@
     dbcp->c_close(dbcp);
   }
 
-#ifndef HAVE_DB3
-#if DB_VERSION_MINOR > 6 || (DB_VERSION_MINOR == 6 && DB_VERSION_PATCH > 4)
+#if DB_VERSION >= 206004
   dbp->cursor(dbp, NULL, &dbcp, 0);
 #else
   dbp->cursor(dbp, NULL, &dbcp);
-#endif
-#else
-  dbp->cursor(dbp, NULL, &dbcp, 0);
 #endif
   tsidb->dbcp = dbcp;
 
