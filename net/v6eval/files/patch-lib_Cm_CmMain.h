--- lib/Cm/CmMain.h.orig	2013-06-16 10:53:42.000000000 +0900
+++ lib/Cm/CmMain.h	2013-06-16 10:54:05.000000000 +0900
@@ -100,7 +100,7 @@
 // ��ư���� �ץ����̾ STARTED by ��ư�桼��@��ư�ޥ��� on
 // ttyname:������桼��̾ from ��⡼�ȥޥ���̾
 //----------------------------------------------------------------------
-struct CmMain {
+class CmMain {
 private:
 static	STR applicationName_;		// ��ư���ޥ��̾
 static	char catchStart_[256];		// �㳲���Ͼ���
