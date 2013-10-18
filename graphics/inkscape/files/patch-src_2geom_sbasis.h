--- src/2geom/sbasis.h.orig	2013-10-16 23:20:03.000000000 +0200
+++ src/2geom/sbasis.h	2013-10-16 23:27:50.000000000 +0200
@@ -75,10 +75,13 @@
         return d[i];
     }
     Linear& operator[](unsigned i) { return d.at(i); }
-    Linear const* begin() const { return (Linear const*)&*d.begin();}
-    Linear const* end() const { return (Linear const*)&*d.end();}
-    Linear* begin() { return (Linear*)&*d.begin();}
-    Linear* end() { return (Linear*)&*d.end();}
+
+    std::vector<Linear>::const_iterator begin() const { return d.begin(); }
+    std::vector<Linear>::const_iterator end() const { return d.end(); }
+
+    std::vector<Linear>::iterator begin() { return d.begin(); }
+    std::vector<Linear>::iterator end() { return d.end(); }
+
     bool empty() const {return d.empty();}
     Linear &back() {return d.back();}
     Linear const &back() const {return d.back();}
@@ -87,7 +90,11 @@
     void resize(unsigned n, Linear const& l) { d.resize(n, l);}
     void reserve(unsigned n) { d.reserve(n);}
     void clear() {d.clear();}
-    void insert(Linear* before, const Linear* src_begin, const Linear* src_end) { d.insert(std::vector<Linear>::iterator(before), src_begin, src_end);}
+
+    void insert(std::vector<Linear>::iterator before, std::vector<Linear>::const_iterator src_begin, std::vector<Linear>::const_iterator src_end) {
+               d.insert(before, src_begin, src_end);
+    }
+
     //void insert(Linear* aa, Linear* bb, Linear* cc} { d.insert(aa, bb, cc);}
     Linear& at(unsigned i) { return d.at(i);}
     //void insert(Linear* before, int& n, Linear const &l) { d.insert(std::vector<Linear>::iterator(before), n, l);}
@@ -283,7 +290,12 @@
 
 inline SBasis truncate(SBasis const &a, unsigned terms) {
     SBasis c;
-    c.insert(c.begin(), a.begin(), a.begin() + std::min(terms, (unsigned)a.size()));
+
+    std::vector<Linear>::const_iterator e = a.begin();
+    std::advance(e, std::min(terms, (unsigned)a.size()));
+
+    c.insert(c.begin(), a.begin(), e);
+
     return c;
 }
 
