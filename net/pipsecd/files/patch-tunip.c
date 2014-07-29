--- tunip.c.orig	Tue Sep 21 15:20:40 1999
+++ tunip.c	Thu Jul 20 04:26:39 2006
@@ -35,6 +35,8 @@
 #include <unistd.h>
 #include <fcntl.h>
 #include <stdio.h>
+#include <sys/ioctl.h>
+#include <net/if_tun.h>
 #include <netinet/in_systm.h>
 #include <netinet/in.h>
 #include <netinet/ip.h>
@@ -54,12 +56,14 @@
 #include <blowfish.h>
 #include <cast.h>
 #include <des.h>
+#ifndef NO_IDEA
 #include <idea.h>
+#endif
 
 #include "defs.h"
 
-#define _PATH_CONF		"/etc/ipsec/pipsecd.conf"
-#define _PATH_STARTUP		"/etc/ipsec/startup"
+#define _PATH_CONF              FILE_PREFIX "/etc/ipsec/pipsecd.conf"
+#define _PATH_STARTUP           FILE_PREFIX "/etc/ipsec/startup"
 #define _PATH_DEV_RANDOM	"/dev/random"
 
 #ifdef USE_ETHERTAP
@@ -100,6 +104,7 @@
 #endif
 
 unsigned char buf[MAX_HEADER+MAX_PACKET];
+char *cmd;
 
 typedef union {
     MD5_CTX md5;
@@ -131,7 +136,9 @@
 	des_key_schedule k3;
     } des3;
     CAST_KEY cast;
+#ifndef NO_IDEA
     IDEA_KEY_SCHEDULE idea;
+#endif
 } crypt_key;
 
 typedef struct crypt_method {
@@ -304,12 +311,14 @@
 void cast_cbc_decrypt(unsigned char *iv, crypt_key *dk,
 		      unsigned char *ct, unsigned int len);
 int cast_setkey(unsigned char *b, unsigned int len, crypt_key *k);
+#ifndef NO_IDEA
 void my_idea_cbc_encrypt(unsigned char *iv, crypt_key *ek,
 			 unsigned char *t, unsigned int len);
 void my_idea_cbc_decrypt(unsigned char *iv, crypt_key *dk,
 			 unsigned char *ct, unsigned int len);
 int my_idea_set_encrypt_key(unsigned char *b, unsigned int len, crypt_key *k);
 int my_idea_set_decrypt_key(unsigned char *b, unsigned int len, crypt_key *k);
+#endif
 void my_des_cbc_encrypt(unsigned char *iv, crypt_key *ek,
 			unsigned char *t, unsigned int len);
 void my_des_cbc_decrypt(unsigned char *iv, crypt_key *dk,
@@ -379,14 +388,20 @@
 
 hash_method_t *hash_list = &hash_ripemd160;
 
+#ifndef NO_IDEA
 crypt_method_t crypt_idea = {
     NULL,
     "idea_cbc", 8, 8,
     my_idea_cbc_encrypt, my_idea_cbc_decrypt,
     my_idea_set_encrypt_key, my_idea_set_decrypt_key
 };
+#endif
 crypt_method_t crypt_cast = {
+#ifndef NO_IDEA
     &crypt_idea,
+#else
+    NULL,
+#endif
     "cast_cbc", 8, 8,
     cast_cbc_encrypt, cast_cbc_decrypt,
     cast_setkey, cast_setkey
@@ -704,13 +719,22 @@
  */
 int tun_send_ip(struct tun_method *this, struct encap_method *encap, int fd)
 {
-    int sent;
+    int sent, i;
 
     if (this->link_header_size) {
         encap->buflen += this->link_header_size;
         encap->buf -= this->link_header_size;
         memcpy(encap->buf, this->link_header, this->link_header_size);
     }
+#if 0
+    printf ("Packet sent to tun dev:");
+    for (i = 0; i < encap->buflen; i++) {
+      if (!(i % 16))
+        printf ("\n    ");
+      printf (" %02x", encap->buf[i]);
+    }
+    printf ("\n\n");   
+#endif
     sent = write(fd, encap->buf, encap->buflen);
     if (sent != encap->buflen)
         syslog(LOG_ERR, "truncated in: %d -> %d\n", encap->buflen, sent);
@@ -1120,6 +1144,7 @@
 	    }
 	} else if (strcmp(arg, "if") == 0) {
 	    int fd;
+	    int i = 0;
 	    struct sa_desc *local_sa, *remote_sa;
 	    struct peer_desc *peer;
 
@@ -1128,6 +1153,7 @@
 		perror(arg);
 		continue;
 	    }
+	    ioctl (fd, TUNSIFHEAD, &i);
 
 	    local_sa = NULL;
 	    remote_sa = NULL;
@@ -1974,6 +2000,7 @@
     return 0;
 }
 
+#ifndef NO_IDEA
 void my_idea_cbc_encrypt(unsigned char *iv, crypt_key *ek,
 			 unsigned char *t, unsigned int len)
 {
@@ -2002,6 +2029,7 @@
     idea_set_decrypt_key(&k->idea, &k->idea);
     return 0;
 }
+#endif
 
 void my_des_cbc_encrypt(unsigned char *iv, crypt_key *ek,
 			unsigned char *t, unsigned int len)
@@ -2081,6 +2109,11 @@
     return 0;
 }
 
+void usage()
+{
+    fprintf(stderr, "%s: usage: [ -c CONFIG ] [ -s SCRIPT ]\n", cmd);
+    exit(1);
+}
 int main(int argc, char **argv)
 {
     time_t t;
@@ -2088,9 +2121,14 @@
     int pack, i;
     struct sockaddr_in from;
     struct stat sb;
+    int ch;
+    char *path_conf = _PATH_CONF;
+    char *path_startup = _PATH_STARTUP;
 
     FILE *f;
 
+    cmd=argv[0];
+
     openlog ("pipsecd", LOG_PID, LOG_DAEMON);
     syslog (LOG_NOTICE, "pipsecd starting");
 
@@ -2113,7 +2151,21 @@
     if (encap_icmp_new(&encap_meth[ENCAP_ICMP], IPPROTO_ICMP) == -1)
 	exit(1);
 
-    f = fopen(_PATH_CONF, "r");
+    while ((ch = getopt(argc, argv, "c:s:")) != -1) {
+	switch (ch) {
+	case 'c':
+	    path_conf = optarg;
+	    break;
+	case 's':
+	    path_startup = optarg;
+	    break;
+	case '?':
+	default:
+	    usage();
+	}
+    }
+
+    f = fopen(path_conf, "r");
     if (f == NULL) {
 	perror("configuration file");
 	exit(1);
@@ -2123,8 +2175,8 @@
     fclose(f);
 
     /* Execute startup script, if any */
-    if (stat(_PATH_STARTUP, &sb) == 0 && (sb.st_mode & 0400))
-	system(_PATH_STARTUP);
+    if (stat(path_startup, &sb) == 0 && (sb.st_mode & 0400))
+	system(path_startup);
 
     /* Send a probe to every peer on startup */
     for (i = 0; i < peer_num; i++)
