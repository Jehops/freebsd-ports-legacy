--- handlers.c.orig	Mon Oct 20 10:27:32 2003
+++ handlers.c	Tue Oct 21 00:13:59 2003
@@ -24,6 +24,7 @@
 #endif
 
 extern char cgiRoot[MAX_PATH_LEN+1]; /* root for CGI scripts exec */
+extern char homePath[MAX_PATH_LEN+1]; /* root for PHP scripts exec */
 extern int port;                     /* server port */
 extern char defaultFileName[MAX_PATH_LEN+1]; /* default name for index, default or similar file */
 
@@ -263,6 +264,14 @@
         
         i = 0;
 	/* beware of not overfilling this array, check MAX_ENVP_LEN */
+        if (req.contentLength != -1)
+        {
+            sprintf(newEnvp[i++], "CONTENT_LENGTH=%ld", req.contentLength);
+            strcpy(newEnvp[i], "CONTENT_TYPE=");
+            strcat(newEnvp[i++], req.contentType);
+        }
+        strcpy(newEnvp[i], "SERVER_NAME=");
+        strcat(newEnvp[i++], DEFAULT_SERVER_NAME);
         strcpy(newEnvp[i], "SERVER_SOFTWARE=");
         strcat(newEnvp[i], SERVER_SOFTWARE_STR);
         strcat(newEnvp[i], "/");
@@ -285,6 +294,11 @@
 	strcat(newEnvp[i++], req.userAgent);
 	strcpy(newEnvp[i], "SCRIPT_FILENAME=");
 	strcat(newEnvp[i++], completedPath);
+        if (req.cookie[0] != '\0')
+        {
+            strcpy(newEnvp[i], "HTTP_COOKIE=");
+            strcat(newEnvp[i++], req.cookie);
+        }
         newEnvp[i] = NULL;
         
         /* we change the current working directory to the scripts one */
@@ -317,7 +331,244 @@
     return 0;
 }
 
