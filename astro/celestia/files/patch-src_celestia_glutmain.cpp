$FreeBSD$

--- src/celestia/glutmain.cpp.orig	Tue Apr 30 10:36:11 2002
+++ src/celestia/glutmain.cpp	Fri May 17 17:47:50 2002
@@ -509,7 +509,7 @@ int main(int argc, char* argv[])
     // Set the simulation starting time to the current system time
     time_t curtime=time(NULL);
     appCore->start((double) curtime / 86400.0 + (double) astro::Date(1970, 1, 1));
-    #ifdef MACOSX
+    #if 1
     /* localtime in Darwin is is reentrant only
        equiv to Linux localtime_r()
        should probably port !MACOSX code to use this too, available since
