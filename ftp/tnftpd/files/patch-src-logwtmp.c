--- src/logwtmp.c-orig	Sun Feb 23 22:38:44 2003
+++ src/logwtmp.c	Sun Aug  3 15:53:32 2003
@@ -78,6 +78,26 @@
 	struct utmp ut;
 	struct stat buf;
 
+	if (strlen(host) > UT_HOSTSIZE) {
+		struct addrinfo hints, *res;
+		int error;
+		static char hostbuf[BUFSIZ];
+
+		memset(&hints, 0, sizeof(hints));
+		hints.ai_family = PF_UNSPEC;
+		error = getaddrinfo(host, NULL, &hints, &res);
+		if (error)
+			host = "invalid hostname";
+		else {
+			getnameinfo(res->ai_addr, res->ai_addrlen,
+				hostbuf, sizeof(hostbuf), NULL, 0,
+				NI_NUMERICHOST);
+			host = hostbuf;
+			if (strlen(host) > UT_HOSTSIZE)
+				host[UT_HOSTSIZE] = '\0';
+		}
+	}
+
 	if (fd < 0 && (fd = open(_PATH_WTMP, O_WRONLY|O_APPEND, 0)) < 0)
 		return;
 	if (fstat(fd, &buf) == 0) {
