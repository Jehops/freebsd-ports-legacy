--- bridges/source/cpp_uno/gcc3_freebsd_intel/share.hxx.orig	2014-09-19 17:51:12 UTC
+++ bridges/source/cpp_uno/gcc3_freebsd_intel/share.hxx
@@ -26,6 +26,11 @@
 #include <typeinfo>
 #include <exception>
 #include <cstddef>
+#ifndef __GLIBCXX__
+#include <cxxabi.h>
+
+using namespace ::__cxxabiv1;
+#endif /* ! __GLIBCXX__ */
 
 namespace CPPU_CURRENT_NAMESPACE
 {
@@ -34,6 +39,7 @@ void dummy_can_throw_anything( char cons
 
 // ----- following decl from libstdc++-v3/libsupc++/unwind-cxx.h and unwind.h
 
+#ifdef __GLIBCXX__
 struct _Unwind_Exception
 {
     unsigned exception_class __attribute__((__mode__(__DI__)));
@@ -63,11 +69,13 @@ struct __cxa_exception
     _Unwind_Exception unwindHeader;
 };    
 
+#endif /* __GLIBCXX__ */
 extern "C" void *__cxa_allocate_exception(
     std::size_t thrown_size ) throw();
 extern "C" void __cxa_throw (
     void *thrown_exception, std::type_info *tinfo, void (*dest) (void *) ) __attribute__((noreturn));
 
+#ifdef __GLIBCXX__
 struct __cxa_eh_globals
 {
     __cxa_exception *caughtExceptions;
@@ -75,6 +83,7 @@ struct __cxa_eh_globals
 };
 extern "C" __cxa_eh_globals *__cxa_get_globals () throw();
 
+#endif /* __GLIBCXX__ */
 // -----
 
 //==================================================================================================
@@ -84,3 +93,22 @@ void raiseException(
 void fillUnoException(
     __cxa_exception * header, uno_Any *, uno_Mapping * pCpp2Uno );
 }
+#ifndef __GLIBCXX__
+
+class __class_type_info : public std::type_info
+{
+public:
+        explicit __class_type_info( const char* pRttiName)
+        : std::type_info( pRttiName)
+        {}
+};
+
+class __si_class_type_info : public __class_type_info
+{
+        const __class_type_info* mpBaseType;
+public:
+        explicit __si_class_type_info( const char* pRttiName, __class_type_info* pBaseType)
+        : __class_type_info( pRttiName), mpBaseType( pBaseType)
+        {}
+};
+#endif /* ! __GLIBCXX__ */
