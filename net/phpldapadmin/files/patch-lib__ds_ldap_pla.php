--- ./lib/ds_ldap_pla.php.orig	2012-10-01 07:54:14.000000000 +0100
+++ ./lib/ds_ldap_pla.php	2014-04-27 09:42:04.099743918 +0100
@@ -16,7 +16,7 @@
 	function __construct($index) {
 		parent::__construct($index);
 
-		$this->default->appearance['password_hash'] = array(
+		$this->default->appearance['password_hash_custom'] = array(
 			'desc'=>'Default HASH to use for passwords',
 			'default'=>'md5');
 
