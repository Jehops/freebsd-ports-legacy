--- sysdeps/freebsd/jfsusage.c.orig	Sun Apr  9 12:52:45 2006
+++ sysdeps/freebsd/fsusage.c	Mon Apr 10 15:34:42 2006
@@ -9,10 +9,12 @@
 
 #include <unistd.h>
 #include <sys/param.h>
-#if defined (HAVE_SYS_STATVFS_H)
-#include <sys/statvfs.h>
-#else
 #include <sys/mount.h>
+#if __FreeBSD_version >= 600000
+#include <libgeom.h>
+#include <sys/resource.h>
+#include <devstat.h>
+#include <sys/devicestat.h>
 #endif
 
 #include <stdio.h>
@@ -31,24 +33,108 @@ _glibtop_freebsd_get_fsusage_read_write(
 				      const char *path)
 {
 	int result;
-#if defined (STAT_STATVFS)
-	struct statvfs sfs;
-#else
 	struct statfs sfs;
+#if __FreeBSD_version >= 600000
+	struct devstat *ds;
+	void *sc;
+	struct timespec ts;
+	struct gprovider *gp;
+	struct gident *gid;
+	struct gmesh gmp;
+	double etime;
+	uint64_t ld[2];
 #endif
 
-#if defined (STAT_STATVFS)
-	result = statvfs (path, &sfs);
-#else
 	result = statfs (path, &sfs);
-#endif
 
 	if (result == -1) {
+		glibtop_warn_io_r (server, "statfs");
+		return;
+	}
+#if __FreeBSD_version >= 600000
+	ld[0] = 0;
+	ld[1] = 0;
+	result = geom_gettree (&gmp);
+	if (result != 0) {
+		glibtop_warn_io_r (server, "geom_gettree = %d", result);
+		return;
+	}
+
+	result = geom_stats_open ();
+	if (result) {
+		glibtop_warn_io_r (server, "geom_stats_open()");
+		geom_deletetree (&gmp);
+		return;
+	}
+
+	sc = geom_stats_snapshot_get ();
+	if (sc == NULL) {
+		glibtop_warn_io_r (server, "geom_stats_snapshot_get()");
+		geom_stats_close ();
+		geom_deletetree (&gmp);
 		return;
 	}
 
+	geom_stats_snapshot_timestamp (sc, &ts);
+	etime = ts.tv_sec + (ts.tv_nsec * 1e-9);
+	geom_stats_snapshot_reset (sc);
+
+	for (;;) {
+		ds = geom_stats_snapshot_next (sc);
+		if (ds == NULL) {
+			break;
+		}
+		if (ds->id == NULL) {
+			continue;
+		}
+
+		gid = geom_lookupid (&gmp, ds->id);
+		if (gid == NULL) {
+			geom_deletetree (&gmp);
+			result = geom_gettree (&gmp);
+			gid = geom_lookupid (&gmp, ds->id);
+		}
+
+		if (gid == NULL) {
+			continue;
+		}
+		if (gid->lg_what == ISCONSUMER) {
+			continue;
+		}
+
+		gp = gid->lg_ptr;
+
+		if (!g_str_has_suffix (sfs.f_mntfromname, gp->lg_name)) {
+			continue;
+		}
+		else {
+			result = devstat_compute_statistics (ds, NULL, etime,
+					DSM_TOTAL_TRANSFERS_READ,
+					&ld[0],
+					DSM_TOTAL_TRANSFERS_WRITE,
+					&ld[1], DSM_NONE);
+			if (result != 0) {
+				glibtop_warn_io_r (server,
+						"devstat_compute_statistics()");
+				geom_stats_snapshot_free (sc);
+				geom_stats_close ();
+				geom_deletetree (&gmp);
+				return;
+			}
+			break;
+		}
+	}
+ 
+	geom_stats_snapshot_free (sc);
+	geom_stats_close ();
+	geom_deletetree (&gmp);
+
+	buf->read = ld[0];
+	buf->write = ld[1];
+#else
 	buf->read = sfs.f_syncreads + sfs.f_asyncreads;
 	buf->write = sfs.f_syncwrites + sfs.f_asyncwrites;
+#endif
 
 	buf->flags |= (1 << GLIBTOP_FSUSAGE_READ) | (1 << GLIBTOP_FSUSAGE_WRITE);
 }
