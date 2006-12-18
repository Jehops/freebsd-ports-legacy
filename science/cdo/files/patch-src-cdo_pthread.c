--- src/cdo_pthread.c.orig	Wed Mar 22 22:04:18 2006
+++ src/cdo_pthread.c	Mon Dec 18 10:01:00 2006
@@ -32,8 +32,10 @@
 {
 #if  defined  (HAVE_LIBPTHREAD)
   pthread_attr_t attr;
+#if __FreeBSD_version >= 600000
   pthread_mutexattr_t m_attr;
   pthread_condattr_t c_attr;
+#endif
 
 #if defined (PTHREAD_KEYS_MAX)
   fprintf(stderr, "PTHREAD_KEYS_MAX    = %d\n", PTHREAD_KEYS_MAX);
@@ -54,6 +56,7 @@
   print_pthread_attr("Default pthread attr", &attr);
   pthread_attr_destroy(&attr);
 
+#if __FreeBSD_version >= 600000
   pthread_mutexattr_init(&m_attr);
   print_pthread_mutexattr("Default pthread mutexattr", &m_attr);
   pthread_mutexattr_destroy(&m_attr);
@@ -61,6 +64,7 @@
   pthread_condattr_init(&c_attr);
   print_pthread_condattr("Default pthread condattr ", &c_attr);
   pthread_condattr_destroy(&c_attr);
+#endif
 
   fprintf(stderr, "\n");
 #endif
