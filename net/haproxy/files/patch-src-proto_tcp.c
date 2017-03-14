From afbf56b951967e8fa4d509e423fdcb11c27d40e2 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Tue, 14 Mar 2017 20:19:29 +0100
Subject: BUG/MAJOR: connection: update CO_FL_CONNECTED before calling the
 data layer

Matthias Fechner reported a regression in 1.7.3 brought by the backport
of commit 819efbf ("BUG/MEDIUM: tcp: don't poll for write when connect()
succeeds"), causing some connections to fail to establish once in a while.
While this commit itself was a fix for a bad sequencing of connection
events, it in fact unveiled a much deeper bug going back to the connection
rework era in v1.5-dev12 : 8f8c92f ("MAJOR: connection: add a new
CO_FL_CONNECTED flag").

It's worth noting that in a lab reproducing a similar environment as
Matthias' about only 1 every 19000 connections exhibit this behaviour,
making the issue not so easy to observe. A trick to make the problem
more observable consists in disabling non-blocking mode on the socket
before calling connect() and re-enabling it later, so that connect()
always succeeds. Then it becomes 100% reproducible.

The problem is that this CO_FL_CONNECTED flag is tested after deciding to
call the data layer (typically the stream interface but might be a health
check as well), and that the decision to call the data layer relies on a
change of one of the flags covered by the CO_FL_CONN_STATE set, which is
made of CO_FL_CONNECTED among others.

Before the fix above, this bug couldn't appear with TCP but it could
appear with Unix sockets. Indeed, connect() was always considered
blocking so the CO_FL_WAIT_L4_CONN connection flag was always set, and
polling for write events was always enabled. This used to guarantee that
the conn_fd_handler() could detect a change among the CO_FL_CONN_STATE
flags.

Now with the fix above, if a connect() immediately succeeds for non-ssl
connection with send-proxy enabled, and no data in the buffer (thus TCP
mode only), the CO_FL_WAIT_L4_CONN flag is not set, the lack of data in
the buffer doesn't enable polling flags for the data layer, the
CO_FL_CONNECTED flag is not set due to send-proxy still being pending,
and once send-proxy is done, its completion doesn't cause the data layer
to be woken up due to the fact that CO_FL_CONNECT is still not present
and that the CO_FL_SEND_PROXY flag is not watched in CO_FL_CONN_STATE.

Then no progress is made when data are received from the client (and
attempted to be forwarded), because a CF_WRITE_NULL (or CF_WRITE_PARTIAL)
flag is needed for the stream-interface state to turn from SI_ST_CON to
SI_ST_EST, allowing ->chk_snd() to be called when new data arrive. And
the only way to set this flag is to call the data layer of course.

After the connect timeout, the connection gets killed and if in the mean
time some data have accumulated in the buffer, the retry will succeed.

This patch fixes this situation by simply placing the update of
CO_FL_CONNECTED where it should have been, before the check for a flag
change needed to wake up the data layer and not after.

This fix must be backported to 1.7, 1.6 and 1.5. Versions not having
the patch above are still affected for unix sockets.

Special thanks to Matthias Fechner who provided a very detailed bug
report with a bisection designating the faulty patch, and to Olivier
Houchard for providing full access to a pretty similar environment where
the issue could first be reproduced.
(cherry picked from commit 7bf3fa3c23f6a1b7ed1212783507ac50f7e27544)
---
 src/connection.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/connection.c b/src/connection.c
index 26fc5f6..1e4c9aa 100644
--- src/connection.c
+++ src/connection.c
@@ -131,6 +131,13 @@ void conn_fd_handler(int fd)
 	}
 
  leave:
+	/* Verify if the connection just established. The CO_FL_CONNECTED flag
+	 * being included in CO_FL_CONN_STATE, its change will be noticed by
+	 * the next block and be used to wake up the data layer.
+	 */
+	if (unlikely(!(conn->flags & (CO_FL_WAIT_L4_CONN | CO_FL_WAIT_L6_CONN | CO_FL_CONNECTED))))
+		conn->flags |= CO_FL_CONNECTED;
+
 	/* The wake callback may be used to process a critical error and abort the
 	 * connection. If so, we don't want to go further as the connection will
 	 * have been released and the FD destroyed.
@@ -140,10 +147,6 @@ void conn_fd_handler(int fd)
 	    conn->data->wake(conn) < 0)
 		return;
 
-	/* Last check, verify if the connection just established */
-	if (unlikely(!(conn->flags & (CO_FL_WAIT_L4_CONN | CO_FL_WAIT_L6_CONN | CO_FL_CONNECTED))))
-		conn->flags |= CO_FL_CONNECTED;
-
 	/* remove the events before leaving */
 	fdtab[fd].ev &= FD_POLL_STICKY;
 
-- 
1.7.12.1

