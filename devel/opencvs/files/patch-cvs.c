--- cvs.c	21 Jun 2008 15:39:15 -0000	1.150
+++ cvs.c	17 Oct 2008 08:51:45 -0000
@@ -70,7 +70,7 @@
 struct cvs_cmd *cmdp;			/* struct of command we are running */
 
 int		cvs_getopt(int, char **);
-__dead void	usage(void);
+void	usage(void);
 static void	cvs_read_rcfile(void);
 
 struct cvs_wklhead temp_files;
@@ -122,7 +122,7 @@
 		cvs_ent_close(current_list, ENT_SYNC);
 }
 
-__dead void
+void
 usage(void)
 {
 	(void)fprintf(stderr,

