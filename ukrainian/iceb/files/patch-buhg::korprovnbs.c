--- buhg/korprovnbs.c.orig	Wed Oct  8 19:52:40 2003
+++ buhg/korprovnbs.c	Wed Oct  8 19:52:45 2003
@@ -18,7 +18,7 @@
 void            korprovnbs(VVOD *VV,short d,short m,short g, //����
 char sh[],  //����
 char kor[], //��� �����������
-long vrem,  //����� ������
+time_t vrem,  //����� ������
 int ktoi,
 char kto[])
 {
