--- mono/mini/mini-amd64.c.orig	Sun Oct 30 14:33:12 2005
+++ mono/mini/mini-amd64.c	Sun Nov 13 18:39:16 2005
@@ -13,6 +13,7 @@
 #include "mini.h"
 #include <string.h>
 #include <math.h>
+#include <ucontext.h>
 
 #include <mono/metadata/appdomain.h>
 #include <mono/metadata/debug-helpers.h>
@@ -49,6 +49,10 @@
 #define ARGS_OFFSET 16
 #define GP_SCRATCH_REG AMD64_R11
 
+#ifndef MAP_ANONYMOUS
+#define MAP_ANONYMOUS MAP_ANON
+#endif
+
 /*
  * AMD64 register usage:
  * - callee saved registers are used for global register allocation
@@ -4639,6 +4643,7 @@
 
 #define IS_REX(inst) (((inst) >= 0x40) && ((inst) <= 0x4f))
 
+
 static int reg_to_ucontext_reg [] = {
 	REG_RAX, REG_RCX, REG_RDX, REG_RBX, REG_RSP, REG_RBP, REG_RSI, REG_RDI,
 	REG_R8, REG_R9, REG_R10, REG_R11, REG_R12, REG_R13, REG_R14, REG_R15,
@@ -4650,27 +4655,37 @@
  * integer overflow.
  */
 gboolean
-mono_arch_is_int_overflow (void *sigctx, void *info)
+mono_arch_is_int_overflow (void	*sigctx, void *info)
 {
-	ucontext_t *ctx = (ucontext_t*)sigctx;
-	guint8* rip;
-	int reg;
-
-	rip = (guint8*)ctx->uc_mcontext.gregs [REG_RIP];
+	ucontext_t *ctx	= (ucontext_t*)sigctx;
+	guint8*	rip;
+	int	reg;
+
+#if defined(__FreeBSD__)
+	__register_t *gregs	= (__register_t	*) &ctx->uc_mcontext;
+	rip	= (guint8*)	gregs[REG_RIP];
+#else
+	rip	= (guint8*)	ctx->uc_mcontext.gregs [REG_RIP];
+#endif
 
-	if (IS_REX (rip [0])) {
-		reg = amd64_rex_b (rip [0]);
-		rip ++;
+	if (IS_REX (rip	[0])) {
+		reg	= amd64_rex_b (rip [0]);
+		rip	++;
 	}
 	else
-		reg = 0;
+		reg	= 0;
 
-	if ((rip [0] == 0xf7) && (x86_modrm_mod (rip [1]) == 0x3) && (x86_modrm_reg (rip [1]) == 0x7)) {
-		/* idiv REG */
-		reg += x86_modrm_rm (rip [1]);
+	if ((rip [0] ==	0xf7) && (x86_modrm_mod	(rip [1]) == 0x3) && (x86_modrm_reg	(rip [1]) == 0x7)) {
+		/* idiv	REG	*/
+		reg	+= x86_modrm_rm	(rip [1]);
 
-		if (ctx->uc_mcontext.gregs [reg_to_ucontext_reg [reg]] == -1)
+#if defined(__FreeBSD__)
+		if (gregs[reg_to_ucontext_reg[reg]] == -1)
+			return TRUE;
+#else
+		if (ctx->uc_mcontext.gregs [reg_to_ucontext_reg	[reg]] == -1)
 			return TRUE;
+#endif
 	}
 
 	return FALSE;
