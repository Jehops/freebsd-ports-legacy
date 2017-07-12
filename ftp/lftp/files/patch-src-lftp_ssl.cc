Fix build with LibreSSL

--- src/lftp_ssl.cc.orig
+++ src/lftp_ssl.cc
@@ -772,7 +772,7 @@
 #elif USE_OPENSSL
 //static int lftp_ssl_passwd_callback(char *buf,int size,int rwflag,void *userdata);
 
-#if OPENSSL_VERSION_NUMBER < 0x10100000L
+#if OPENSSL_VERSION_NUMBER < 0x10100000L || LIBRESSL_VERSION_NUMBER
 // for compatibility with older versions
 X509_OBJECT *X509_OBJECT_new()
 {
