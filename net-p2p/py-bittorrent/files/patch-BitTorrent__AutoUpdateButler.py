--- BitTorrent/AutoUpdateButler.py.orig	Sat Dec 16 08:30:05 2006
+++ BitTorrent/AutoUpdateButler.py	Sat Dec 16 08:30:27 2006
@@ -301,7 +301,7 @@
 
     def _check_signature(self, torrentfile, signature):
         """Check the torrent file's signature using the public key."""
-        public_key_file = open(os.path.join(doc_root, 'public.key'), 'rb')
+        public_key_file = open(os.path.join(%%DATADIR%%, 'public.key'), 'rb')
         public_key = pickle.load(public_key_file)
         public_key_file.close()
         h = sha(torrentfile).digest()
