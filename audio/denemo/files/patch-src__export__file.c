--- src/export/file.c.orig
+++ src/export/file.c
@@ -595,7 +595,7 @@
     {
       if (system_example_path == NULL)
         {
-          system_example_path = g_build_filename (get_system_data_dir (), "examples", NULL);
+          system_example_path = g_build_filename (get_system_data_dir (), "..", "examples", "denemo", NULL);
           GDir *denemo_path = g_dir_open (system_example_path, 0, NULL);
           if (denemo_path == NULL)
             {
