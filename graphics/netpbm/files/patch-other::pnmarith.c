--- other/pnmarith.c.orig	Sun Aug 13 13:08:04 1995
+++ other/pnmarith.c	Tue Jun 18 00:00:00 2002
@@ -147,9 +147,9 @@
 		    break;
 
 		    case '*':
-		    r1 = r1 * r2 / maxval3;
-		    g1 = g1 * g2 / maxval3;
-		    b1 = b1 * b2 / maxval3;
+		    r1 = (unsigned) r1 * r2 / maxval3;
+		    g1 = (unsigned) g1 * g2 / maxval3;
+		    b1 = (unsigned) b1 * b2 / maxval3;
 		    break;
 
 		    case 'D':
