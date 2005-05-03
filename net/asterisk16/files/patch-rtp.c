--- rtp.c.orig	Tue Apr 26 10:00:28 2005
+++ rtp.c	Tue Apr 26 10:06:35 2005
@@ -127,7 +127,7 @@
 {
 	switch(buf & TYPE_MASK) {
 	case TYPE_DONTSEND:
-		return 0;
+		return 2;
 		break;
 	case TYPE_SILENCE:
 		return 4;
@@ -351,9 +351,7 @@
 					0, (struct sockaddr *)&sin, &len);
 	
 	if (res < 0) {
-		if (errno == EAGAIN)
-			ast_log(LOG_NOTICE, "RTP: Received packet with bad UDP checksum\n");
-		else
+		if (errno != EAGAIN)
 			ast_log(LOG_WARNING, "RTP Read error: %s\n", strerror(errno));
 		if (errno == EBADF)
 			CRASH;
@@ -431,9 +429,7 @@
 
 	rtpheader = (unsigned int *)(rtp->rawdata + AST_FRIENDLY_OFFSET);
 	if (res < 0) {
-		if (errno == EAGAIN)
-			ast_log(LOG_NOTICE, "RTP: Received packet with bad UDP checksum\n");
-		else
+		if (errno != EAGAIN)
 			ast_log(LOG_WARNING, "RTP Read error: %s\n", strerror(errno));
 		if (errno == EBADF)
 			CRASH;
@@ -862,8 +858,10 @@
 		/* Must be an even port number by RTP spec */
 		rtp->us.sin_port = htons(x);
 		rtp->us.sin_addr = addr;
-		if (rtp->rtcp)
+		if (rtp->rtcp) {
 			rtp->rtcp->us.sin_port = htons(x + 1);
+			rtp->rtcp->us.sin_addr = addr;
+		}
 		if (!(first = bind(rtp->s, (struct sockaddr *)&rtp->us, sizeof(rtp->us))) &&
 			(!rtp->rtcp || !bind(rtp->rtcp->s, (struct sockaddr *)&rtp->rtcp->us, sizeof(rtp->rtcp->us))))
 			break;
