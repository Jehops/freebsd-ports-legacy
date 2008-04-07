--- src/alloc.c.orig	2008-01-02 14:45:48.000000000 +0200
+++ src/alloc.c	2008-01-02 14:41:21.000000000 +0200
@@ -4532,8 +4532,12 @@
      needed on ia64 too.  See mach_dep.c, where it also says inline
      assembler doesn't work with relevant proprietary compilers.  */
 #ifdef sparc
+#ifdef __sparc64__
+  asm ("flushw");
+#else
   asm ("ta 3");
 #endif
+#endif
 
   /* Save registers that we need to see on the stack.  We need to see
      registers used to hold register variables and registers used to
