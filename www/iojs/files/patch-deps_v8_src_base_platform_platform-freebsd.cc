--- deps/v8/src/base/platform/platform-freebsd.cc.orig	2015-02-06 03:18:41 UTC
+++ deps/v8/src/base/platform/platform-freebsd.cc
@@ -188,7 +188,7 @@ VirtualMemory::VirtualMemory(size_t size
   void* reservation = mmap(OS::GetRandomMmapAddr(),
                            request_size,
                            PROT_NONE,
-                           MAP_PRIVATE | MAP_ANON | MAP_NORESERVE,
+                           MAP_PRIVATE | MAP_ANON,
                            kMmapFd,
                            kMmapFdOffset);
   if (reservation == MAP_FAILED) return;
@@ -260,7 +260,7 @@ void* VirtualMemory::ReserveRegion(size_
   void* result = mmap(OS::GetRandomMmapAddr(),
                       size,
                       PROT_NONE,
-                      MAP_PRIVATE | MAP_ANON | MAP_NORESERVE,
+                      MAP_PRIVATE | MAP_ANON,
                       kMmapFd,
                       kMmapFdOffset);
 
@@ -288,7 +288,7 @@ bool VirtualMemory::UncommitRegion(void*
   return mmap(base,
               size,
               PROT_NONE,
-              MAP_PRIVATE | MAP_ANON | MAP_NORESERVE | MAP_FIXED,
+              MAP_PRIVATE | MAP_ANON | MAP_FIXED,
               kMmapFd,
               kMmapFdOffset) != MAP_FAILED;
 }