-int dumpHeader(sock, filePath, mimeType, req)
+
+#ifdef PHP
+int phpHandler(port, sock, phpFileName, completedPath, req, postStr)
+int port;
+int sock;
+char *phpFileName;
+char *completedPath;
+struct request req;
+char *postStr;
+{
+    char envPath[MAX_PATH_LEN+1]; /* where to hold the envrion PATH parameter */
+    char *relativePath;
+    char scriptWorkingDir[MAX_PATH_LEN+1];
+    char **newArgv;
+    char **newEnvp;
+    int i;
+    int outStdPipe[2]; /* we will redirect the script output to a pipe so we can read it */
+    int inStdPipe[2];  /* we will redirect the script input to a pipe so we can read it */
+    int pid;           /* we fork and execute inside the child the script */
+    char pipeReadBuf[PIPE_READ_BUF+1];
+    int howMany;
+    int totalSentFromPipe; /* ampunt of bytes sucked from the pipe and pushed in to the socket */
+    int fatal;
+
+    relativePath = strrchr(completedPath, '/');
+    strncpy(scriptWorkingDir, completedPath, strlen(completedPath) - strlen(relativePath));
+    scriptWorkingDir[strlen(completedPath) - strlen(relativePath)] = '\0';
+
+    /* first we create the pipes needed for stdout redirection */
+    if (pipe(outStdPipe))
+    {
+#ifdef PRINTF_DEBUG
+        printf("Pipe creation error\n");
+        return -1;
+#endif
+    }
+    if (pipe(inStdPipe))
+    {
+#ifdef PRINTF_DEBUG
+        printf("Pipe creation error\n");
+        return -1;
+#endif
+    }
+
+
+    /* now we fork to subsequently execve */
+    pid = fork();
+    if (pid)
+    { /* this is the parent process */
+        if (pid < 0)
+        { /* we check for creation error */
+            printf ("Forking error during cgi exec: %d\n", errno);
+            return -1;
+        }
+        /* we close the unused end of the pipe */
+        close(outStdPipe[WRITE]);
+        close(inStdPipe[READ]);
+
+        if (!strcmp(req.method, "POST")) /* we have to feed the stdin of the script */
+        {
+            if(!strlen(postStr))
+            {
+#ifdef PRINTF_DEBUG
+                printf("cannot post empty data\n");
+#endif
+                return -1;
+            }
+            howMany = write(inStdPipe[WRITE], postStr, strlen(postStr));
+            if (howMany < 0)
+                printf("Error during script pipe read.\n");
+        }
+        totalSentFromPipe = 0;
+        fatal = NO;
+        howMany = 1;
+        while (howMany > 0 && !fatal)
+        {
+            howMany = read(outStdPipe[READ], &pipeReadBuf, PIPE_READ_BUF);
+            if (howMany < 0)
+                printf("Error during script pipe read.\n");
+            else if (!howMany)
+                printf("Nothing read from script pipe.\n");
+            else {
+                pipeReadBuf[howMany] = '\0';
+                if (send(sock, pipeReadBuf, howMany, 0) < 0)
+                {
+                    printf("error during CGI sock writing! %d\n", errno);
+                    if (errno == EAGAIN)
+                        printf("output resource temporarily not available\n");
+                    else if (errno == EPIPE)
+                    {
+                        printf("broken pipe during CGI out.\n");
+                        fatal = YES;
+                    } else if (errno == EBADF)
+                    {
+#ifdef PRINTF_DEBUG
+                        printf("invalid out descriptor.\n");
+#endif
+                        fatal = YES;
+                    }
+                } else
+                    totalSentFromPipe += howMany;
+            }
+        }
+        /* now we finished and we clean up */
+        wait(&i);
+        if (i) /* check if execution exited cleanly or with code */
+            logWriter(LOG_CGI_FAILURE, NULL, 0, req, i);
+        else
+            logWriter(LOG_CGI_SUCCESS, NULL, totalSentFromPipe, req, 0);
+        close(outStdPipe[READ]);
+        close(inStdPipe[WRITE]);
+    } else
+    { /* this is the child process */
+        /* now we do some environment setup work */
+        newArgv = calloc(MAX_ARGV_LEN + 1, sizeof(char*));
+        for (i = 0; i < MAX_ARGV_LEN + 1; i++)
+        {
+            newArgv[i] = calloc(MAX_PATH_LEN, sizeof(char));
+        }
+
+        newEnvp = calloc(MAX_ENVP_LEN + 1, sizeof(char*));
+        for (i = 0; i < MAX_ENVP_LEN + 1; i++)
+        {
+            newEnvp[i] = calloc(MAX_PATH_LEN, sizeof(char));
+        }
+
+
+
+        /* extracting PATH env variable */
+        i = 0;
+        while (environ && strncmp(environ[i], PATH_MATCH_STRING, strlen(PATH_MATCH_STRING)))
+            i++;
+        if(environ[i])
+            strcpy(envPath, environ[i]);
+        else
+            envPath[0] = '\0'; /* maybe we should set some default? */
+
+        i = 0;
+        strcpy(newArgv[i++], phpFileName);     /* here we should pass the phppath */
+        strcpy(newArgv[i++], completedPath);  /* here we should pass the scriptpath */
+        if (strlen(req.queryString))
+        {
+            int toParse;
+            int j, k;
+
+            toParse = YES;
+            j = strlen(req.queryString);
+            while (toParse && j > 0)
+            {
+                if (req.queryString[j] == '=')
+                    toParse = NO;
+                j--;
+            }
+            if (toParse)
+            {
+                j = 0;
+                k = 0;
+                howMany = strlen(req.queryString);
+                while (j < howMany)
+                {
+                    if (req.queryString[j] == '+')
+                    {
+                        newArgv[i++][k] = '\0';
+                        k = 0;
+                    } else
+                        newArgv[i][k++] = req.queryString[j];
+                    j++;
+                }
+                i++; /* after all we will have at least one argument! */
+            }
+        }
+        newArgv[i] = NULL; /* we correctly terminate argv */
+
+        i = 0;
+        strcpy(newEnvp[i], "SERVER_NAME=");
+        strcat(newEnvp[i++], DEFAULT_SERVER_NAME);
+        strcpy(newEnvp[i], "SERVER_SOFTWARE=");
+        strcat(newEnvp[i], SERVER_SOFTWARE_STR);
+        strcat(newEnvp[i], "/");
+        strcat(newEnvp[i++], SERVER_VERSION_STR);
+        strcpy(newEnvp[i], "REQUEST_METHOD=");
+        strcat(newEnvp[i++], req.method);
+        strcpy(newEnvp[i], "SCRIPT_NAME=");
+        strcat(newEnvp[i++], req.documentAddress);
+        strcpy(newEnvp[i], "GATEWAY_INTERFACE=");
+        strcat(newEnvp[i++], CGI_VERSION);
+        sprintf(newEnvp[i++], "SERVER_PORT=%d", port);
+        strcpy(newEnvp[i++], envPath);
+        strcpy(newEnvp[i], "QUERY_STRING=");
+        strcat(newEnvp[i++], req.queryString);
+        strcpy(newEnvp[i], "SERVER_PROTOCOL=");
+        strcat(newEnvp[i++], req.protocolVersion);
+        strcpy(newEnvp[i], "REMOTE_ADDR=");
+        strcat(newEnvp[i++], req.address);
+        strcpy(newEnvp[i], "HTTP_USER_AGENT=");
+        strcat(newEnvp[i++], req.userAgent);
+        strcpy(newEnvp[i], "SCRIPT_FILENAME=");
+        strcat(newEnvp[i++], completedPath);
+        if (req.cookie[0] != '\0')
+        {
+            strcpy(newEnvp[i], "HTTP_COOKIE=");
+            strcat(newEnvp[i++], req.cookie);
+        }
+        newEnvp[i] = NULL;
+
+        /* we change the current working directory to the scripts one */
+        if(chdir(scriptWorkingDir))
+        {
+#ifdef PRINTF_DEBUG
+            printf("error while changing PWD in script execution: %d\n", errno);
+#endif
+        }
+
+        close(outStdPipe[READ]);    /* we close the unused end*/
+        dup2(outStdPipe[WRITE], 1); /* we duplicate the pipe to the stdout */
+        close(outStdPipe[WRITE]);   /* we close the pipe, since we use the duplicate */
+
+        close(inStdPipe[WRITE]);    /* we close the unused end*/
+        dup2(inStdPipe[READ], 0);   /* we duplicate the pipe to the stdin */
+        close(inStdPipe[READ]);     /* we close the pipe, since we use the duplicate */
+
+
+        /* generate a reduced mimeHeader, no type, no size, etc */
+        generateMimeHeader(sock, 200, "", NULL, req.protocolVersion, CGI_ONLY_HEADER);
+
+        /* now we execute the script replacing the current child */
+        execve(phpFileName, newArgv, newEnvp);
+        /* we reach this line only if an execution error occoured */
+        /* logging will happen in the father */
+        printf("\n<HTML><HEAD><TITLE>PHP Error</TITLE></HEAD><BODY><H1>PHP Exec error</H1></BODY></HTML>\n");
+        exit(-1);
+    }
+    return 0;
+}
+#endif
+
+int dumpHeader(port, sock, filePath, mimeType, req)
+int port;
 int sock;
 char filePath[];
 char mimeType[];
