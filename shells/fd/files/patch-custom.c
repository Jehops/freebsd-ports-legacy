[FDclone-users:00986]
--- custom.c.orig	2012-06-30 00:00:00.000000000 +0900
+++ custom.c	2012-07-16 19:12:29.374464026 +0900
@@ -4004,11 +4004,10 @@
 	char *new;
 	int i, j, n;
 
-	if (origflaglist) new = NULL;
+	if (origflaglist || origmaxfdtype <= 0) new = NULL;
 	else {
-		for (n = 0; n < origmaxfdtype; n++) /*EMPTY*/;
-		origflaglist = new = Xmalloc(n * sizeof(char));
-		memset(origflaglist, 0, n * sizeof(char));
+		origflaglist = new = Xmalloc(origmaxfdtype * sizeof(char));
+		memset(origflaglist, 0, origmaxfdtype * sizeof(char));
 	}
 
 	for (i = n = 0; i < maxfdtype; i++) {
