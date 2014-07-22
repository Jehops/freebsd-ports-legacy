--- ./cribbage/instr.c
+++ ./cribbage/instr.c
@@ -51,7 +51,11 @@ void
 instructions(void)
 {
 	struct stat sb;
+#ifdef __DragonFly__
 	union wait pstat;
+#else
+	int pstat;
+#endif
 	pid_t pid;
 	const char *pager, *path;
 
@@ -77,7 +81,11 @@ instructions(void)
 		do {
 			pid = waitpid(pid, (int *)&pstat, 0);
 		} while (pid == -1 && errno == EINTR);
+#ifdef __DragonFly__
 		if (pid == -1 || pstat.w_status)
+#else
+		if (pid == -1 || WEXITSTATUS(pstat) || WTERMSIG(pstat))
+#endif
 			exit(1);
 	}
 }
