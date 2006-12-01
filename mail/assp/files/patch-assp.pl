--- assp.pl.orig	Thu Nov 30 16:33:20 2006
+++ assp.pl	Thu Nov 30 16:34:18 2006
@@ -69,7 +69,7 @@
 loadConfig();
 
 sub loadConfig {
- print "loading config -- base='$base'\n";
+ # print "loading config -- base='$base'\n";
  @Config=(
 
 
@@ -91,7 +91,7 @@
   'The address:port of your message handling system\'s smtp server(s). Secondary servers possible, will try the next if the first doesn\'t respond.<br />If only the port is entered, or the keyword <b>__INBOUND__</b>:<i>port</i> is used, then the connection will be established to the same IP where the connection was received. This is usefull when you have several IPs with different domains/profiles in your MTA.<br /> Examples: "127.0.0.1:125","127.0.0.1:125|127.0.0.5:125", "10.0.1.3", "10.0.1.3:1025", "__INBOUND__:125", "125", etc.'],
 [AsAService,'As a Service',0,checkbox,0,'(.*)',undef,
   'In Windows 2000 / NT you can run it as a service; requires <a href="http://www.roth.net/perl/Daemon/" rel="external">win32::daemon</a>. Requires start from the service control panel.'],
- [AsADaemon,'As a Daemon',0,checkbox,0,'(.*)',undef,
+ [AsADaemon,'As a Daemon',0,checkbox,1,'(.*)',undef,
  'In Linux/BSD/Unix/OSX fork and close file handles, kinda like "perl assp.pl &amp;" but better. Requires restart.'],
  [myName,'My Name',40,textinput,'ASSP.nospam','(\S+)',undef,
   'What the program calls itself in the email "received by" header. Usually ASSP.nospam.'],
@@ -666,7 +666,7 @@
   'SMTP error message to reject attachments.'],
 [UseAvClamd,'Use Av Clamd',0,checkbox,1,'(.*)',undef,
 'If activated, the message is checked by Av Clamd, this requires an installed <a href="http://search.cpan.org/~cfaber/File-Scan-ClamAV-1.06/lib/File/Scan/ClamAV.pm" rel="external">File::Scan::ClamAV</a> Perl module. '],
-[AvClamdPort,'Port or file socket for local Av Clamd',20,textinput,'3310','(\S+)',undef,
+[AvClamdPort,'Port or file socket for local Av Clamd',20,textinput,'/var/run/clamav/clamd','(\S+)',undef,
 'A port or socket to connect to. If the socket has been setup as a TCP/IP socket (see the TCPSocket option in the clamav.conf file), then specifying in a number will cause File::Scan::ClamAV to use a TCP socket. For example 3310 or /tmp/clamd '],
 [AvClamdBufSize,'Size of buffer for Av Clamd',7,textinput,'512','(\d+)',undef,
 'Buffer size for stream check, must be more than max length of virus signature'],
@@ -839,7 +839,7 @@
   '<span class="negative"> 0 = no report, 1 = to user, 2 = to TO address, 3 = both</span>'],
 [EmailRedlistTo,'To Address for Redlist-Reports',40,textinput,'','(.+)',undef,
   'Email sent from ASSP acknowledging your submissions will be sent to this address. For example: admin@domain.com'],
- [EmailFrom,'From Address for Reports',40,textinput,'<>','(.+)',undef,
+ [EmailFrom,'From Address for Reports',40,textinput,'<postmaster@yourdomain.com>','(.+)',undef,
   'Email sent from ASSP acknowledging your submissions will be sent from this address.<br />
   Some mailers don\'t like the default setting. For example: ASSP &lt;&gt; or Mail Administrator
   &lt;mailadmin@mydomain.com&gt;
@@ -943,9 +943,9 @@
   '],
 
 [0,0,0,'heading','Security'],
- [runAsUser,'Run as UID',20,textinput,'','(\S*)',undef,
+ [runAsUser,'Run as UID',20,textinput,'nobody','(\S*)',undef,
   'The *nix user name to assume after startup: assp or nobody -- requires ASSP restart.'],
- [runAsGroup,'Run as GID',20,textinput,'','(\S*)',undef,
+ [runAsGroup,'Run as GID',20,textinput,'nobody','(\S*)',undef,
   'The *nix group to assume after startup: assp or nogroup -- requires ASSP restart.'],
  [ChangeRoot,'Change Root',40,textinput,'','(.*)',undef,
   'Non-blank means to run in chroot jail in *nix. You need an etc/protocols file to make this work<br />
@@ -8328,6 +8328,7 @@
  @PossibleOptionFiles2=();
  foreach (@Config) {
   if($_->[6] eq 'ConfigMakeRe') {
+   $silent=1 if($AsADaemon);
    ${$_->[0]}=optionList(${$_->[0]},$_->[0]);
    push(@PossibleOptionFiles,$_->[0]);
   } elsif($_->[6] eq 'ConfigCompileRe') {