@@ -360,11 +611,11 @@
         return -1;
     }
     stat(filePath, &fileStats);
-    generateMimeHeader(sock, 200, mimeType, &fileStats, req.protocolVersion, FULL_HEADER);
-    logWriter(LOG_GET_SUCCESS, req.documentAddress, (long int)fileStats.st_size, req, 0);
     howMany = 0;
     if (strncmp(mimeType, "text", 4)) /* check if it is a text type */
     {   /* raw binary output routine */
+        generateMimeHeader(sock, 200, mimeType, &fileStats, req.protocolVersion, FULL_HEADER);
+        logWriter(LOG_GET_SUCCESS, req.documentAddress, (long int)fileStats.st_size, req, 0);
         fatal = NO;
         retry = NO;
         while(!feof(inFile) && !fatal)
@@ -408,11 +659,11 @@
             if (howMany > 0)
             {
 #ifdef ON_THE_FLY_CONVERSION
-		 {
-		     int i;
-		     for (i = 0; i < howMany; i++)
-		         if(outBuff[i] == '\r') outBuff[i] = '\n';
-		 }
+                 {
+                     int i;
+                     for (i = 0; i < howMany; i++)
+                         if(outBuff[i] == '\r') outBuff[i] = '\n';
+                 }
 #endif
                 if (send(sock, outBuff, howMany, 0) < 0)
                 {
