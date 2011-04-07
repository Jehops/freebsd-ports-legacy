
$FreeBSD: /tmp/pcvs/ports/devel/llvm-etoile/files/patch-tools_clang_lib_Sema_SemaDeclAttr.cpp,v 1.1 2011-04-07 18:45:00 dinoex Exp $

--- tools/clang/lib/Sema/SemaDeclAttr.cpp.orig
+++ tools/clang/lib/Sema/SemaDeclAttr.cpp
@@ -1011,7 +1011,10 @@
   default: break;
   case 5: Supported = !memcmp(Format, "scanf", 5); break;
   case 6: Supported = !memcmp(Format, "printf", 6); break;
-  case 7: Supported = !memcmp(Format, "strfmon", 7); break;
+  case 7:
+    Supported = (!memcmp(Format, "strfmon", 7) ||
+                 !memcmp(Format, "printf0", 7));
+    break;
   case 8:
     Supported = (is_strftime = !memcmp(Format, "strftime", 8)) ||
                 (is_NSString = !memcmp(Format, "NSString", 8)) ||
