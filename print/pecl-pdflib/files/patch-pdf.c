--- pdf.c	2010/04/28 12:17:58	298698
+++ pdf.c	2012/01/28 03:05:18	322900
@@ -766,10 +766,14 @@
 
     ALLOC_HASHTABLE(intern->std.properties);
     zend_hash_init(intern->std.properties, 0, NULL, ZVAL_PTR_DTOR, 0);
+#if PHP_VERSION_ID < 50399
     zend_hash_copy(intern->std.properties,
             &class_type->default_properties,
             (copy_ctor_func_t) zval_add_ref,
             (void *) &tmp, sizeof(zval *));
+#else
+    object_properties_init( (zend_object*)intern, class_type );
+#endif
 
     retval.handle = zend_objects_store_put(intern,  NULL,
             (zend_objects_free_object_storage_t)pdflib_object_dtor,
