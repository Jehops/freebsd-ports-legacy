--- config.mk.orig	2014-08-14 14:51:10 UTC
+++ config.mk
@@ -92,7 +92,7 @@ HOSTCC		 = $(call os_x_before, 10, 5, "c
 HOSTCFLAGS	+= $(call os_x_before, 10, 4, "-traditional-cpp")
 HOSTLDFLAGS	+= $(call os_x_before, 10, 5, "-multiply_defined suppress")
 else
-HOSTCC		= gcc
+HOSTCC		?= gcc
 endif
 
 ifeq ($(HOSTOS),cygwin)
