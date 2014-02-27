--- src/grdvector.c.orig
+++ src/grdvector.c
@@ -388,15 +388,7 @@
         if (!Ctrl->N.active) GMT_map_clip_on (GMT_no_rgb, 3);
 
 	if (Ctrl->I.xinc != 0.0 && Ctrl->I.yinc != 0.0) {	/* Gave a coarser grid spacing, we hope */
-		struct GRD_HEADER tmp_h;
-		double val;
-		tmp_h = h[0];
-		tmp_h.x_inc = Ctrl->I.xinc;
-		tmp_h.y_inc = Ctrl->I.yinc;
-		GMT_RI_prepare (&tmp_h);	/* Convert to make sure we have correct increments */
-		Ctrl->I.xinc = tmp_h.x_inc;
-		Ctrl->I.yinc = tmp_h.y_inc;
-		val = Ctrl->I.yinc / h[0].y_inc;
+		double val = Ctrl->I.yinc / h[0].y_inc;
 		dj = irint (val);
 		if (dj == 0 || fabs (val - dj) > GMT_CONV_LIMIT) {
 			fprintf (stderr, "%s: Error: New y grid increment (%g) is not a multiple of actual grid increment (%g).\n", GMT_program, Ctrl->I.xinc, h[0].x_inc);
@@ -408,6 +400,7 @@
 			fprintf (stderr, "%s: Error: New x grid increment (%g) is not a multiple of actual grid increment (%g).\n", GMT_program, Ctrl->I.xinc, h[0].x_inc);
 			exit (EXIT_FAILURE);
 		}
+		/* Determine starting point for straddled access */
 		tmp = ceil (h[0].y_max / Ctrl->I.yinc) * Ctrl->I.yinc;
 		if (tmp > h[0].y_max) tmp -= Ctrl->I.yinc;
 		j0 = irint ((h[0].y_max - tmp) / h[0].y_inc);
