--- ../sal/osl/unx/nlsupport.c.orig	Wed Apr 10 18:11:58 2002
+++ ../sal/osl/unx/nlsupport.c	Fri Oct 18 23:31:19 2002
@@ -63,7 +63,7 @@
 #include <osl/diagnose.h>
 #include <osl/process.h>
 
-#if defined(LINUX) || defined(SOLARIS)
+#if defined(LINUX) || defined(SOLARIS) || defined(NETBSD) || defined(FREEBSD) || defined(IRIX)
 #include <pthread.h>
 #include <locale.h>
 #include <langinfo.h>
@@ -114,8 +114,7 @@
         comparison = _pair_compare( key, base + current );
         if (comparison < 0)
             upper = current;
-        else
-        if (comparison > 0)
+        else if (comparison > 0)
             lower = current + 1;
         else
             return base + current;
@@ -241,12 +240,13 @@
     return NULL;
 }
         
-#if defined(LINUX) || defined(SOLARIS)
+#if defined(LINUX) || defined(SOLARIS) || defined(IRIX) || defined(FREEBSD) || defined(NETBSD)
 
 /*
  * This implementation of osl_getTextEncodingFromLocale maps 
  * from nl_langinfo(CODESET) to rtl_textencoding defines. 
- * nl_langinfo() is supported only on Linux and Solaris. 
+ * nl_langinfo() is supported only on Linux, Solaris and IRIX,
+ * >= NetBSD 1.6 and >= FreeBSD 4.4
  *
  * This routine is SLOW because of the setlocale call, so
  * grab the result and cache it.
@@ -260,6 +260,12 @@
 #endif
 #endif
 
+/*
+ * _nl_language_list[] is an array list of supported encodings. Because
+ * we are using a binary search, the list has to be in ascending order.
+ * We are comparing the encodings case insensitiv, so the list has
+ * to be completly upper- , or lowercase.
+ */
 
 #if defined(SOLARIS)
 
@@ -478,7 +484,79 @@
     { "WIN-SAMI-2",                 RTL_TEXTENCODING_DONTKNOW }     /* WS2 */
 };
 
