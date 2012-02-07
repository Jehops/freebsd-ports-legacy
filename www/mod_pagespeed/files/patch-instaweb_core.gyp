--- net/instaweb/instaweb_core.gyp.orig	2012-02-06 13:07:36.864338902 -0500
+++ net/instaweb/instaweb_core.gyp	2012-02-06 13:08:32.614375339 -0500
@@ -170,54 +170,4 @@
       ],
     },
   ],
-  'conditions': [
-    ['OS=="linux"', {
-      'targets': [
-        # We build this target to make sure that we don't accidentially
-        # introduce dependencies from the core libraries to non-core
-        # libraries.
-        {
-          'target_name': 'html_minifier_main_dependency_check',
-          'type': 'none',
-          'dependencies': [
-            'html_minifier_main',
-          ],
-          'actions': [
-            {
-              'action_name': 'html_minifier_main_dependency_check',
-              'inputs': [
-                '<(PRODUCT_DIR)/html_minifier_main',
-              ],
-              'outputs': [
-                '<(PRODUCT_DIR)/html_minifier_main_dependency_check',
-              ],
-              'action': [
-                'g++',
-                '-pthread',
-                '-o', '<@(_outputs)',
-                '<(LIB_DIR)/html_minifier_main/net/instaweb/rewriter/html_minifier_main.o',
-
-                # Only the following dependencies are allowed. If you
-                # find yourself needing to add additional dependencies,
-                # please check with bmcquade first.
-                '<(LIB_DIR)/net/instaweb/libinstaweb_rewriter_html.a',
-                '<(LIB_DIR)/net/instaweb/libinstaweb_htmlparse_core.a',
-                '<(LIB_DIR)/net/instaweb/libhttp_core.a',
-                '<(LIB_DIR)/net/instaweb/libinstaweb_util_core.a',
-                '<(LIB_DIR)/net/instaweb/libinstaweb_htmlparse_core_gperf.a',
-                '<(LIB_DIR)/build/temp_gyp/libgoogleurl.a',
-                '<(LIB_DIR)/base/libbase.a',
-                '<(LIB_DIR)/base/libbase_static.a',
-                '<(LIB_DIR)/third_party/chromium/src/base/third_party/dynamic_annotations/libdynamic_annotations.a',
-                '<(LIB_DIR)/third_party/modp_b64/libmodp_b64.a',
-                '<(LIB_DIR)/third_party/icu/libicuuc.a',
-                '<(LIB_DIR)/third_party/icu/libicudata.a',
-                '-lrt',
-              ],
-            },
-          ],
-        },
-      ],
-    }],
-  ],
 }
