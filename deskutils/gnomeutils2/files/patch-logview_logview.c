--- logview/logview.c.orig	Sun Feb 16 15:34:59 2003
+++ logview/logview.c	Wed Apr 23 14:51:26 2003
@@ -774,7 +774,7 @@
 
 	if ( ! found) {
 		g_snprintf (full_name, sizeof (full_name),
-			    "%s/share/gnome-system-log/gnome-system-log-regexp.db", LOGVIEWINSTALLPREFIX);
+			    "%s/gnome-system-log/gnome-system-log-regexp.db", DATADIR);
 		if (access (full_name, R_OK) == 0) {
 			found = TRUE;
 			g_free (cfg->regexp_db_path);
@@ -797,7 +797,7 @@
 
 	if ( ! found) {
 		g_snprintf (full_name, sizeof (full_name),
-			    "%s/share/gnome-system-log/gnome-system-log-descript.db", LOGVIEWINSTALLPREFIX);
+			    "%s/gnome-system-log/gnome-system-log-descript.db", DATADIR);
 		if (access (full_name, R_OK) == 0) {
 			found = TRUE;
 			g_free (cfg->descript_db_path);
@@ -831,7 +831,7 @@
 
 	if ( ! found) {
 		g_snprintf (full_name, sizeof (full_name),
-			    "%s/share/gnome-system-log/gnome-system-log-actions.db", LOGVIEWINSTALLPREFIX);
+			    "%s/gnome-system-log/gnome-system-log-actions.db", DATADIR);
 		if (access (full_name, R_OK) == 0) {
 			found = TRUE;
 			g_free (cfg->action_db_path);
@@ -882,7 +882,6 @@
 		else
 			prefs->logfile = NULL;
 	}
-	g_free (logfile);	
 }
 
 void SaveUserPrefs(UserPrefsStruct *prefs)
