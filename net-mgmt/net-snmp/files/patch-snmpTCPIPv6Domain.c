--- snmplib/snmpTCPIPv6Domain.c.orig	Wed Jul 17 03:20:43 2002
+++ snmplib/snmpTCPIPv6Domain.c	Thu Jul 25 19:55:47 2002
@@ -62,13 +62,21 @@
     if (to == NULL) {
         return strdup("TCP/IPv6: unknown");
     } else {
-        char            addr[INET6_ADDRSTRLEN];
-        char            tmp[INET6_ADDRSTRLEN + 8];
+        char            tmp[NI_MAXHOST];
 
-        sprintf(tmp, "[%s]:%hd",
-                inet_ntop(AF_INET6, (void *) &(to->sin6_addr), addr,
-                          INET6_ADDRSTRLEN), ntohs(to->sin6_port));
-        return strdup(tmp);
+/*
+ * NI_WITHSCOPEID will be obsoleted.  But some implementations require
+ * this flag to retrieve scoped name.
+ * (2002-07-25: kuriyama@FreeBSD.org)
+ */
+#ifndef NI_WITHSCOPEID
+#define NI_WITHSCOPEID 0
+#endif
+	if (getnameinfo(to, sizeof(struct sockaddr_in6), tmp, sizeof(tmp),
+			NULL, 0, NI_NUMERICHOST | NI_WITHSCOPEID)) {
+	    return strdup("UDP/IPv6: unknown");
+	}
+	return strdup(tmp);
     }
 }
 
