--- src/util/string_util.cpp.orig	2012-06-13 06:56:48.000000000 +0200
+++ src/util/string_util.cpp	2012-06-21 09:49:48.000000000 +0200
@@ -92,7 +92,11 @@
 float atof( char const *s ) {
   char *end;
   errno = 0;
+#ifdef WIN32
   float result = std::strtof( s, &end );
+#else
+  float result = strtof( s, &end );
+#endif
   check_parse_number( s, end, &result );
   return result;
 }
@@ -100,7 +104,11 @@
 long long atoll( char const *s ) {
   char *end;
   errno = 0;
+#ifdef WIN32
   long long const result = std::strtoll( s, &end, 10 );
+#else
+  long long const result = strtoll( s, &end, 10 );
+#endif
   check_parse_number( s, end, static_cast<long long*>( nullptr ) );
   return result;
 }
@@ -114,7 +122,11 @@
 
   char *end;
   errno = 0;
+#ifdef WIN32
   unsigned long long const result = std::strtoull( s, &end, 10 );
+#else
+  unsigned long long const result = strtoull( s, &end, 10 );
+#endif
   check_parse_number( s, end, static_cast<unsigned long long*>( nullptr ) );
 
   if ( minus && result ) {
