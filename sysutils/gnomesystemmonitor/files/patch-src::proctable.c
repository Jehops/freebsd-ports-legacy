--- src/proctable.c.orig	Mon Jul 19 10:02:09 2004
+++ src/proctable.c	Mon Jul 19 10:08:18 2004
@@ -563,6 +563,9 @@
 	glibtop_get_proc_uid (&procuid, pid);
 	glibtop_get_proc_time (&proctime, pid);
 	newcputime = proctime.utime + proctime.stime;
+	if (proctime.frequency) {
+		newcputime /= (proctime.frequency/100);
+	}
 	model = gtk_tree_view_get_model (GTK_TREE_VIEW (procdata->tree));
 
         wnck_pid_read_resource_usage (gdk_screen_get_display (gdk_screen_get_default ()),
@@ -667,6 +670,10 @@
 	glibtop_get_proc_uid (&procuid, pid);
 	glibtop_get_proc_time (&proctime, pid);
 	newcputime = proctime.utime + proctime.stime;
+	if (proctime.frequency) {
+		newcputime /= (proctime.frequency/100);
+	}
+
 
         wnck_pid_read_resource_usage (gdk_screen_get_display (gdk_screen_get_default ()),
                                       pid,
@@ -761,6 +768,12 @@
 	return FALSE;
 }
 
+static int
+pid_compare(const void* first, const void* second)
+{
+	return *(unsigned*)first - *(unsigned*)second;
+}
+
 static void
 refresh_list (ProcData *data, unsigned *pid_list, gint n)
 {
@@ -769,6 +782,8 @@
 	GtkTreeModel *model = gtk_tree_view_get_model (GTK_TREE_VIEW (procdata->tree));
 	gint i = 0;
 	
+	qsort(pid_list, n, sizeof (*pid_list), pid_compare);
+
 	/* Add or update processes */
 	while (i < n) {
 		ProcInfo *info;
@@ -862,6 +877,9 @@
 	** should probably have a total_time_last gint in the ProcInfo structure */
 	glibtop_get_cpu (&cpu);
 	total_time = cpu.total - total_time_last;
+	if (cpu.frequency) {
+		total_time /= (cpu.frequency/100);
+	}
 	total_time_last = cpu.total;
 	
 	refresh_list (procdata, pid_list, n);
