--- auth2.c.orig	Tue Sep  2 23:32:46 2003
+++ auth2.c	Tue Sep 16 20:05:44 2003
@@ -35,6 +35,7 @@
 #include "dispatch.h"
 #include "pathnames.h"
 #include "monitor_wrap.h"
+#include "canohost.h"
 
 #ifdef GSSAPI
 #include "ssh-gss.h"
@@ -143,6 +144,15 @@
 	Authmethod *m = NULL;
 	char *user, *service, *method, *style = NULL;
 	int authenticated = 0;
+#ifdef HAVE_LOGIN_CAP
+	login_cap_t *lc;
+#endif /* HAVE_LOGIN_CAP */
+#if defined(HAVE_LOGIN_CAP) || defined(LOGIN_ACCESS)
+	const char *from_host, *from_ip;
+
+	from_host = get_canonical_hostname(options.use_dns);
+	from_ip = get_remote_ipaddr();
+#endif /* HAVE_LOGIN_CAP || LOGIN_ACCESS */
 
 	if (authctxt == NULL)
 		fatal("input_userauth_request: no authctxt");
@@ -187,6 +197,41 @@
 		    "(%s,%s) -> (%s,%s)",
 		    authctxt->user, authctxt->service, user, service);
 	}
+
+#ifdef HAVE_LOGIN_CAP
+	if (authctxt->pw != NULL) {
+		lc = login_getpwclass(authctxt->pw);
+		if (lc == NULL)
+			lc = login_getclassbyname(NULL, authctxt->pw);
+		if (!auth_hostok(lc, from_host, from_ip)) {
+			logit("Denied connection for %.200s from %.200s [%.200s].",
+			    authctxt->pw->pw_name, from_host, from_ip);
+			packet_disconnect("Sorry, you are not allowed to connect.");
+		}
+		if (!auth_timeok(lc, time(NULL))) {
+			logit("LOGIN %.200s REFUSED (TIME) FROM %.200s",
+			    authctxt->pw->pw_name, from_host);
+			packet_disconnect("Logins not available right now.");
+		}
+		login_close(lc);
+		lc = NULL;
+	}
+#endif  /* HAVE_LOGIN_CAP */
+#ifdef LOGIN_ACCESS
+	if (authctxt->pw != NULL &&
+	    !login_access(authctxt->pw->pw_name, from_host)) {
+		logit("Denied connection for %.200s from %.200s [%.200s].",
+		    authctxt->pw->pw_name, from_host, from_ip);
+		packet_disconnect("Sorry, you are not allowed to connect.");
+	}
+#endif /* LOGIN_ACCESS */
+#ifdef BSD_AUTH
+	if (authctxt->as) {
+		auth_close(authctxt->as);
+		authctxt->as = NULL;
+	}
+#endif
+
 	/* reset state */
 	auth2_challenge_stop(authctxt);
 
