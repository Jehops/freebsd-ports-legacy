--- src/mainwin.cpp.orig	Thu Nov 24 08:38:33 2005
+++ src/mainwin.cpp	Wed Jan 18 03:09:52 2006
@@ -1604,10 +1604,10 @@
       //set the params of "who command"
 	if ((whoBox1->currentItem() >1)  || (whoBox2->currentItem() >1))
         {
-		wparam.append(whoBox1->currentItem()==1 ? "9p" : whoBox1->currentText());
+		wparam.append(whoBox1->currentItem()==1 ? QString("9p") : whoBox1->currentText());
 		if ((whoBox1->currentItem())  && (whoBox2->currentItem()))
 			wparam.append("-");
-		wparam.append(whoBox2->currentItem()==1 ? "9p" : whoBox2->currentText());
+		wparam.append(whoBox2->currentItem()==1 ? QString("9p") : whoBox2->currentText());
          } 
 	else if ((whoBox1->currentItem())  || (whoBox2->currentItem()))
         	wparam.append("1p-9p");
