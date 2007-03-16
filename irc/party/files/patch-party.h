--- party.h.orig	Wed Oct 15 18:31:34 2003
+++ party.h	Wed Oct 15 18:31:58 2003
@@ -225,7 +225,7 @@
 
 #ifdef BSD
 #define L_FLOCK         /* Use flock() to lock files */
-#if defined(bsdi) || defined(linux)
+#if defined(bsdi) || defined(linux) || defined(__FreeBSD__)
 #define F_TERMIOS       /* Use tcsetattr() to set modes */
 #else
 #define F_STTY          /* Use stty() to set modes */
@@ -464,7 +464,7 @@
 #ifdef BSD
 int susp();
 #endif /*BSD*/
-vint err(), db();
+vint err(char *, ...), db(char *, ...);
 char *getlogin(), *malloc(), *ctime(), *fgets(), *getenv();
 char *chn_file_name(), *getline();
 char *strchr(), *strpbrk(), *strrchr(), *strstr();
