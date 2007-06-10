--- w_fontpanel.c.orig	Fri Feb 24 12:23:06 2006
+++ w_fontpanel.c
@@ -183,7 +183,7 @@
     ps_cancel = XtCreateManagedWidget("cancel", commandWidgetClass,
 				    ps_form, Args, ArgCount);
     XtAddEventHandler(ps_cancel, ButtonReleaseMask, False,
-		      fontpane_cancel, (XtPointer) NULL);
+		      (XtEventHandler)fontpane_cancel, (XtPointer) NULL);
 
     /* button to switch to the LaTeX fonts */
     FirstArg(XtNlabel, " Use LaTex Fonts ");
@@ -197,7 +197,7 @@
     tmp_but = XtCreateManagedWidget("use_latex_fonts", commandWidgetClass,
 				    ps_form, Args, ArgCount);
     XtAddEventHandler(tmp_but, ButtonReleaseMask, False,
-		      fontpane_swap, (XtPointer) NULL);
+		      (XtEventHandler)fontpane_swap, (XtPointer) NULL);
 
     /* now make the LaTeX font image buttons */
     FirstArg(XtNwidth, LATEX_FONTPANE_WD);
@@ -227,7 +227,7 @@
     latex_cancel = XtCreateManagedWidget("cancel", commandWidgetClass,
 				    latex_form, Args, ArgCount);
     XtAddEventHandler(latex_cancel, ButtonReleaseMask, False,
-		      fontpane_cancel, (XtPointer) NULL);
+		      (XtEventHandler)fontpane_cancel, (XtPointer) NULL);
 
     /* button to switch to the PostScript fonts */
     FirstArg(XtNlabel, " Use PostScript Fonts ");
@@ -241,7 +241,7 @@
     tmp_but = XtCreateManagedWidget("use_postscript_fonts", commandWidgetClass,
 				    latex_form, Args, ArgCount);
     XtAddEventHandler(tmp_but, ButtonReleaseMask, False,
-		      fontpane_swap, (XtPointer) NULL);
+		      (XtEventHandler)fontpane_swap, (XtPointer) NULL);
 
     XtInstallAccelerators(ps_form, ps_cancel);
     XtInstallAccelerators(latex_form, latex_cancel);
