--- pqiv.c.orig	2009-10-08 19:49:20.000000000 +0900
+++ pqiv.c	2009-10-10 17:43:14.000000000 +0900
@@ -234,7 +234,7 @@
 		}}}		
 	 */
 	g_print("usage: pqiv [options] <files or folders>\n"
-		"(p)qiv version " RELEASE " by Phillip Berndt\n"
+		"PQIV version " RELEASE " by Phillip Berndt\n"
 		"\n");
 	if(claim != 0) {
 		g_print("I don't understand the meaning of %c\n\n", claim);
@@ -273,7 +273,7 @@
                 #ifndef NO_COMMANDS
                 " -<n> s         Set command number n (1-9) to s \n"
                 "                See manpage for advanced commands (starting with > or |) \n"
-                " -q             Use the qiv-command script for commands \n"
+                " -q             Use the " BINARY_NAME "-command script for commands \n"
                 #endif
 
                 "\n"
@@ -297,7 +297,7 @@
                 " v              Vertical flip \n"
                 " i              Show/hide info box \n"
                 " s              Slideshow toggle \n"
-                " a              Hardlink current image to .qiv-select/ \n"
+                " a              Hardlink current image to ." BINARY_NAME "-select/ \n"
                 #ifndef NO_COMMANDS
                 " <n>            Run command n (1-3) \n"
                 #endif
@@ -1737,12 +1737,12 @@
 			}
 			break;
 			/* }}} */
-		/* BIND: a: Hardlink current image to .qiv-select/ {{{ */
+		/* BIND: a: Hardlink current image to ." BINARY_NAME "-select/ {{{ */
 		case GDK_a:
-			mkdir("./.qiv-select", 0755);
+			mkdir("./." BINARY_NAME "-select", 0755);
 			buf2 = basename(currentFile->fileName); /* Static memory, do not free */
-			buf = (char*)g_malloc(strlen(buf2) + 15);
-			sprintf(buf, "./.qiv-select/%s", buf2);
+			buf = (char*)g_malloc(strlen(buf2) + 15 + strlen(BINARY_NAME) );
+			sprintf(buf, "./." BINARY_NAME "-select/%s", buf2);
 			if(link(currentFile->fileName, buf) != 0) {
 				/* Failed to link image, try copying it */
 				if(copyFile(currentFile->fileName, buf) != TRUE) {
@@ -2214,13 +2214,13 @@
 				}
 				optionCommands[i] = g_strdup((gchar*)optarg);
 				break;
-			/* OPTION: -q: Use the qiv-command script for commands */
+			/* OPTION: -q: Use the BINARY_NAME-command script for commands */
 			case 'q':
 				for(i=0; i<10; i++) {
 					if(optionCommands[i] != NULL) {
 						g_free(optionCommands[i]);
 					}
-					optionCommands[i] = g_strdup("qiv-command 0");
+					optionCommands[i] = g_strdup(BINARY_NAME "-command 0");
 					optionCommands[i][12] += i;
 				}
 				break;
