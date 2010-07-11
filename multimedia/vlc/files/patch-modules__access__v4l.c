--- modules/access/v4l.c.orig	Mon Jun 12 09:41:08 2006
+++ modules/access/v4l.c	Mon Jun 12 10:19:59 2006
@@ -555,7 +555,7 @@
         int i_noframe = -1;
         ioctl( p_sys->fd_video, MJPIOC_QBUF_CAPT, &i_noframe );
     }
-
+#if 0
     if( p_sys->p_video_mmap && p_sys->p_video_mmap != MAP_FAILED )
     {
         if( p_sys->b_mjpeg )
@@ -564,7 +564,7 @@
         else
             munmap( p_sys->p_video_mmap, p_sys->vid_mbuf.size );
     }
-
+#endif
     free( p_sys );
 }
 
@@ -1267,6 +1267,15 @@
     }
     else
     {
+        struct video_window vid_win = { 0 };
+        vid_win.width = p_sys->i_width;
+        vid_win.height = p_sys->i_height;
+        
+	if( ioctl( i_fd, VIDIOCSWIN, &vid_win ) < 0 )
+        {
+            msg_Err( p_demux, "cannot set win (%s)", strerror( errno ) );
+            goto vdev_failed;
+        }
         /* Fill in picture_t fields */
         vout_InitPicture( VLC_OBJECT(p_demux), &p_sys->pic, p_sys->i_fourcc,
                           p_sys->i_width, p_sys->i_height, p_sys->i_width *
@@ -1287,7 +1296,7 @@
                  p_sys->i_video_frame_size );
         msg_Dbg( p_demux, "v4l device uses chroma: %4.4s",
                 (char*)&p_sys->i_fourcc );
-
+#if 0
         /* Allocate mmap buffer */
         if( ioctl( i_fd, VIDIOCGMBUF, &p_sys->vid_mbuf ) < 0 )
         {
@@ -1316,6 +1325,7 @@
             msg_Err( p_demux, "chroma selection failed" );
             goto vdev_failed;
         }
+#endif
     }
     return i_fd;
 
@@ -1577,18 +1587,15 @@
         if( p_sys->i_video_pts + i_dur > mdate() ) return 0;
     }
 
-    if( p_sys->b_mjpeg ) p_frame = GrabMJPEG( p_demux );
-    else p_frame = GrabCapture( p_demux );
-
-    if( !p_frame ) return 0;
-
     if( !( p_block = block_New( p_demux, p_sys->i_video_frame_size ) ) )
     {
         msg_Warn( p_demux, "cannot get block" );
         return 0;
     }
 
-    memcpy( p_block->p_buffer, p_frame, p_sys->i_video_frame_size );
+    if(read(p_sys->i_fd, p_block->p_buffer, p_sys->i_video_frame_size) <= 0)
+	    return 0;
+    
     p_sys->i_video_pts = p_block->i_pts = p_block->i_dts = mdate();
 
     return p_block;
