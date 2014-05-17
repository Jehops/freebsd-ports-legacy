--- icb.c.orig	2004-11-19 06:14:28.000000000 +0900
+++ icb.c	2014-05-17 02:34:25.000000000 +0900
@@ -30,7 +30,9 @@
  *
  */
 
+#if 0
 static const char rcsid[] = "$Id: icb.c,v 1.15 2004/11/18 21:14:28 dhartmei Exp $";
+#endif
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -40,8 +42,8 @@
 
 extern int	 sync_write(int, const char *, int);
 
-static unsigned char	 icb_args(const char *, unsigned char, char [255][255]);
-static void		 icb_cmd(const char *, unsigned char, int, int);
+static unsigned char	 icb_args(const unsigned char *, unsigned char, char [255][255]);
+static void		 icb_cmd(const unsigned char *, unsigned char, int, int);
 static void		 icb_ico(int, const char *);
 static void		 icb_iwl(int, const char *, const char *, long,
 			    long, const char *, const char *);
@@ -108,7 +110,7 @@
  */
 
 void
-scan(const char **s, char *d, size_t siz, const char *skip, const char *term)
+scan(const unsigned char **s, char *d, size_t siz, const char *skip, const char *term)
 {
 	while (**s && strchr(skip, **s) != NULL)
 		(*s)++;
@@ -149,7 +151,7 @@
 }
 
 static unsigned char
-icb_args(const char *data, unsigned char len, char args[255][255])
+icb_args(const unsigned char *data, unsigned char len, char args[255][255])
 {
 	unsigned char i = 0, j = 0, k = 0;
 
@@ -175,10 +177,10 @@
 }
 
 static void
-icb_cmd(const char *cmd, unsigned char len, int fd, int server_fd)
+icb_cmd(const unsigned char *cmd, unsigned char len, int fd, int server_fd)
 {
 	char args[255][255];
-	const char *a = args[1];
+	const unsigned char *a = (unsigned char *)args[1];
 	unsigned char i, j;
 	char s[8192];
 
@@ -254,7 +256,7 @@
 			char old_nick[256], new_nick[256];
 
 			scan(&a, old_nick, sizeof(old_nick), " ", " ");
-			if (strncmp(a, " changed nickname to ", 21))
+			if (strncmp((const char *)a, " changed nickname to ", 21))
 				return;
 			a += 21;
 			scan(&a, new_nick, sizeof(new_nick), " ", " ");
@@ -268,7 +270,7 @@
 			char nick[256], topic[256];
 
 			scan(&a, nick, sizeof(nick), " ", " ");
-			if (strncmp(a, " changed the topic to \"", 23))
+			if (strncmp((const char *)a, " changed the topic to \"", 23))
 				return;
 			a += 23;
 			scan(&a, topic, sizeof(topic), "", "\"");
@@ -279,13 +281,13 @@
 			char old_mod[256], new_mod[256];
 
 			scan(&a, old_mod, sizeof(old_mod), " ", " ");
-			if (!strncmp(a, " has passed moderation to ", 26)) {
+			if (!strncmp((const char *)a, " has passed moderation to ", 26)) {
 				a += 26;
 				scan(&a, new_mod, sizeof(new_mod), " ", " ");
 				snprintf(s, sizeof(s),
 				    ":%s MODE %s -o+o %s %s\r\n",
 				    old_mod, irc_channel, old_mod, new_mod);
-			} else if (!strcmp(a, " is now mod.")) {
+			} else if (!strcmp((const char *)a, " is now mod.")) {
 				snprintf(s, sizeof(s),
 				    ":%s MODE %s +o %s\r\n",
 				    icb_hostid, irc_channel, old_mod);
@@ -297,7 +299,7 @@
 			char nick[256];
 
 			scan(&a, nick, sizeof(nick), " ", " ");
-			if (strcmp(a, " was booted."))
+			if (strcmp((const char *)a, " was booted."))
 				return;
 			snprintf(s, sizeof(s), ":%s KICK %s %s :booted\r\n",
 			    icb_moderator, irc_channel, nick);
@@ -508,7 +510,7 @@
 		cmd[off++] = 0;
 		cmd[0] = off - 1;
 		/* cmd[0] <= MAX_MSG_SIZE */
-		sync_write(fd, cmd, off);
+		sync_write(fd, (const char *)cmd, off);
 	}
 }
 
@@ -533,7 +535,7 @@
 		cmd[off++] = 0;
 		cmd[0] = off - 1;
 		/* cmd[0] <= MAX_MSG_SIZE */
-		sync_write(fd, cmd, off);
+		sync_write(fd, (const char *)cmd, off);
 	}
 }
 
