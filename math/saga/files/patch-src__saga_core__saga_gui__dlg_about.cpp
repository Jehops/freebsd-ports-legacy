--- src/saga_core/saga_gui/dlg_about.cpp.orig	2014-09-04 20:46:26.000000000 +0200
+++ src/saga_core/saga_gui/dlg_about.cpp	2014-09-04 21:11:43.000000000 +0200
@@ -65,6 +65,7 @@
 #include <saga_api/clipper.hpp>
 
 #include <wx/notebook.h>
+#include <wx/platform.h>
 
 #include "helper.h"
 
@@ -246,7 +247,19 @@
 		#elif	defined(__GNUWIN32__)
 			"Gnu-Win32 compiler"
 		#elif	defined(__GNUG__)
-			"Gnu C++"
+			#if   wxCHECK_GCC_VERSION(5,0)
+				"Gnu C++ 5.0"
+			#elif wxCHECK_GCC_VERSION(4,9)
+				"Gnu C++ 4.9"
+			#elif wxCHECK_GCC_VERSION(4,8)
+				"Gnu C++ 4.8"
+			#elif wxCHECK_GCC_VERSION(4,7)
+				"Gnu C++ 4.7"
+			#elif wxCHECK_GCC_VERSION(4,6)
+				"Gnu C++ 4.6"
+			#else
+				"Gnu C++"
+			#endif
 		#elif	defined(__MWERKS__)
 			"CodeWarrior MetroWerks compiler"
 		#elif	defined(__SUNCC__)
