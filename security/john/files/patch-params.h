--- params.h.orig	Sat Dec 31 04:21:22 2005
+++ params.h	Sat Dec 31 04:25:13 2005
@@ -22,15 +22,15 @@
  * will probably want to set this to 1 for their builds of John.
  */
 #ifndef JOHN_SYSTEMWIDE
-#define JOHN_SYSTEMWIDE			0
+#define JOHN_SYSTEMWIDE			1
 #endif
 
 #if JOHN_SYSTEMWIDE
 #ifndef JOHN_SYSTEMWIDE_EXEC
-#define JOHN_SYSTEMWIDE_EXEC		"/usr/libexec/john"
+#define JOHN_SYSTEMWIDE_EXEC		"%%PREFIX%%/bin/john"
 #endif
 #ifndef JOHN_SYSTEMWIDE_HOME
-#define JOHN_SYSTEMWIDE_HOME		"/usr/share/john"
+#define JOHN_SYSTEMWIDE_HOME		"%%DATADIR%%"
 #endif
 #define JOHN_PRIVATE_HOME		"~/.john"
 #endif
@@ -74,8 +74,8 @@
 /*
  * File names.
  */
-#define CFG_FULL_NAME			"$JOHN/john.conf"
-#define CFG_ALT_NAME			"$JOHN/john.ini"
+#define CFG_FULL_NAME			"%%PREFIX%%/etc/john.conf"
+#define CFG_ALT_NAME			"%%PREFIX%%/etc/john.ini"
 #if JOHN_SYSTEMWIDE
 #define CFG_PRIVATE_FULL_NAME		JOHN_PRIVATE_HOME "/john.conf"
 #define CFG_PRIVATE_ALT_NAME		JOHN_PRIVATE_HOME "/john.ini"
@@ -89,7 +89,7 @@
 #endif
 #define LOG_SUFFIX			".log"
 #define RECOVERY_SUFFIX			".rec"
-#define WORDLIST_NAME			"$JOHN/password.lst"
+#define WORDLIST_NAME			"%%DATADIR%%/password.lst"
 
 /*
  * Configuration file section names.
