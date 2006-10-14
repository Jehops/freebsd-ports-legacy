--- xttmgr.c.orig	Sat Oct  7 11:34:31 2006
+++ xttmgr.c	Sat Oct  7 11:34:10 2006
@@ -7,7 +7,6 @@
 #include <ft2build.h>
 #include FT_FREETYPE_H
 #include FT_MODULE_H
-#include FT_INTERNAL_OBJECTS_H
 #include FT_TRUETYPE_IDS_H
 #include FT_TRUETYPE_TABLES_H
 #include FT_SFNT_NAMES_H
@@ -269,7 +268,7 @@ int main( int argc, char *argv[] )
 static int Check_Font_Face( char *filename )
 {
        FT_Face face;
-       FT_ModuleRec*  module;
+       int is_sfnt = 0;
 
        num_faces = 0; /* ���N face �`�Ƴ]�� 0 */
 
@@ -278,16 +277,12 @@ static int Check_Font_Face( char *filena
           return 1;
        }
 
-       module = &face->driver->root;
        num_faces = face->num_faces; /* �����@���h�֭� faces */
+       is_sfnt = FT_IS_SFNT( face );
        FT_Done_Face( face );
 
        /* �ˬd���ɮ׬O�_�O TrueType �� */
-       if ( strncasecmp( module->clazz->module_name, "TrueType", 8 ) ) {
-          return 1;
-       }
-
-       return 0;
+       return is_sfnt;
 
 }
 
@@ -1305,7 +1300,6 @@ static int Font_Info( char *filename )
     FT_ULong   face_idx;
     FT_Int     pos, num_encodings;
     FT_CharMap charmap;
-    FT_ModuleRec*  module;
     TT_OS2     *os2;
     FT_UShort  platform_id, encoding_id;
     char       *platform_name=NULL;
@@ -1366,8 +1360,8 @@ static int Font_Info( char *filename )
 	printf( "Number of glyphs : %ld\n", face->num_glyphs ); 
 	printf( "..........................................\n\n" );
 
-	module = &face->driver->root;
-	printf( "�ҲզW�� : %s\n", module->clazz->module_name );
+	/*module = &face->driver->root;
+	printf( "�ҲզW�� : %s\n", module->clazz->module_name );*/
 
 	printf( "\nFace flags :\n" );
 
