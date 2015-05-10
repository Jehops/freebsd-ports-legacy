--- osquery/tables/system/freebsd/users.cpp.orig	2015-05-05 00:16:41 UTC
+++ osquery/tables/system/freebsd/users.cpp
@@ -8,16 +8,45 @@
  *
  */
 
+#include <set>
+#include <mutex>
+#include <vector>
+#include <string>
+
+#include <pwd.h>
+
 #include <osquery/core.h>
 #include <osquery/tables.h>
 
 namespace osquery {
 namespace tables {
 
+std::mutex pwdEnumerationMutex;
+
 QueryData genUsers(QueryContext& context) {
+  std::lock_guard<std::mutex> lock(pwdEnumerationMutex);
   QueryData results;
+  struct passwd *pwd = nullptr;
+  std::set<long> users_in;
 
-  throw std::domain_error("Table not implemented for FreeBSD");
+  while ((pwd = getpwent()) != nullptr) {
+    if (std::find(users_in.begin(), users_in.end(), pwd->pw_uid) ==
+        users_in.end()) {
+      Row r;
+      r["uid"] = BIGINT(pwd->pw_uid);
+      r["gid"] = BIGINT(pwd->pw_gid);
+      r["uid_signed"] = BIGINT((int32_t) pwd->pw_uid);
+      r["gid_signed"] = BIGINT((int32_t) pwd->pw_gid);
+      r["username"] = TEXT(pwd->pw_name);
+      r["description"] = TEXT(pwd->pw_gecos);
+      r["directory"] = TEXT(pwd->pw_dir);
+      r["shell"] = TEXT(pwd->pw_shell);
+      results.push_back(r);
+      users_in.insert(pwd->pw_uid);
+    }
+  }
+  endpwent();
+  users_in.clear();
 
   return results;
 }
