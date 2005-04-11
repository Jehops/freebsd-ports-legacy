--- libgamin/gam_api.c.orig	Mon Apr 11 04:10:54 2005
+++ libgamin/gam_api.c	Mon Apr 11 04:16:49 2005
@@ -13,6 +13,7 @@
 #include <sys/stat.h>
 #include <sys/socket.h>
 #include <sys/un.h>
+#include <sys/uio.h>
 #include "fam.h"
 #include "gam_protocol.h"
 #include "gam_data.h"
@@ -181,7 +182,6 @@
     snprintf(path, MAXPATHLEN, "/tmp/fam-%s", user);
     path[MAXPATHLEN] = 0;
     ret = strdup(path);
-    free(user);
     return (ret);
 }
 
@@ -421,9 +421,35 @@
 {
     char data[2] = { 0, 0 };
     int written;
+#if defined(HAVE_CMSGCRED) && !defined(LOCAL_CREDS)
+    struct {
+	    struct cmsghdr hdr;
+	    struct cmsgcred cred;
+    } cmsg;
+    struct iovec iov;
+    struct msghdr msg;
+
+    iov.iov_base = &data[0];
+    iov.iov_len = 1;
+
+    memset (&msg, 0, sizeof (msg));
+    msg.msg_iov = &iov;
+    msg.msg_iovlen = 1;
+
+    msg.msg_control = &cmsg;
+    msg.msg_controllen = sizeof (cmsg);
+    memset (&cmsg, 0, sizeof (cmsg));
+    cmsg.hdr.cmsg_len = sizeof (cmsg);
+    cmsg.hdr.cmsg_level = SOL_SOCKET;
+    cmsg.hdr.cmsg_type = SCM_CREDS;
+#endif
 
 retry:
+#if defined(HAVE_CMSGCRED) && !defined(LOCAL_CREDS)
+    written = sendmsg(fd, &msg, 0);
+#else
     written = write(fd, &data[0], 1);
+#endif
     if (written < 0) {
         if (errno == EINTR)
             goto retry;
@@ -616,8 +642,10 @@
     gid_t c_gid;
 
 #ifdef HAVE_CMSGCRED
-    char cmsgmem[CMSG_SPACE(sizeof(struct cmsgcred))];
-    struct cmsghdr *cmsg = (struct cmsghdr *) cmsgmem;
+    struct {
+	    struct cmsghdr hdr;
+	    struct cmsgcred cred;
+    } cmsg;
 #endif
 
     s_uid = getuid();
@@ -642,9 +670,9 @@
     msg.msg_iovlen = 1;
 
 #ifdef HAVE_CMSGCRED
-    memset(cmsgmem, 0, sizeof(cmsgmem));
-    msg.msg_control = cmsgmem;
-    msg.msg_controllen = sizeof(cmsgmem);
+    memset(&cmsg, 0, sizeof(cmsg));
+    msg.msg_control = &cmsg;
+    msg.msg_controllen = sizeof(cmsg);
 #endif
 
 retry:
@@ -661,7 +689,7 @@
         goto failed;
     }
 #ifdef HAVE_CMSGCRED
-    if (cmsg->cmsg_len < sizeof(cmsgmem) || cmsg->cmsg_type != SCM_CREDS) {
+    if (cmsg.hdr.cmsg_len < sizeof(cmsg) || cmsg.hdr.cmsg_type != SCM_CREDS) {
         GAM_DEBUG(DEBUG_INFO,
                   "Message from recvmsg() was not SCM_CREDS\n");
         goto failed;
@@ -687,13 +715,9 @@
             goto failed;
         }
 #elif defined(HAVE_CMSGCRED)
-        struct cmsgcred *cred;
-
-        cred = (struct cmsgcred *) CMSG_DATA(cmsg);
-
-        c_pid = cred->cmcred_pid;
-        c_uid = cred->cmcred_euid;
-        c_gid = cred->cmcred_groups[0];
+        c_pid = cmsg.cred.cmcred_pid;
+        c_uid = cmsg.cred.cmcred_euid;
+        c_gid = cmsg.cred.cmcred_groups[0];
 #else /* !SO_PEERCRED && !HAVE_CMSGCRED */
         GAM_DEBUG(DEBUG_INFO,
                   "Socket credentials not supported on this OS\n");
