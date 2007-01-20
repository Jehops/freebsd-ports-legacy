--- bittorrent-console.py.orig	Tue Jun  6 20:43:25 2006
+++ bittorrent-console.py	Thu Jun 15 14:44:32 2006
@@ -14,6 +14,13 @@
 
 from __future__ import division
 
+try:
+  import psyco
+  assert psyco.__version__ >= 0x010300f0
+  psyco.full()
+except:
+  pass
+
 app_name = "BitTorrent"
 from BitTorrent.translation import _
 import sys
