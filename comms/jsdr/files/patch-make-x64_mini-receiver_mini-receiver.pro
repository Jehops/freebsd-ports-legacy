--- make-x64/mini-receiver/mini-receiver.pro.orig
+++ make-x64/mini-receiver/mini-receiver.pro
@@ -108,9 +108,16 @@ LIBS += -lstdc++
 #}
 
 #for fedora use the second set
-unix {  INCLUDEPATH += /usr/include/qwt
-	INCLUDEPATH += /usr/include/ 
-	LIBS+=  -lqwt -lusb-1.0 -lrt -lportaudio -lsndfile -lsamplerate -lfftw3 -ldl
+#unix {  INCLUDEPATH += /usr/include/qwt
+#	INCLUDEPATH += /usr/include/ 
+#	LIBS+=  -lqwt -lusb-1.0 -lrt -lportaudio -lsndfile -lsamplerate -lfftw3 -ldl
+#}
+
+#for FreeBSD use the third set
+unix {  INCLUDEPATH += ${LOCALBASE}/include/qwt
+	INCLUDEPATH += ${LOCALBASE}/include
+	QMAKE_LIBDIR += ${LOCALBASE}/lib
+	LIBS+=  -lqwt -lusb -lrt -lportaudio -lsndfile -lsamplerate -lfftw3
 }
 
 
