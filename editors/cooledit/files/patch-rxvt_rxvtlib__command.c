--- rxvt/rxvtlib_command.c.orig	2005-04-04 20:47:45.000000000 +0000
+++ rxvt/rxvtlib_command.c
@@ -385,7 +385,7 @@ int             rxvtlib_get_tty (rxvtlib
 	o->killed = EXIT_FAILURE | DO_EXIT;
 	return -1;
     }
-#ifdef PTYS_ARE_PTMX
+#if defined(PTYS_ARE_PTMX) && !defined(__DragonFly__)
 /*
  * Push STREAMS modules:
  *    ptem: pseudo-terminal hardware emulation module.
