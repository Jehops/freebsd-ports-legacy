--- src/anthyconv.cpp.orig	2003-06-02 14:50:36 UTC
+++ src/anthyconv.cpp
@@ -5,6 +5,7 @@
 #endif
 
 #include <stdio.h>
+#include <string.h>
 #include "anthy.xpm"
 #include "jmode.h"
 #include "anthyconv.h"
@@ -147,7 +148,7 @@ KKContext *AnthyConv::createContext(XimI
     return anthy;
 }
 
-char **AnthyConv::getIcon()
+const char **AnthyConv::getIcon()
 {
     // toolbar�˽ФƤ��륢��������֤���
     return anthy_xpm;
