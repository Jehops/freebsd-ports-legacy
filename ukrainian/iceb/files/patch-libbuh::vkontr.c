--- libbuh/vkontr.c.orig	Wed Oct  8 18:56:28 2003
+++ libbuh/vkontr.c	Wed Oct  8 18:56:46 2003
@@ -21,7 +21,7 @@
 char kodp[], //��� �����������
 short mz,     /*0-������ ����� 1-������������*/
 int kt, /*��� �������*/
-long vr, /*����� ������*/
+time_t vr, /*����� ������*/
 VVOD *VV)
 {
 struct  tm      *bf;
@@ -31,7 +31,7 @@
 SQL_str         row;
 char		imaf[100];
 char		bros[100];
-long		vrem;
+time_t		vrem;
 char		kodz[20];
 char		naimz[60];
 char		strsql[500];
