diff --git libpkg/pkg_elf.c libpkg/pkg_elf.c
index 8ac65ba..2abfc0e 100644
--- libpkg/pkg_elf.c
+++ libpkg/pkg_elf.c
@@ -484,7 +484,7 @@ pkg_get_myarch(char *dest, size_t sz)
 	uint32_t version = 0;
 	int ret = EPKG_OK;
 	int i;
-	const char *abi, *endian_corres_str, *wordsize_corres_str;
+	const char *abi, *endian_corres_str, *wordsize_corres_str, *fpu;
 
 	if (elf_version(EV_CURRENT) == EV_NONE) {
 		pkg_emit_error("ELF library initialization failed: %s",
@@ -569,10 +569,28 @@ pkg_get_myarch(char *dest, size_t sz)
 		endian_corres_str = elf_corres_to_string(endian_corres,
 		    (int)elfhdr.e_ident[EI_DATA]);
 
+		/* FreeBSD doesn't support the hard-float ABI yet */
+		fpu = "softfp";
+		if ((elfhdr.e_flags & 0xFF000000) != 0) {
+			/* This is an EABI file, the conformance level is set */
+			abi = "eabi";
+		} else if (elfhdr.e_ident[EI_OSABI] != ELFOSABI_NONE) {
+			/*
+			 * EABI executables all have this field set to
+			 * ELFOSABI_NONE, therefore it must be an oabi file.
+			 */
+			abi = "oabi";
+                } else {
+			/*
+			 * We may have failed to positively detect the ABI,
+			 * set the ABI to unknown. If we end up here one of
+			 * the above cases should be fixed for the binary.
+			 */
+			pkg_emit_error("unknown ARM ABI");
+			goto cleanup;
+		}
 		snprintf(dest + strlen(dest), sz - strlen(dest), ":%s:%s:%s",
-		    endian_corres_str,
-		    (elfhdr.e_flags & EF_ARM_NEW_ABI) > 0 ? "eabi" : "oabi",
-		    (elfhdr.e_flags & EF_ARM_VFP_FLOAT) > 0 ? "softfp" : "vfp");
+		    endian_corres_str, abi, fpu);
 		break;
 	case EM_MIPS:
 		/*
