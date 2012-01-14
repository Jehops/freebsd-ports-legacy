--- pop_pass.c.orig	1998-07-10 03:44:07.000000000 +0400
+++ pop_pass.c	2012-01-09 03:03:30.395199055 +0400
@@ -19,6 +19,12 @@
 #include <pwd.h>
 #include "popper.h"
 
+#ifdef OPIE
+#include <opie.h>
+extern int pwok;
+extern struct opie opiestate;
+#endif /* OPIE */
+
 #define	SLEEP_SECONDS 10
 
 
@@ -487,16 +493,28 @@
 POP     *   p;
 struct passwd  *   pw;
 {
+#if defined(BSD) && (BSD >= 199306)
+    /* Check password change and expire times before granting access */
+    time_t now = time((time_t *) NULL);
+
+    if ((pw->pw_change && now > pw->pw_change) ||
+        (pw->pw_expire && now > pw->pw_expire))
+	goto error;
+#endif
+
     /*  We don't accept connections from users with null passwords */
-    /*  Compare the supplied password with the password file entry */
+    if ((pw->pw_passwd == NULL) || (*pw->pw_passwd == '\0'))
+	goto error;
 
-    if ((pw->pw_passwd == NULL) || (*pw->pw_passwd == '\0') ||
-		strcmp(crypt(p->pop_parm[1], pw->pw_passwd), pw->pw_passwd)) {
-	sleep(SLEEP_SECONDS);
-	return (pop_msg(p,POP_FAILURE, pwerrmsg, p->user));
-    }
+    /*  Compare the supplied password with the password file entry */
+    if (strcmp(crypt(p->pop_parm[1], pw->pw_passwd), pw->pw_passwd))
+	goto error;
 
     return(POP_SUCCESS);
+
+  error:
+    sleep(SLEEP_SECONDS);
+    return (pop_msg(p,POP_FAILURE, pwerrmsg, p->user));
 }
 
 #endif	/* AUTH_SPECIAL */
@@ -611,12 +629,23 @@
 	return(pop_msg(p, POP_FAILURE, "\"%s\": shell not found.", p->user));
 #endif
 
-    if ((p->kerberos ? auth_user_kerberos(p, pw) : auth_user(p, pwp))
+#ifdef OPIE
+    if (opieverify(&opiestate, p->pop_parm[1])) {
+       if (pwok) {
+#endif /* OPIE */
+    if ((p->kerberos ? auth_user_kerberos(p, &pw) : auth_user(p, pwp))
 							!= POP_SUCCESS) {
 	    pop_log(p,POP_PRIORITY,"Failed attempted login to %s from host %s",
 							    p->user, p->client);
 	return(POP_FAILURE);
     }
+#ifdef OPIE
+	} else {
+	    sleep(SLEEP_SECONDS);
+	    return (pop_msg(p,POP_FAILURE, pwerrmsg, p->user));
+	}
+     }
+#endif /* OPIE */
 
 #ifdef SECURENISPLUS
     seteuid(uid_save);
