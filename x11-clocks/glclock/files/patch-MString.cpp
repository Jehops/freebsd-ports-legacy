--- MString.cpp.orig
+++ MString.cpp
@@ -1,6 +1,9 @@
 
 #include "MString.H"
 
+String Left(const String &, int);
+String Mid(String, int, int);
+String Right(const String &, int);
 
 // ���󥹥ȥ饯��
 String::String(int n)
