--- libbuh/vprov1.c.orig	Wed Oct  8 18:57:11 2003
+++ libbuh/vprov1.c	Wed Oct  8 18:57:37 2003
@@ -24,7 +24,7 @@
 int skk,   //��� �������������
 int d,int m,int g, //���� ���������
 short mt, //0-���� 1-�������������
-long vremz, //����� ������ �������������� ��������
+time_t vremz, //����� ������ �������������� ��������
 char kontr[], //��� ����������� ��� �������������� �������� ���� �� ����
 int  ktozap,  //��� �������
 char mtsh[], //�������� ������������ ������
@@ -35,7 +35,7 @@
 {
 struct  tm      *bf;
 struct  passwd  *ktoz; /*��� �������*/
-long		vrem;
+time_t		vrem;
 int             KLST,MDLS;
 int             dlr;
 short           i,PR,K;
