--- vendor/gvisor.dev/gvisor/pkg/sentry/platform/kvm/machine_unsafe.go.orig	2020-01-31 23:11:21 UTC
+++ vendor/gvisor.dev/gvisor/pkg/sentry/platform/kvm/machine_unsafe.go
@@ -13,7 +13,7 @@
 // limitations under the License.
 
 // +build go1.12
-// +build !go1.15
+// +build !go1.17
 
 // Check go:linkname function signatures when updating Go version.
 
