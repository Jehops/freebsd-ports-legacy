--- datastudio.sh	Wed Aug  4 15:15:16 2004
+++ datastudio.sh	Fri Feb 11 16:08:59 2005
@@ -1,7 +1,7 @@
 #!/bin/sh
 #SET ADS_HOME to the root installation directory for DataStudio
 
-ADS_HOME=`dirname $0`
+ADS_HOME=%%ADS_HOME%%
 
 CLASSES=$ADS_HOME/lib/datastudio.jar
 CLASSES=$ADS_HOME/lib/oracle.jar:$CLASSES
