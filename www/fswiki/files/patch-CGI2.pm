--- lib/CGI2.pm.orig	Sun Aug 22 13:49:49 2004
+++ lib/CGI2.pm	Mon Nov  8 12:55:21 2004
@@ -30,7 +30,7 @@
 	my $dir   = $wiki->config('session_dir');
 	my $limit = $wiki->config('session_limit');
 	
-	opendir(SESSION_DIR,$dir) or die $!;
+	opendir(SESSION_DIR,$dir) or die "$!: $dir";
 	my $timeout = time() - (60 * $limit);
 	while(my $entry = readdir(SESSION_DIR)){
 		if($entry =~ /^cgisess_/){
@@ -54,7 +54,7 @@
 	# ���å���󳫻ϥե饰��Ω�äƤ��餺��Cookie�˥��å����ID��
 	# ¸�ߤ��ʤ����ϥ��å������������ʤ�
 	if(!defined($self->{session_cache})){
-		if($start!=1 && $self->cookie(-name=>'CGISESSID') eq ""){
+		if((not defined $start or $start!=1) && $self->cookie(-name=>'CGISESSID') eq ""){
 			return undef;
 		}
 		my $dir   = $wiki->config('session_dir');
