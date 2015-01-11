--- nessusd/nessusd.c.orig	2006-10-16 17:55:54 UTC
+++ nessusd/nessusd.c
@@ -622,11 +622,17 @@ main_loop()
 
       if (ssl_mt == NULL)
 	{
+#ifndef OPENSSL_NO_SSL2
 	  if (strcasecmp(ssl_ver, "SSLv2") == 0)
 	    ssl_mt = SSLv2_server_method();
-	  else if (strcasecmp(ssl_ver, "SSLv3") == 0)
+	  else
+#endif
+#ifndef OPENSSL_NO_SSL3_METHOD
+	  if (strcasecmp(ssl_ver, "SSLv3") == 0)
 	    ssl_mt = SSLv3_server_method();
-	  else if (strcasecmp(ssl_ver, "SSLv23") == 0)
+	  else
+#endif
+	  if (strcasecmp(ssl_ver, "SSLv23") == 0)
 	    ssl_mt = SSLv23_server_method();
 	  else if (strcasecmp(ssl_ver, "TLSv1") == 0)
 	    ssl_mt = TLSv1_server_method();
