--- lib/mem.c.old	Tue Jan 25 20:16:57 2000
+++ lib/mem.c	Tue Jan 25 20:28:18 2000
@@ -44,6 +44,7 @@
 	return(_rval);
 }
 
+#if 0
 void	wzero(void *head, int n)
 {
 	__asm__	("cld\n\t"
@@ -76,6 +77,7 @@
 		"S" ((long)src)
 		:"cx","di","si");
 }
+#endif
 
 void	SafeFree(void **p)
 {
