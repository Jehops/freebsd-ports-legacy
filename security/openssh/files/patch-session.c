--- session.c.orig	Mon Mar 25 06:21:20 2002
+++ session.c	Mon Mar 25 06:22:52 2002
@@ -57,6 +57,13 @@
 #include "canohost.h"
 #include "session.h"
 
+#ifdef __FreeBSD__
+#include <libutil.h>
+#include <syslog.h>
+#include <time.h>
+#define _PATH_CHPASS "/usr/bin/passwd"
+#endif /* __FreeBSD__ */
+
 /* types */
 
 #define TTYSZ 64
@@ -386,6 +393,10 @@
 	if (s == NULL)
 		fatal("do_exec_no_pty: no session");
 
+#ifdef USE_PAM
+	do_pam_setcred();
+#endif /* USE_PAM */
+
 	session_proctitle(s);
 
 	/* Fork the child. */
@@ -394,6 +405,13 @@
 		log_init(__progname, options.log_level, options.log_facility, log_stderr);
 
 		/*
+		 * Using login and executing a specific "command" are mutually
+		 * exclusive, so turn off use_login if there's a command.
+		 */
+		if (command != NULL)
+			options.use_login = 0;
+
+		/*
 		 * Create a new session and process group since the 4.4BSD
 		 * setlogin() affects the entire process group.
 		 */
@@ -494,11 +512,24 @@
 	ptyfd = s->ptyfd;
 	ttyfd = s->ttyfd;
 
