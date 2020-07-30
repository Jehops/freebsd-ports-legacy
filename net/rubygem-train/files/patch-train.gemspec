--- train.gemspec.orig	2020-07-24 06:34:34 UTC
+++ train.gemspec
@@ -32,8 +32,8 @@ Gem::Specification.new do |s|
       s.add_runtime_dependency(%q<azure_mgmt_security>.freeze, ["~> 0.18"])
       s.add_runtime_dependency(%q<azure_mgmt_storage>.freeze, ["~> 0.18"])
       s.add_runtime_dependency(%q<docker-api>.freeze, ["~> 1.26"])
-      s.add_runtime_dependency(%q<google-api-client>.freeze, [">= 0.23.9", "< 0.35.0"])
-      s.add_runtime_dependency(%q<googleauth>.freeze, [">= 0.6.6", "< 0.11.0"])
+      s.add_runtime_dependency(%q<google-api-client>.freeze, [">= 0.23.9"])
+      s.add_runtime_dependency(%q<googleauth>.freeze, [">= 0.6.6"])
     else
       s.add_dependency(%q<train-core>.freeze, ["= 3.3.6"])
       s.add_dependency(%q<train-winrm>.freeze, ["~> 0.2"])
