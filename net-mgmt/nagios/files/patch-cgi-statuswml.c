--- cgi/statuswml.c.orig	2008-12-01 04:43:11.000000000 +1030
+++ cgi/statuswml.c	2009-07-09 18:35:02.000000000 +0930
@@ -67,6 +67,8 @@
 void document_header(void);
 void document_footer(void);
 int process_cgivars(void);
+int validate_arguments(void);
+int is_valid_hostip(char *hostip);
 
 int display_type=DISPLAY_INDEX;
 int hostgroup_style=DISPLAY_HOSTGROUP_SUMMARY;
@@ -108,6 +110,13 @@
 
 	document_header();
 
+	/* validate arguments in URL */
+	result=validate_arguments();
+	if(result==ERROR){
+		document_footer();
+		return ERROR;
+	        }
+	
 	/* read the CGI configuration file */
 	result=read_cgi_config_file(get_cgi_config_location());
 	if(result==ERROR){
@@ -334,7 +343,25 @@
 	return error;
         }
 
+int validate_arguments(void){
+	int result=OK;
+	if((strcmp(ping_address,"")) && !is_valid_hostip(ping_address)) {
+		printf("<p>Invalid host name/ip</p>\n");
+		result=ERROR;
+		}
+	if(strcmp(traceroute_address,"") && !is_valid_hostip(traceroute_address)){
+		printf("<p>Invalid host name/ip</p>\n");
+		result=ERROR;
+		}
+	return result;
+	}
 
+int is_valid_hostip(char *hostip) {
+	char *valid_domain_chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-";
+	if(strcmp(hostip,"") && strlen(hostip)==strspn(hostip,valid_domain_chars) && hostip[0] != '-' && hostip[strlen(hostip)-1] != '-')
+		return TRUE;
+	return FALSE;
+	}
 
 /* main intro screen */
 void display_index(void){