+#ifdef USE_PAM
+	do_pam_session(s->pw->pw_name, s->tty);
+	do_pam_setcred();
+#endif /* USE_PAM */
+
 	/* Fork the child. */
 	if ((pid = fork()) == 0) {
 
 		/* Child.  Reinitialize the log because the pid has changed. */
 		log_init(__progname, options.log_level, options.log_facility, log_stderr);
+
+		/*
+		 * Using login and executing a specific "command" are mutually
+		 * exclusive, so turn off use_login if there's a command.
+		 */
+		if (command != NULL)
+			options.use_login = 0;
+
 		/* Close the master side of the pseudo tty. */
 		close(ptyfd);
 
@@ -583,12 +614,24 @@
 do_login(Session *s, const char *command)
 {
 	char *time_string;
+	char *newcommand;
 	char hostname[MAXHOSTNAMELEN];
 	socklen_t fromlen;
 	struct sockaddr_storage from;
 	time_t last_login_time;
 	struct passwd * pw = s->pw;
 	pid_t pid = getpid();
+#ifdef HAVE_LOGIN_CAP
+	FILE *f;
+	char buf[256];
+	char *fname;
+	const char *shorttty;
+#endif /* HAVE_LOGIN_CAP */
+#ifdef __FreeBSD__
+#define DEFAULT_WARN  (2L * 7L * 86400L)  /* Two weeks */
+	struct timeval tv;
+	time_t warntime = DEFAULT_WARN;
+#endif /* __FreeBSD__ */
 
 	/*
 	 * Get IP address of client. If the connection is not a socket, let
@@ -616,10 +659,101 @@
 	    get_remote_name_or_ip(utmp_len, options.verify_reverse_mapping),
 	    (struct sockaddr *)&from);
 
+#ifdef USE_PAM
+	/*
+	 * If password change is needed, do it now.
+	 * This needs to occur before the ~/.hushlogin check.
+	 */
+	if (pam_password_change_required()) {
+		print_pam_messages();
+		do_pam_chauthtok();
+	}
+#endif
+
+#ifdef USE_PAM
+	if (!check_quietlogin(s, command) && !pam_password_change_required())
+		print_pam_messages();
+#endif /* USE_PAM */
+#ifdef __FreeBSD__
+	if (pw->pw_change || pw->pw_expire)
+		(void)gettimeofday(&tv, NULL);
+#ifdef HAVE_LOGIN_CAP
+	warntime = login_getcaptime(lc, "warnpassword",
+				    DEFAULT_WARN, DEFAULT_WARN);
+#endif /* HAVE_LOGIN_CAP */
+	/*
+	 * If the password change time is set and has passed, give the
+	 * user a password expiry notice and chance to change it.
+	 */
+	if (pw->pw_change != 0) {
+		if (tv.tv_sec >= pw->pw_change) {
+			(void)printf(
+			    "Sorry -- your password has expired.\n");
+			log("%s Password expired - forcing change",
+			    pw->pw_name);
+			if (newcommand != NULL)
+				xfree(newcommand);
+			newcommand = xstrdup(_PATH_CHPASS);
+		} else if (pw->pw_change - tv.tv_sec < warntime &&
+			   !check_quietlogin(s, command))
+			(void)printf(
+			    "Warning: your password expires on %s",
+			     ctime(&pw->pw_change));
+	}
+#ifndef USE_PAM
+	if (pw->pw_expire) {
+		if (tv.tv_sec >= pw->pw_expire) {
+			(void)printf(
+			    "Sorry -- your account has expired.\n");
+			log(
+	   "LOGIN %.200s REFUSED (EXPIRED) FROM %.200s ON TTY %.200s",
+				pw->pw_name, get_remote_name_or_ip(utmp_len,
+				options.verify_reverse_mapping), s->tty);
+			exit(254);
+		} else if (pw->pw_expire - tv.tv_sec < warntime &&
+			   !check_quietlogin(s, command))
+			(void)printf(
+			    "Warning: your account expires on %s",
+			     ctime(&pw->pw_expire));
+	}
+#endif /* !USE_PAM */
+#endif /* __FreeBSD__ */
+
+#ifdef HAVE_LOGIN_CAP
+	/* check if we have a pathname in the ttyname */
+	shorttty = rindex( s->tty, '/' );
+	if (shorttty != NULL ) {
+		/* use only the short filename to check */
+		shorttty ++;
+	} else {
+		/* nothing found, use the whole name found */
+		shorttty = s->tty;
+	}
+	if (!auth_ttyok(lc, shorttty)) {
+		(void)printf("Permission denied.\n");
+		log(
+	       "LOGIN %.200s REFUSED (TTY) FROM %.200s ON TTY %.200s",
+		    pw->pw_name, get_remote_name_or_ip(utmp_len,
+			options.verify_reverse_mapping), s->tty);
+		exit(254);
+	}
+#endif /* HAVE_LOGIN_CAP */
+
 	if (check_quietlogin(s, command))
 		return;
 
-	if (options.print_lastlog && last_login_time != 0) {
+	/*
+	 * If the user has logged in before, display the time of last
+	 * login. However, don't display anything extra if a command
+	 * has been specified (so that ssh can be used to execute
+	 * commands on a remote machine without users knowing they
+	 * are going to another machine). Login(1) will do this for
+	 * us as well, so check if login(1) is used
+	 */
+	if (command == NULL && options.print_lastlog &&
+	    last_login_time != 0 &&
+	    !options.use_login) {
+
 		time_string = ctime(&last_login_time);
 		if (strchr(time_string, '\n'))
 			*strchr(time_string, '\n') = 0;
@@ -629,7 +763,30 @@
 			printf("Last login: %s from %s\r\n", time_string, hostname);
 	}
 
-	do_motd();
+#ifdef HAVE_LOGIN_CAP
+	if (command == NULL &&
+	    !options.use_login) {
+		fname = login_getcapstr(lc, "copyright", NULL, NULL);
+		if (fname != NULL && (f = fopen(fname, "r")) != NULL) {
+			while (fgets(buf, sizeof(buf), f) != NULL)
+				fputs(buf, stdout);
+			fclose(f);
+		} else
+			(void)printf("%s\n\t%s %s\n",
+	"Copyright (c) 1980, 1983, 1986, 1988, 1990, 1991, 1993, 1994",
+	    "The Regents of the University of California. ",
+	    "All rights reserved.");
+	}
+#endif /* HAVE_LOGIN_CAP */
+
+	/*
+	 * Print /etc/motd unless a command was specified or printing
+	 * it was disabled in server options or login(1) will be
+	 * used.  Note that some machines appear to print it in
+	 * /etc/profile or similar.
+	 */
+	if (command == NULL && !options.use_login)
+		do_motd();
 }
 
 /*
@@ -645,9 +802,9 @@
 #ifdef HAVE_LOGIN_CAP
 		f = fopen(login_getcapstr(lc, "welcome", "/etc/motd",
 		    "/etc/motd"), "r");
-#else
+#else /* !HAVE_LOGIN_CAP */
 		f = fopen("/etc/motd", "r");
-#endif
+#endif /* HAVE_LOGIN_CAP */
 		if (f) {
 			while (fgets(buf, sizeof(buf), f))
 				fputs(buf, stdout);
@@ -674,10 +831,10 @@
 #ifdef HAVE_LOGIN_CAP
 	if (login_getcapbool(lc, "hushlogin", 0) || stat(buf, &st) >= 0)
 		return 1;
-#else
+#else /* HAVE_LOGIN_CAP */
 	if (stat(buf, &st) >= 0)
 		return 1;
-#endif
+#endif /* HAVE_LOGIN_CAP */
 	return 0;
 }
 
@@ -775,6 +932,10 @@
 	env[0] = NULL;
 
 	if (!options.use_login) {
+#ifdef HAVE_LOGIN_CAP
+		char *var;
+#endif /* HAVE_LOGIN_CAP */
+
 		/* Set basic environment. */
 		child_set_env(&env, &envsize, "USER", pw->pw_name);
 		child_set_env(&env, &envsize, "LOGNAME", pw->pw_name);
@@ -782,9 +943,15 @@
 #ifdef HAVE_LOGIN_CAP
 		(void) setusercontext(lc, pw, pw->pw_uid, LOGIN_SETPATH);
 		child_set_env(&env, &envsize, "PATH", getenv("PATH"));
-#else
+		var= login_getcapstr(lc, "lang", NULL, NULL);
+		if ( var ) child_set_env(&env, &envsize, "LANG", var);
+		var= login_getcapstr(lc, "charset", NULL, NULL);
+		if ( var ) child_set_env(&env, &envsize, "MM_CHARSET", var);
+		var= login_getcapstr(lc, "timezone", NULL, NULL);
+		if ( var ) child_set_env(&env, &envsize, "TZ", var);
+#else /* !HAVE_LOGIN_CAP */
 		child_set_env(&env, &envsize, "PATH", _PATH_STDPATH);
-#endif
+#endif /* HAVE_LOGIN_CAP */
 
 		snprintf(buf, sizeof buf, "%.200s/%.50s",
 			 _PATH_MAILDIR, pw->pw_name);
@@ -837,6 +1004,11 @@
 		child_set_env(&env, &envsize, "KRB5CCNAME",
 		    s->authctxt->krb5_ticket_file);
 #endif
+#ifdef USE_PAM
+	/* Pull in any environment variables that may have been set by PAM. */
+	do_pam_environment(&env, &envsize);
+#endif /* USE_PAM */
+
 	if (auth_get_socket_name() != NULL)
 		child_set_env(&env, &envsize, SSH_AUTHSOCKET_ENV_NAME,
 		    auth_get_socket_name());
@@ -979,6 +1151,36 @@
 		fatal("Failed to set uids to %u.", (u_int) pw->pw_uid);
 }
 
+#ifdef USE_PAM
+/*
+ * Sets any environment variables which have been specified by PAM
+ */
+void do_pam_environment(char ***env, int *envsize)
+{
+	char *equals, var_name[512], var_val[512];
+	char **pam_env;
+	int i;
+
+	if ((pam_env = fetch_pam_environment()) == NULL)
+		return;
+	
+	for(i = 0; pam_env[i] != NULL; i++) {
+		if ((equals = strstr(pam_env[i], "=")) == NULL)
+			continue;
+			
+		if (strlen(pam_env[i]) < (sizeof(var_name) - 1)) {
+			memset(var_name, '\0', sizeof(var_name));
+			memset(var_val, '\0', sizeof(var_val));
+
+			strncpy(var_name, pam_env[i], equals - pam_env[i]);
+			strcpy(var_val, equals + 1);
+
+			child_set_env(env, envsize, var_name, var_val);
+		}
+	}
+}
+#endif /* USE_PAM */
+
 /*
  * Performs common processing for the child, such as setting up the
  * environment, closing extra file descriptors, setting the user and group
@@ -1057,7 +1259,7 @@
 	 * initgroups, because at least on Solaris 2.3 it leaves file
 	 * descriptors open.
 	 */
-	for (i = 3; i < 64; i++)
+	for (i = 3; i < getdtablesize(); i++)
 		close(i);
 
 	/*
@@ -1087,6 +1289,31 @@
 			exit(1);
 #endif
 	}
+
+#ifdef __FreeBSD__
+  	if (!options.use_login) {
+		/*
+		 * If the password change time is set and has passed, give the
+		 * user a password expiry notice and chance to change it.
+		 */
+		if (pw->pw_change != 0) {
+			struct timeval tv;
+
+			(void)gettimeofday(&tv, NULL);
+			if (tv.tv_sec >= pw->pw_change) {
+				(void)printf(
+				    "Sorry -- your password has expired.\n");
+				syslog(LOG_INFO,
+				    "%s Password expired - forcing change",
+				    pw->pw_name);
+				if (system("/usr/bin/passwd") != 0) {
+					perror("/usr/bin/passwd");
+					exit(1);
+				}
+			}
+		}
+	}
+#endif /* __FreeBSD__ */
 
 	if (!options.use_login)
 		do_rc_files(s, shell);
