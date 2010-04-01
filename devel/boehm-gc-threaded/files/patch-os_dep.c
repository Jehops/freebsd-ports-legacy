--- os_dep.c.orig	2008-02-29 11:01:28.000000000 -0800
+++ os_dep.c	2010-04-01 00:50:34.000000000 -0700
@@ -816,7 +816,7 @@
     || defined(HURD) || defined(NETBSD)
 	static struct sigaction old_segv_act;
 #	if defined(_sigargs) /* !Irix6.x */ || defined(HPUX) \
-	|| defined(HURD) || defined(NETBSD)
+	|| defined(HURD) || defined(NETBSD) || defined(FREEBSD)
 	    static struct sigaction old_bus_act;
 #	endif
 #   else
@@ -826,7 +826,7 @@
     void GC_set_and_save_fault_handler(handler h)
     {
 #	if defined(SUNOS5SIGS) || defined(IRIX5)  \
-        || defined(OSF1) || defined(HURD) || defined(NETBSD)
+        || defined(OSF1) || defined(HURD) || defined(NETBSD) || defined(FREEBSD)
 	  struct sigaction	act;
 
 	  act.sa_handler	= h;
@@ -846,7 +846,7 @@
 #	  else
 	        (void) sigaction(SIGSEGV, &act, &old_segv_act);
 #		if defined(IRIX5) && defined(_sigargs) /* Irix 5.x, not 6.x */ \
-		   || defined(HPUX) || defined(HURD) || defined(NETBSD)
+		   || defined(HPUX) || defined(HURD) || defined(NETBSD) || defined(FREEBSD)
 		    /* Under Irix 5.x or HP/UX, we may get SIGBUS.	*/
 		    /* Pthreads doesn't exist under Irix 5.x, so we	*/
 		    /* don't have to worry in the threads case.		*/
@@ -2713,7 +2713,13 @@
 #   include <errno.h>
 #   if defined(FREEBSD)
 #     define SIG_OK TRUE
-#     define CODE_OK (code == BUS_PAGE_FAULT)
+#     if defined(POWERPC)
+#	define AIM	/* Pretend that we're AIM. */
+#	include <machine/trap.h>
+#       define CODE_OK (code == EXC_DSI)
+#     else
+#       define CODE_OK (code == BUS_PAGE_FAULT)
+#     endif
 #   elif defined(OSF1)
 #     define SIG_OK (sig == SIGSEGV)
 #     define CODE_OK (code == 2 /* experimentally determined */)
