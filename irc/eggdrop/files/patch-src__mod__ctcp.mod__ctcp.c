--- src/mod/ctcp.mod/ctcp.c.orig	Mon Jun  2 11:27:58 2003
+++ src/mod/ctcp.mod/ctcp.c	Mon Jun  2 11:29:29 2003
@@ -161,8 +161,8 @@
         /* Do me a favour and don't change this back to a CTCP reply,
          * CTCP replies are NOTICE's this has to be a PRIVMSG
          * -poptix 5/1/1997 */
-        dprintf(DP_SERVER, "PRIVMSG %s :\001DCC CHAT chat %lu %u\001\n",
-                nick, iptolong(natip[0] ? (IP) inet_addr(natip) : getmyip()),
+        dprintf(DP_SERVER, "PRIVMSG %s :\001DCC CHAT chat %u %u\001\n",
+                nick, (unsigned)iptolong(natip[0] ? (IP) inet_addr(natip) : getmyip()),
                 dcc[i].port);
         return 1;
       }
