--- buhg/smesh.c.orig	Wed Oct  8 19:54:03 2003
+++ buhg/smesh.c	Wed Oct  8 19:54:10 2003
@@ -23,7 +23,7 @@
 long		kolstr;
 SQL_str         row,row1;
 char		strsql[300];
-long		vrem;
+time_t		vrem;
 
 clear(); /*�������� ����� � ��������� ������� ������*/
 VVOD VVOD1(2);
