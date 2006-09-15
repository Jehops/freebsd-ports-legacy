--- linux/sys_linux.c.orig	Fri Sep 15 15:50:28 2006
+++ linux/sys_linux.c	Fri Sep 15 15:51:43 2006
@@ -230,7 +230,7 @@
 
 	size = backtrace (array, sizeof(array)/sizeof(void*));
 
-#ifndef __x86_64__
+#if !defined(__x86_64__) && !defined(__FreeBSD__)
 	array[1] = (void *) uc->uc_mcontext.gregs[REG_EIP];
 #endif
 	
@@ -309,7 +309,9 @@
 
 void Sys_DebugBreak (void)
 {
+#ifdef __i386__
 	__asm ("int $3");
+#endif
 }
 
 void Sys_Warn (char *warning, ...)
@@ -414,29 +416,17 @@
 	void	*(*GetGameAPI) (void *);
 
 	char	name[MAX_OSPATH];
-	char	curpath[MAX_OSPATH];
 	char	*path;
-#ifdef __i386__
-	const char *gamename = "gamei386.so";
-#elif defined __alpha__
-	const char *gamename = "gameaxp.so";
-#elif defined __x86_64__
-	const char *gamename = "gamex86_64.so";
-#else
-#error "Don't know what kind of dynamic objects to use for this architecture."
-#endif
+	const char *gamename = "game.so";
 
 	if (game_library)
 		Com_Error (ERR_FATAL, "Sys_GetGameAPI without Sys_UnloadingGame");
 
-	getcwd(curpath, sizeof(curpath)-1);
-	curpath[sizeof(curpath)-1] = 0;
-
 	Com_Printf("------- Loading %s -------\n", LOG_SERVER|LOG_NOTICE, gamename);
 
 	if (baseq2)
 	{
-		Com_sprintf (name, sizeof(name), "%s/%s/%s", curpath, BASEDIRNAME, gamename);
+		Com_sprintf (name, sizeof(name), "%s/%s", BASEDIRNAME, gamename);
 		game_library = dlopen (name, RTLD_NOW );
 	}
 	else
@@ -448,7 +438,7 @@
 			path = FS_NextPath (path);
 			if (!path)
 				return NULL;		// couldn't find one anywhere
-			Com_sprintf (name, sizeof(name), "%s/%s/%s", curpath, path, gamename);
+			Com_sprintf (name, sizeof(name), "%s/%s", path, gamename);
 			game_library = dlopen (name, RTLD_NOW );
 			if (game_library)
 			{
