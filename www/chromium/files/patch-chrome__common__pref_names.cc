--- ./chrome/common/pref_names.cc.orig	2014-08-20 21:01:56.000000000 +0200
+++ ./chrome/common/pref_names.cc	2014-08-22 15:06:25.000000000 +0200
@@ -957,7 +957,7 @@
 // Boolean controlling whether SafeSearch is mandatory for Google Web Searches.
 const char kForceSafeSearch[] = "settings.force_safesearch";
 
-#if defined(OS_LINUX) && !defined(OS_CHROMEOS)
+#if (defined(OS_LINUX) && !defined(OS_CHROMEOS)) || defined(OS_BSD)
 // Linux specific preference on whether we should match the system theme.
 const char kUsesSystemTheme[] = "extensions.theme.use_system";
 #endif
