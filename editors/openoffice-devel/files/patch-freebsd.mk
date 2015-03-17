--- solenv/gbuild/platform/freebsd.mk.orig	2014-09-19 18:16:41 UTC
+++ solenv/gbuild/platform/freebsd.mk
@@ -96,6 +96,7 @@ gb_CXXFLAGS := \
 	-fvisibility-inlines-hidden \
 	-fvisibility=hidden \
 	-pipe \
+	%%HAVE_STL_INCLUDE_PATH%% \
 
 ifneq ($(EXTERNAL_WARNINGS_NOT_ERRORS),TRUE)
 gb_CFLAGS_WERROR := -Werror
@@ -121,6 +122,7 @@ gb_LinkTarget_LDFLAGS += \
 	-Wl,-z,combreloc \
 	-Wl,-z,defs \
 	$(subst -L../lib , ,$(SOLARLIB)) \
+	%%RPATH%% \
 	 \
 
 ifeq ($(HAVE_LD_HASH_STYLE),TRUE)
