#
# Fix sorting bug when --relative is used
#  <http://lists.samba.org/archive/rsync-announce/2004/000015.html>
#
--- flist.c	27 Apr 2004 01:36:10 -0000	1.217
+++ flist.c	29 Apr 2004 19:37:15 -0000	1.218
@@ -1517,11 +1517,17 @@ int f_name_cmp(struct file_struct *f1, s
 	if (!(c1 = (uchar*)f1->dirname)) {
 		state1 = fnc_BASE;
 		c1 = (uchar*)f1->basename;
+	} else if (!*c1) {
+		state1 = fnc_SLASH;
+		c1 = (uchar*)"/";
 	} else
 		state1 = fnc_DIR;
 	if (!(c2 = (uchar*)f2->dirname)) {
 		state2 = fnc_BASE;
 		c2 = (uchar*)f2->basename;
+	} else if (!*c2) {
+		state2 = fnc_SLASH;
+		c2 = (uchar*)"/";
 	} else
 		state2 = fnc_DIR;
 
