--- ListView.cpp.orig	Wed Feb 17 09:17:11 1999
+++ ListView.cpp	Wed Feb 17 09:21:00 1999
@@ -383,11 +383,11 @@
 	if (item != NULL)
 		temp = item;
 
-	lbl = new QLabel("�q�P:",this);
+	lbl = new QLabel("Artist:",this);
 	topLayout->addWidget(lbl,0,0);
-	lbl = new QLabel("�M��W��:",this);
+	lbl = new QLabel("Album:",this);
 	topLayout->addWidget(lbl,1,0);
-	lbl = new QLabel("�o�椽�q:",this);
+	lbl = new QLabel("Company:",this);
 	topLayout->addWidget(lbl,2,0);
 
 	Title = new QLabel(this);
@@ -412,7 +412,7 @@
 	connect(btn,SIGNAL(clicked()),this,SLOT(RemoveSong()));
 	topLayout->addWidget(btn,4,1);
 
-	lbl = new QLabel("�q���W��:",this);
+	lbl = new QLabel("Title:",this);
 	topLayout->addWidget(lbl,4,2);
 
 	edtSinger = new QLineEdit(this);