-#endif /* ifdef LINUX */
+#elif defined(IRIX)
+
+const _pair _nl_language_list[] = {
+    { "BIG5",          RTL_TEXTENCODING_BIG5           }, /* China - Traditional Chinese */
+    { "EUCCN",         RTL_TEXTENCODING_EUC_CN         }, /* China */
+    { "EUCGBK",                RTL_TEXTENCODING_DONTKNOW       }, /* China - Simplified Chinese */
+    { "EUCJP",         RTL_TEXTENCODING_EUC_JP         }, /* Japan */
+    { "EUCKR",         RTL_TEXTENCODING_EUC_KR         }, /* Korea */
+    { "EUCTW",         RTL_TEXTENCODING_EUC_TW         }, /* Taiwan - Traditional Chinese */
+    { "GBK",           RTL_TEXTENCODING_GBK            }, /* China - Simplified Chinese */
+    { "ISO8859-1",     RTL_TEXTENCODING_ISO_8859_1     }, /* Western */
+    { "ISO8859-15",    RTL_TEXTENCODING_ISO_8859_15    }, /* Western Updated (w/Euro sign) */
+    { "ISO8859-2",     RTL_TEXTENCODING_ISO_8859_2     }, /* Central European */
+    { "ISO8859-5",     RTL_TEXTENCODING_ISO_8859_5     }, /* Cyrillic */
+    { "ISO8859-7",     RTL_TEXTENCODING_ISO_8859_7     }, /* Greek */
+    { "ISO8859-9",     RTL_TEXTENCODING_ISO_8859_9     }, /* Turkish */
+    { "SJIS",          RTL_TEXTENCODING_SHIFT_JIS      }  /* Japan */
+  };
+
+#elif defined(FREEBSD)
+
+const _pair _nl_language_list[] = {
+    { "ASCII",         RTL_TEXTENCODING_ASCII_US       }, /* US-ASCII */
+    { "BIG5",          RTL_TEXTENCODING_BIG5           }, /* China - Traditional Chinese */
+    { "CP1251",                RTL_TEXTENCODING_MS_1251        }, /* MS-CYRL */
+    { "CP866",         RTL_TEXTENCODING_IBM_866        }, /* CP866 866 */
+    { "EUCCN",         RTL_TEXTENCODING_EUC_CN         }, /* China - Simplified Chinese */
+    { "EUCJP",         RTL_TEXTENCODING_EUC_JP         }, /* Japan */
+    { "EUCKR",         RTL_TEXTENCODING_EUC_KR         }, /* Korea */
+    { "ISO8859-1",     RTL_TEXTENCODING_ISO_8859_1     }, /* Western */
+    { "ISO8859-15",    RTL_TEXTENCODING_ISO_8859_15    }, /* Western Updated (w/Euro sign) */
+    { "ISO8859-2",     RTL_TEXTENCODING_ISO_8859_2     }, /* Central European */
+    { "ISO8859-4",     RTL_TEXTENCODING_ISO_8859_4     }, /* LATIN4 L4 */
+    { "ISO8859-5",     RTL_TEXTENCODING_ISO_8859_5     }, /* Cyrillic */
+    { "ISO8859-7",     RTL_TEXTENCODING_ISO_8859_7     }, /* Greek */
+    { "ISO8859-9",     RTL_TEXTENCODING_ISO_8859_9     }, /* Turkish */
+    { "KOI-U",         RTL_TEXTENCODING_DONTKNOW       }, /* Not supported at the moment */
+    { "KOI8-R",                RTL_TEXTENCODING_KOI8_R         }, /* KOI8 */
+    { "SJIS",          RTL_TEXTENCODING_SHIFT_JIS      }, /* Japan */
+    { "US-ASCII",      RTL_TEXTENCODING_ASCII_US       }, /* US-ASCII */
+    { "UTF-8",         RTL_TEXTENCODING_UTF8           }  /* ISO-10646/UTF-8 */
+ };
+
+#elif defined(NETBSD)
+
+const _pair _nl_language_list[] = {
+    { "ASCII",         RTL_TEXTENCODING_ASCII_US       }, /* US-ASCII */
+    { "BIG5",          RTL_TEXTENCODING_BIG5           }, /* China - Traditional Chinese */
+    { "CP1251",                RTL_TEXTENCODING_MS_1251        }, /* MS-CYRL */
+    { "CP866",         RTL_TEXTENCODING_IBM_866        }, /* CP866 866 */
+    { "CTEXT",         RTL_TEXTENCODING_ASCII_US       }, /* US-ASCII */
+    { "EUCCN",         RTL_TEXTENCODING_EUC_CN         }, /* China - Simplified Chinese */
+    { "EUCJP",         RTL_TEXTENCODING_EUC_JP         }, /* Japan */
+    { "EUCKR",         RTL_TEXTENCODING_EUC_KR         }, /* Korea */
+    { "EUCTW",         RTL_TEXTENCODING_EUC_TW         }, /* China - Traditional Chinese */
+    { "ISO-2022-JP",   RTL_TEXTENCODING_DONTKNOW       }, /* */
+    { "ISO-2022-JP-2", RTL_TEXTENCODING_DONTKNOW       }, /* */
+    { "ISO8859-1",     RTL_TEXTENCODING_ISO_8859_1     }, /* Western */
+    { "ISO8859-15",    RTL_TEXTENCODING_ISO_8859_15    }, /* Western Updated (w/Euro sign) */
+    { "ISO8859-2",     RTL_TEXTENCODING_ISO_8859_2     }, /* Central European */
+    { "ISO8859-4",     RTL_TEXTENCODING_ISO_8859_4     }, /* LATIN4 L4 */
+    { "ISO8859-5",     RTL_TEXTENCODING_ISO_8859_5     }, /* Cyrillic */
+    { "ISO8859-7",     RTL_TEXTENCODING_ISO_8859_7     }, /* Greek */
+    { "ISO8859-9",     RTL_TEXTENCODING_ISO_8859_9     }, /* Turkish */
+    { "KOI-U",         RTL_TEXTENCODING_DONTKNOW       }, /* Not supported at the moment */
+    { "KOI8-R",                RTL_TEXTENCODING_KOI8_R         }, /* KOI8 */
+    { "SJIS",          RTL_TEXTENCODING_SHIFT_JIS      }, /* Japan */
+    { "US-ASCII",      RTL_TEXTENCODING_ASCII_US       }, /* US-ASCII */
+    { "UTF-8",         RTL_TEXTENCODING_UTF8           }  /* ISO-10646/UTF-8 */
+};
+
+#endif /* ifdef SOLARIS IRIX LINUX FREEBSD NETBSD */
+
 
 static pthread_mutex_t aLocalMutex = PTHREAD_MUTEX_INITIALIZER;
 
