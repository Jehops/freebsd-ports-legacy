--- third_party/blink/renderer/core/exported/web_frame_test.cc.orig	2020-09-08 19:14:10 UTC
+++ third_party/blink/renderer/core/exported/web_frame_test.cc
@@ -5977,7 +5977,7 @@ TEST_F(WebFrameTest, DISABLED_PositionForPointTest) {
   EXPECT_EQ(64, ComputeOffset(layout_object, 1000, 1000));
 }
 
-#if !defined(OS_MACOSX) && !defined(OS_LINUX)
+#if !defined(OS_MACOSX) && !defined(OS_LINUX) && !defined(OS_BSD)
 TEST_F(WebFrameTest, SelectRangeStaysHorizontallyAlignedWhenMoved) {
   RegisterMockedHttpURLLoad("move_caret.html");
 
@@ -6310,7 +6310,7 @@ TEST_F(CompositedSelectionBoundsTest, Editable) {
 TEST_F(CompositedSelectionBoundsTest, EditableDiv) {
   RunTest("composited_selection_bounds_editable_div.html");
 }
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) || defined(OS_BSD)
 #if !defined(OS_ANDROID)
 TEST_F(CompositedSelectionBoundsTest, Input) {
   RunTest("composited_selection_bounds_input.html");
