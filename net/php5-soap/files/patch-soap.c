--- soap.c.orig	Tue Jan 24 08:02:15 2006
+++ soap.c	Tue Jan 24 08:03:06 2006
@@ -23,7 +23,7 @@
 #include "config.h"
 #endif
 #include "php_soap.h"
-#if HAVE_PHP_SESSION && !defined(COMPILE_DL_SESSION)
+#if HAVE_PHP_SESSION
 #include "ext/session/php_session.h"
 #endif
 #ifdef ZEND_ENGINE_2
@@ -1509,7 +1509,7 @@
 
 	if (service->type == SOAP_CLASS) {
 		soap_obj = NULL;
-#if HAVE_PHP_SESSION && !defined(COMPILE_DL_SESSION)
+#if HAVE_PHP_SESSION
 		/* If persistent then set soap_obj from from the previous created session (if available) */
 		if (service->soap_class.persistance == SOAP_PERSISTENCE_SESSION) {
 			zval **tmp_soap;
@@ -1598,7 +1598,7 @@
 				}
 				efree(class_name);
 			}
-#if HAVE_PHP_SESSION && !defined(COMPILE_DL_SESSION)
+#if HAVE_PHP_SESSION
 			/* If session then update session hash with new object */
 			if (service->soap_class.persistance == SOAP_PERSISTENCE_SESSION) {
 				zval **tmp_soap_pp;
@@ -1691,7 +1691,7 @@
 	     zend_hash_exists(function_table, ZEND_CALL_FUNC_NAME, sizeof(ZEND_CALL_FUNC_NAME)))) {
 		if (service->type == SOAP_CLASS) {
 			call_status = call_user_function(NULL, &soap_obj, &function_name, &retval, num_params, params TSRMLS_CC);
-#if HAVE_PHP_SESSION && !defined(COMPILE_DL_SESSION)
+#if HAVE_PHP_SESSION
 			if (service->soap_class.persistance != SOAP_PERSISTENCE_SESSION) {
 				zval_ptr_dtor(&soap_obj);
 			}
