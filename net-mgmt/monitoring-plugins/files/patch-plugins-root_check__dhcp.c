--- plugins-root/check_dhcp.c.orig	2014-11-30 10:36:26 UTC
+++ plugins-root/check_dhcp.c
@@ -323,7 +323,8 @@ int get_hardware_address(int sock,char *
 #elif defined(__bsd__)
 						/* King 2004	see ACKNOWLEDGEMENTS */
 
-        int                     mib[6], len;
+        int                     mib[6];
+        size_t                  len;
         char                    *buf;
         unsigned char           *ptr;
         struct if_msghdr        *ifm;
@@ -1182,7 +1183,7 @@ int call_getopt(int argc, char **argv){
 		        }
 	        }
 
-	return i;
+	return i+1;
         }
 
 
