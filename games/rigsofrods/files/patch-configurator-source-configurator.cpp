--- configurator/source/configurator.cpp.orig	2009-02-22 20:59:55.000000000 +0300
+++ configurator/source/configurator.cpp	2009-04-09 07:25:25.000000000 +0400
@@ -1109,17 +1109,12 @@
 	char procpath[256];
 	char user_path[1024];
 	char program_path[1024];
-	sprintf(procpath, "/proc/%d/exe", pid);
-	int ch = readlink(procpath,program_path,240);
-	if (ch != -1)
-	{
-		program_path[ch] = 0;
-	} else return false;
+	strcpy(program_path, "%%DATADIR%%/");
 	ProgramPath=wxFileName(wxString(conv(program_path))).GetPath();
 	//user path is easy
 	strncpy(user_path, getenv ("HOME"), 240);
 	wxFileName tfn=wxFileName(conv(user_path), wxEmptyString);
-	tfn.AppendDir(_T("RigsOfRods"));
+	tfn.AppendDir(_T(".RigsOfRods"));
 	UserPath=tfn.GetPath();
 #endif
 #if OGRE_PLATFORM == OGRE_PLATFORM_APPLE
@@ -2692,7 +2687,7 @@
 	CreateProcess(NULL, wpath, NULL, NULL, false, NORMAL_PRIORITY_CLASS, NULL, NULL, &si, &pi);
 #endif
 #if OGRE_PLATFORM == OGRE_PLATFORM_LINUX
-	execl("./RoR.bin", "", (char *) 0);
+	execl("%%PREFIX%%/bin/RoR", "", (char *) 0);
 #endif
 #if OGRE_PLATFORM == OGRE_PLATFORM_APPLE
 	FSRef ref;
