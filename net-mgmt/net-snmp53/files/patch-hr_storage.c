--- agent/mibgroup/host/hr_storage.c.orig	Tue Feb 25 22:17:46 2003
+++ agent/mibgroup/host/hr_storage.c	Fri Nov 14 13:03:07 2003
@@ -148,7 +148,7 @@
 #define HRFS_mount	mnt_mountp
 #define HRFS_statfs	statvfs
 
-#elif defined(HAVE_STATVFS)
+#elif defined(HAVE_STATVFS) && defined(HAVE_MNTENT)
 
 extern struct mntent *HRFS_entry;
 extern int      fscount;
@@ -564,7 +564,7 @@
         }
     case HRSTORE_UNITS:
         if (store_idx > HRS_TYPE_FIXED_MAX)
-#if STRUCT_STATVFS_HAS_F_FRSIZE
+#if defined(STRUCT_STATVFS_HAS_F_FRSIZE) && defined(HAVE_MNTENT)
             long_return = stat_buf.f_frsize;
 #else
             long_return = stat_buf.f_bsize;
@@ -647,7 +647,15 @@
                      i++)
                     long_return += mbstat.m_mtypes[i];
 #elif defined(MBSTAT_SYMBOL)
+#if !defined(__FreeBSD__) || __FreeBSD_version < 500021
                 long_return = mbstat.m_mbufs;
+#elif defined(freebsd5) && __FreeBSD_version < 500024
+			/* mbuf stats disabled */
+			return NULL;
+#else
+			/* XXX TODO: implement new method */
+			return NULL;
+#endif
 #elif defined(NO_DUMMY_VALUES)
                 return NULL;
 #else
@@ -705,7 +713,15 @@
                     * mbpool.pr_size + (mclpool.pr_nget - mclpool.pr_nput)
                     * mclpool.pr_size;
 #elif defined(MBSTAT_SYMBOL)
+#if !defined(__FreeBSD__) || __FreeBSD_version < 500021
                 long_return = mbstat.m_clusters - mbstat.m_clfree;      /* unlikely, but... */
+#elif defined(freebsd5) && __FreeBSD_version < 500024
+			/* mbuf stats disabled */
+			return NULL;
+#else
+			/* XXX TODO: implement new method */
+			return NULL;
+#endif
 #elif defined(NO_DUMMY_VALUES)
                 return NULL;
 #else
