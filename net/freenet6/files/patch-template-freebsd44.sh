--- template/freebsd44.sh.orig	Sat Feb 23 06:32:37 2002
+++ template/freebsd44.sh	Fri Jan  3 22:13:35 2003
@@ -64,7 +64,6 @@
 Display 1 '--- Start of configuration script. ---'
 Display 1 "Script: " `basename $0`
 
-gifconfig=/usr/sbin/gifconfig
 ifconfig=/sbin/ifconfig
 route=/sbin/route
 rtadvd=/usr/sbin/rtadvd
@@ -89,7 +88,7 @@
 fi

 #change to upper case
-TSP_HOST_TYPE=`echo $TSP_HOST_TYPE | tr a-z A-Z`
+TSP_HOST_TYPE=`echo $TSP_HOST_TYPE | tr [:lower:] [:upper:]`

 if [ X"${TSP_HOST_TYPE}" = X"HOST" ] || [ X"${TSP_HOST_TYPE}" = X"ROUTER" ]; then
    #
@@ -103,7 +102,7 @@
       Exec $ifconfig $TSP_TUNNEL_INTERFACE destroy
    fi
    Exec $ifconfig $TSP_TUNNEL_INTERFACE create
-   Exec $gifconfig $TSP_TUNNEL_INTERFACE $TSP_CLIENT_ADDRESS_IPV4 $TSP_SERVER_ADDRESS_IPV4
+   Exec $ifconfig $TSP_TUNNEL_INTERFACE tunnel $TSP_CLIENT_ADDRESS_IPV4 $TSP_SERVER_ADDRESS_IPV4
 
    #
    # Configured tunnel config (IPv6) 
@@ -117,6 +116,9 @@
    # Delete any default IPv6 route first
    ExecNoCheck $route delete -inet6 default
    Exec $route add -inet6 default $TSP_SERVER_ADDRESS_IPV6
+
+   # Save interface for later
+   echo $TSP_TUNNEL_INTERFACE > /var/run/tspc.if
 fi
 
 # Router configuration if required
