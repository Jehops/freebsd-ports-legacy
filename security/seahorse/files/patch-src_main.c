--- src/main.c.orig	Mon May  5 02:45:14 2003
+++ src/main.c	Mon May  5 02:45:47 2003
@@ -29,7 +29,7 @@
 #include "seahorse-libdialogs.h"
 
 static gchar *import = NULL;
-static gchar *encrypt = NULL;
+static gchar *sea_encrypt = NULL;
 static gchar *sign = NULL;
 static gchar *encrypt_sign = NULL;
 static gchar *decrypt = NULL;
@@ -40,7 +40,7 @@
 	{ "import", 'i', POPT_ARG_STRING, &import, 0,
 	  N_("Import keys from the file"), N_("FILE") },
 
-	{ "encrypt", 'e', POPT_ARG_STRING, &encrypt, 0,
+	{ "encrypt", 'e', POPT_ARG_STRING, &sea_encrypt, 0,
 	  N_("Encrypt file"), N_("FILE") },
 
 	{ "sign", 's', POPT_ARG_STRING, &sign, 0,
@@ -137,8 +137,8 @@
 			return 0;
 		}
 	}
-	if (encrypt != NULL)
-		do_encrypt (sctx, encrypt, seahorse_op_encrypt_file, _("Encrypt file is %s"));
+	if (sea_encrypt != NULL)
+		do_encrypt (sctx, sea_encrypt, seahorse_op_encrypt_file, _("Encrypt file is %s"));
 	if (sign != NULL) {
 		new_path = seahorse_op_sign_file (sctx, sign, &err);
 		
