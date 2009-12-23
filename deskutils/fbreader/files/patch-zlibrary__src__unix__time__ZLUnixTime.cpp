--- ./zlibrary/core/src/unix/time/ZLUnixTime.cpp.orig	2009-12-13 11:03:09.000000000 +0300
+++ ./zlibrary/core/src/unix/time/ZLUnixTime.cpp	2009-12-23 09:34:03.273539781 +0300
@@ -17,33 +17,37 @@
  * 02110-1301, USA.
  */
 
-#include <sys/timeb.h>
-#include <time.h>
+#include <sys/time.h>
 
 #include "ZLUnixTime.h"
 
 ZLTime ZLUnixTimeManager::currentTime() const {
-	struct timeb timeB;
-	ftime(&timeB);
-	return ZLTime(timeB.time, timeB.millitm);
+	struct timeval timeB;
+	gettimeofday(&timeB,NULL);
+	return ZLTime(timeB.tv_sec, timeB.tv_usec/1000);
 }
 
 short ZLUnixTimeManager::hoursBySeconds(long seconds) const {
-	return localtime(&seconds)->tm_hour;
+	time_t st = seconds;
+	return localtime(&st)->tm_hour;
 }
 
 short ZLUnixTimeManager::minutesBySeconds(long seconds) const {
-	return localtime(&seconds)->tm_min;
+	time_t st = seconds;
+	return localtime(&st)->tm_min;
 }
 
 short ZLUnixTimeManager::yearBySeconds(long seconds) const {
-	return localtime(&seconds)->tm_year + 1900;
+	time_t st = seconds;
+	return localtime(&st)->tm_year + 1900;
 }
 
 short ZLUnixTimeManager::monthBySeconds(long seconds) const {
-	return localtime(&seconds)->tm_mon + 1;
+	time_t st = seconds;
+	return localtime(&st)->tm_mon + 1;
 }
 
 short ZLUnixTimeManager::dayOfMonthBySeconds(long seconds) const {
-	return localtime(&seconds)->tm_mday;
+	time_t st = seconds;
+	return localtime(&st)->tm_mday;
 }
