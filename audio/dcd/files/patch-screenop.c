--- screenop.c.orig	2003-08-28 01:42:36.000000000 +0200
+++ screenop.c	2008-06-20 23:06:36.000000000 +0200
@@ -15,23 +15,27 @@
 
 void disk_directory(void) {
   u_char ct = cd_current_track();
+  char *art_name, *trk_name;
   int tl;
-  char outline[80];
   int disc_length = cd_disc_length();
   int i;
   #ifdef DEBUG
     fprintf (stderr, "Entering directory. tz is %i\n", cd_last_track());
   #endif
 
-  sprintf (outline, "Track  Time  (%i tracks / %2i:%02i) %30s",
-          cd_last_track(), disc_length/60, disc_length%60, mbo_trackname(0));
-  printf ("%s\n", outline);
+  art_name = mbo_artistname();
+  trk_name = mbo_trackname(0);
+  printf ("Artist: %s\nAlbum : %s\nTrack  Time  (%i tracks / %2i:%02i)\n",
+          art_name, trk_name, cd_last_track(), disc_length/60, disc_length%60);
+  free(art_name);
+  free(trk_name);
   
   for (i=1; i<=cd_last_track(); i++) {
     tl = cd_track_length(i);
-    sprintf (outline, "%s %2i  %2i:%02i  %-45s", (i==ct ? "*" : " "),
-            i, (tl/60), (tl%60), mbo_trackname(i));
-    printf ("%s\n", outline);
+    trk_name = mbo_trackname(i);
+    printf ("%s %2i  %2i:%02i  %-45s\n", (i==ct ? "*" : " "),
+            i, (tl/60), (tl%60), trk_name);
+    free(trk_name);
   } /* for */
 }
 
