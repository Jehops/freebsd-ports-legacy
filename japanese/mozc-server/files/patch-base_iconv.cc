--- base/iconv.cc.orig	2012-05-01 12:21:08.064690752 +0900
+++ base/iconv.cc	2012-03-16 10:59:56.300711667 +0900
@@ -52,7 +52,11 @@
   size_t olen_org = olen;
   iconv(ic, 0, &ilen, 0, &olen);  // reset iconv state
   while (ilen != 0) {
+#ifdef __FreeBSD__
+    if (iconv(ic, (const char **)(&ibuf), &ilen, &obuf, &olen)
+#else
     if (iconv(ic, reinterpret_cast<char **>(&ibuf), &ilen, &obuf, &olen)
+#endif
         == static_cast<size_t>(-1)) {
       return false;
     }
