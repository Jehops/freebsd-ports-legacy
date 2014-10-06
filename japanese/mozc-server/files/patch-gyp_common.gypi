--- gyp/common.gypi.orig	2014-08-31 03:36:19.000000000 +0900
+++ gyp/common.gypi	2014-09-17 04:33:49.000000000 +0900
@@ -171,9 +171,9 @@
       ['target_platform=="Linux"', {
         # enable_gtk_renderer represents if mozc_renderer is supported on Linux
         # or not.
-        'compiler_target': 'gcc',
+        'compiler_target': '<(compiler_target)',
         'compiler_target_version_int': 406,  # GCC 4.6 or higher
-        'compiler_host': 'gcc',
+        'compiler_host': '<(compiler_host)',
         'compiler_host_version_int': 406,  # GCC 4.6 or higher
         'enable_gtk_renderer%': 1,
       }, {  # else
@@ -631,17 +631,20 @@
           ['compiler_target=="clang"', {
             'cflags': [
               '-Wtype-limits',
+	      '<@(cflags)',
             ],
             'cflags_cc': [
               '-Wno-covered-switch-default',
               '-Wno-unnamed-type-template-args',
               '-Wno-c++11-narrowing',
-              '-std=gnu++0x',
+              '-std=c++11',
+	      '<@(cflags_cc)',
             ],
           }],
-          ['compiler_target=="clang" or compiler_target=="gcc"', {
+          ['compiler_host=="gcc"', {
             'cflags_cc': [
-              '-std=gnu++0x',
+              '-std=gnu++11',
+	      '<@(cflags_cc)',
             ],
           }],
         ],
@@ -651,17 +654,20 @@
           ['compiler_host=="clang"', {
             'cflags': [
               '-Wtype-limits',
+	      '<@(cflags)',
             ],
             'cflags_cc': [
               '-Wno-covered-switch-default',
               '-Wno-unnamed-type-template-args',
               '-Wno-c++11-narrowing',
-              '-std=gnu++0x',
+              '-std=c++11',
+	      '<@(cflags_cc)',
             ],
           }],
-          ['compiler_host=="clang" or compiler_host=="gcc"', {
+          ['compiler_host=="gcc"', {
             'cflags_cc': [
-              '-std=gnu++0x',
+              '-std=gnu++11',
+	      '<@(cflags_cc)',
             ],
           }],
         ],
@@ -759,16 +765,27 @@
       ['OS=="linux"', {
         'defines': [
           'OS_LINUX',
+          'OS_FREEBSD',
+          'LOCALBASE="<@(localbase)"',
         ],
         'cflags': [
           '<@(warning_cflags)',
           '-fPIC',
           '-fno-exceptions',
+	  '<@(cflags)',
         ],
         'cflags_cc': [
           # We use deprecated <hash_map> and <hash_set> instead of upcoming
           # <unordered_map> and <unordered_set>.
           '-Wno-deprecated',
+	  '<@(cflags_cc)',
+        ],
+        'include_dirs': [
+          '<@(include_dirs)'
+        ],
+        'ldflags': [
+          '<@(ldflags)',
+	  '-fstack-protector',
         ],
         'conditions': [
           ['target_platform!="NaCl"', {
