--- unix/fcitx/fcitx.gyp.orig	1970-01-01 09:00:00.000000000 +0900
+++ unix/fcitx/fcitx.gyp	2012-05-22 13:42:56.598827812 +0900
@@ -0,0 +1,107 @@
+#
+# Copyright (c) 2010-2012 fcitx Project http://code.google.com/p/fcitx/
+#
+# All rights reserved.
+#
+# Redistribution and use in source and binary forms, with or without
+# modification, are permitted provided that the following conditions
+# are met:
+# 1. Redistributions of source code must retain the above copyright
+#    notice, this list of conditions and the following disclaimer.
+# 2. Redistributions in binary form must reproduce the above copyright
+#    notice, this list of conditions and the following disclaimer in the
+#    documentation and/or other materials provided with the distribution.
+# 3. Neither the name of authors nor the names of its contributors
+#    may be used to endorse or promote products derived from this software
+#    without specific prior written permission.
+#
+# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE
+# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+# SUCH DAMAGE.
+#
+
+{
+  'variables': {
+    'relative_dir': 'unix/fcitx',
+    'gen_out_dir': '<(SHARED_INTERMEDIATE_DIR)/<(relative_dir)',
+    'pkg_config_libs': [
+      'fcitx',
+      'fcitx-config',
+      'fcitx-utils',
+    ],
+    'fcitx_dep_include_dirs': [
+    ],
+    'fcitx_dependencies': [
+        '../../base/base.gyp:base',
+        '../../client/client.gyp:client',
+        '../../ipc/ipc.gyp:ipc',
+        '../../session/session_base.gyp:ime_switch_util',
+        '../../session/session_base.gyp:session_protocol',
+    ],
+    'fcitx_defines': [
+      'LOCALEDIR="<!@(fcitx4-config --prefix)/share/locale/"',
+    ]
+  },
+  'targets': [
+    {
+      'target_name': 'gen_fcitx_mozc_i18n',
+      'type': 'none',
+      'actions': [
+        {
+          'action_name': 'gen_fcitx_mozc_i18n',
+          'inputs': [
+            './gen_fcitx_mozc_i18n.sh'
+          ],
+          'outputs': [
+            '<(gen_out_dir)/po/zh_CN.mo',
+            '<(gen_out_dir)/po/zh_TW.mo',
+            '<(gen_out_dir)/po/ja.mo',
+          ],
+          'action': [
+            'sh',
+            './gen_fcitx_mozc_i18n.sh',
+            '<(gen_out_dir)/po',
+          ],
+        }],
+    },
+    {
+      'target_name': 'fcitx-mozc',
+      'product_prefix': '',
+      'type': 'loadable_module',
+      'sources': [
+        'fcitx_mozc.cc',
+        'fcitx_key_translator.cc',
+        'mozc_connection.cc',
+        'mozc_response_parser.cc',
+        'eim.cc',
+      ],
+      'dependencies': [
+        '<@(fcitx_dependencies)',
+        'gen_fcitx_mozc_i18n',
+      ],
+      'cflags': [
+        '<!@(pkg-config --cflags <@(pkg_config_libs))',
+      ],
+      'include_dirs': [
+        '<@(fcitx_dep_include_dirs)',
+      ],
+      'libraries': [
+        '<!@(pkg-config --libs-only-l <@(pkg_config_libs))',
+      ],
+      'ldflags': [
+        '<!@(pkg-config --libs-only-L <@(pkg_config_libs))',
+      ],
+      'defines': [
+        '<@(fcitx_defines)',
+      ],
+    },
+  ],
+}
