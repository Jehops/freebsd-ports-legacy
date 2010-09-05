--- ipc/unix_ipc.cc.org	2010-09-03 11:29:17.747782268 +0900
+++ ipc/unix_ipc.cc	2010-09-05 10:10:24.194440985 +0900
@@ -41,7 +41,7 @@
 #include <sys/time.h>
 #include <sys/types.h>
 #include <sys/un.h>
-#ifdef OS_MACOSX
+#if defined(__FreeBSD__) || defined(OS_MACOSX)
 #include <sys/ucred.h>
 #endif
 #include <sys/wait.h>
@@ -124,7 +124,7 @@
 bool IsPeerValid(int socket, pid_t *pid) {
   *pid = 0;
 
-#ifdef OS_MACOSX
+#if defined(__FreeBSD__) || defined(OS_MACOSX)
   // If the OS is MAC, we should validate the peer by using LOCAL_PEERCRED.
   struct xucred peer_cred;
   socklen_t peer_cred_len = sizeof(struct xucred);
@@ -146,7 +146,7 @@
   *pid = 0;
 #endif
 
-#ifdef OS_LINUX
+#if !defined(__FreeBSD__) && defined(OS_LINUX)
   // On ARM Linux, we do nothing and just return true since the platform (at
   // least the qemu emulator) doesn't support the getsockopt(sock, SOL_SOCKET,
   // SO_PEERCRED) system call.
@@ -306,7 +306,7 @@
     address.sun_family = AF_UNIX;
     ::memcpy(address.sun_path, server_address.data(), server_address_length);
     address.sun_path[server_address_length] = '\0';
-#ifdef OS_MACOSX
+#if defined(__FreeBSD__) || defined(OS_MACOSX)
     address.sun_len = SUN_LEN(&address);
     const size_t sun_len = sizeof(address);
 #else
@@ -412,21 +412,21 @@
                SO_REUSEADDR,
                reinterpret_cast<char *>(&on),
                sizeof(on));
-#ifdef OS_MACOSX
+#if defined(__FreeBSD__) || defined(OS_MACOSX)
   addr.sun_len = SUN_LEN(&addr);
   const size_t sun_len = sizeof(addr);
 #else
   const size_t sun_len = sizeof(addr.sun_family) + server_address_.size();
 #endif
-  if (!IsAbstractSocket(server_address_)) {
-    // Linux does not use files for IPC.
-    ::chmod(server_address_.c_str(), 0600);
-  }
   if (::bind(socket_, reinterpret_cast<sockaddr *>(&addr), sun_len) != 0) {
     // The UNIX domain socket file (server_address_) already exists?
     LOG(FATAL) << "bind() failed: " << strerror(errno);
     return;
   }
+  if (!IsAbstractSocket(server_address_)) {
+    // Linux does not use files for IPC.
+    ::chmod(server_address_.c_str(), 0600);
+  }
 
   if (::listen(socket_, num_connections) < 0) {
     LOG(FATAL) << "listen() failed: " << strerror(errno);
