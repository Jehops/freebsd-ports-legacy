--- tools/wafadmin/Node.py.orig	2010-10-25 05:45:39.000000000 +0800
+++ tools/wafadmin/Node.py	2010-10-27 18:30:12.000000000 +0800
@@ -349,6 +349,12 @@
 		if self == from_node: return '.'
 		if from_node.parent == self: return '..'
 
+		from_node_path = from_node.abspath()
+		from_node_realpath = os.path.realpath(from_node_path)
+		if from_node_path != from_node_realpath:
+			from_node = self.__class__.bld.root.find_dir(from_node_realpath)
+			return self.relpath_gen(from_node)
+
 		# up_path is '../../../' and down_path is 'dir/subdir/subdir/file'
 		ancestor = self.find_ancestor(from_node)
 		lst = []
