--- pear/scripts/pearcmd.php.orig	Fri May 16 17:31:37 2003
+++ pear/scripts/pearcmd.php	Fri May 16 17:36:10 2003
@@ -1,3 +1,4 @@
+#!%%PREFIX%%/bin/php -n -dsafe_mode=0 -doutput_buffering=1
 <?php
 //
 // +----------------------------------------------------------------------+
@@ -24,9 +25,7 @@
 /**
  * @nodep Gtk
  */
-if ('@include_path@' != '@'.'include_path'.'@') {
-    ini_set('include_path', '@include_path@');
-}
+ini_set('include_path', '%%PREFIX%%/share/pear:%%PREFIX%%/share/pear/bootstrap');
 ini_set('allow_url_fopen', true);
 set_time_limit(0);
 ob_implicit_flush(true);
