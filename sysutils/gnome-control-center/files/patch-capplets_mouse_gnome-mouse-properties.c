--- capplets/mouse/gnome-mouse-properties.c.orig	Sat Nov  2 13:40:22 2002
+++ capplets/mouse/gnome-mouse-properties.c	Sun Dec 22 16:33:36 2002
@@ -591,7 +591,7 @@
 	filename = gnome_program_locate_file (program, GNOME_FILE_DOMAIN_APP_PIXMAP, "mouse-cursor-white.png", TRUE, NULL);
 	pixbuf = gdk_pixbuf_new_from_file (filename, NULL);
 	g_free (filename);
-	font_path = gnome_program_locate_file (program, GNOME_FILE_DOMAIN_DATADIR, "gnome/cursor-fonts/cursor-white.pcf", FALSE, NULL);
+	font_path = gnome_program_locate_file (program, GNOME_FILE_DOMAIN_DATADIR, "cursor-fonts/cursor-white.pcf", FALSE, NULL);
 
 	gtk_list_store_append (GTK_LIST_STORE (model), &iter);
 	if (cursor_font && ! strcmp (cursor_font, font_path)) {
@@ -612,7 +612,7 @@
 	filename = gnome_program_locate_file (program, GNOME_FILE_DOMAIN_APP_PIXMAP, "mouse-cursor-normal-large.png", TRUE, NULL);
 	pixbuf = gdk_pixbuf_new_from_file (filename, NULL);
 	g_free (filename);
-	font_path = gnome_program_locate_file (program, GNOME_FILE_DOMAIN_DATADIR, "gnome/cursor-fonts/cursor-large.pcf", FALSE, NULL);
+	font_path = gnome_program_locate_file (program, GNOME_FILE_DOMAIN_DATADIR, "cursor-fonts/cursor-large.pcf", FALSE, NULL);
 
 	gtk_list_store_append (GTK_LIST_STORE (model), &iter);
 	if (cursor_font && ! strcmp (cursor_font, font_path)) {
@@ -633,7 +633,7 @@
 	filename = gnome_program_locate_file (program, GNOME_FILE_DOMAIN_APP_PIXMAP, "mouse-cursor-white-large.png", TRUE, NULL);
 	pixbuf = gdk_pixbuf_new_from_file (filename, NULL);
 	g_free (filename);
-	font_path = gnome_program_locate_file (program, GNOME_FILE_DOMAIN_DATADIR, "gnome/cursor-fonts/cursor-large-white.pcf", FALSE, NULL);
+	font_path = gnome_program_locate_file (program, GNOME_FILE_DOMAIN_DATADIR, "cursor-fonts/cursor-large-white.pcf", FALSE, NULL);
 
 	gtk_list_store_append (GTK_LIST_STORE (model), &iter);
 	if (cursor_font && ! strcmp (cursor_font, font_path)) {
