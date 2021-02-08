--- content/browser/compositor/viz_process_transport_factory.cc.orig	2021-01-25 11:27:00 UTC
+++ content/browser/compositor/viz_process_transport_factory.cc
@@ -108,7 +108,7 @@ class HostDisplayClient : public viz::HostDisplayClien
   HostDisplayClient& operator=(const HostDisplayClient&) = delete;
 
   // viz::HostDisplayClient:
-#if defined(OS_LINUX) && !defined(OS_CHROMEOS)
+#if (defined(OS_LINUX) && !defined(OS_CHROMEOS)) || defined(OS_BSD)
   void DidCompleteSwapWithNewSize(const gfx::Size& size) override {
     compositor_->OnCompleteSwapWithNewSize(size);
   }
