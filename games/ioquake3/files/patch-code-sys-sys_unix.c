--- code/sys/sys_unix.c.orig	2008-11-11 00:55:22.000000000 +0100
+++ code/sys/sys_unix.c	2011-10-27 13:11:15.000000000 +0200
@@ -53,7 +53,9 @@
 		if( ( p = getenv( "HOME" ) ) != NULL )
 		{
 			Q_strncpyz( homePath, p, sizeof( homePath ) );
-#ifdef MACOS_X
+#ifdef HOMEPATH
+			Q_strcat( homePath, sizeof( homePath ), HOMEPATH );
+#elif defined MACOS_X
 			Q_strcat( homePath, sizeof( homePath ), "/Library/Application Support/Quake3" );
 #else
 			Q_strcat( homePath, sizeof( homePath ), "/.q3a" );
