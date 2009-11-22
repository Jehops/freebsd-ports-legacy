--- src/storage.cpp.orig	2009-11-06 09:45:13.000000000 -0800
+++ src/storage.cpp	2009-11-21 23:12:53.000000000 -0800
@@ -53,7 +53,7 @@
 #include <boost/multi_index_container.hpp>
 #include <boost/multi_index/member.hpp>
 #include <boost/multi_index/ordered_index.hpp>
-#if BOOST_VERSION >= 103500
+#if 0 // BOOST_VERSION >= 103500
 #include <boost/system/system_error.hpp>
 #endif
 
@@ -185,15 +185,15 @@
 		}
 #ifndef BOOST_NO_EXCEPTIONS
 		}
-#if BOOST_VERSION >= 103500
+#if 0 // BOOST_VERSION >= 103500
 		catch (boost::system::system_error& e)
 		{
 			ec = e.code();
 		}
 #else
-		catch (boost::filesystem::filesystem_error& e)
+		catch (std::exception& e)
 		{
-			ec = error_code(e.system_error(), get_system_category());
+			ec = error_code(errno, get_posix_category());
 		}
 #endif // BOOST_VERSION
 #endif // BOOST_NO_EXCEPTIONS
@@ -460,17 +460,17 @@
 			}
 #ifndef BOOST_NO_EXCEPTIONS
 			}
-#if BOOST_VERSION >= 103500
+#if 0 // BOOST_VERSION >= 103500
 			catch (boost::system::system_error& e)
 			{
 				set_error(m_save_path / file_iter->path, e.code());
 				return true;
 			}
 #else
-			catch (boost::filesystem::filesystem_error& e)
+			catch (std::exception& e)
 			{
 				set_error(m_save_path / file_iter->path
-					, error_code(e.system_error(), get_system_category()));
+					, error_code(errno, get_posix_category()));
 				return true;
 			}
 #endif // BOOST_VERSION
@@ -503,16 +503,16 @@
 #endif
 #ifndef BOOST_NO_EXCEPTIONS
 			}
-#if BOOST_VERSION >= 103500
+#if 0 // BOOST_VERSION >= 103500
 			catch (boost::system::system_error& e)
 			{
 				set_error(f, e.code());
 				return false;
 			}
 #else
-			catch (boost::filesystem::filesystem_error& e)
+			catch (std::exception& e)
 			{
-				set_error(f, error_code(e.system_error(), get_system_category()));
+				set_error(f, error_code(errno, get_posix_category()));
 				return false;
 			}
 #endif // BOOST_VERSION
@@ -560,17 +560,17 @@
 			m_mapped_files->rename_file(index, new_filename);
 #ifndef BOOST_NO_EXCEPTIONS
 		}
-#if BOOST_VERSION >= 103500
+#if 0 // BOOST_VERSION >= 103500
 		catch (boost::system::system_error& e)
 		{
 			set_error(old_name, e.code());
 			return true;
 		}
 #else
-		catch (boost::filesystem::filesystem_error& e)
+		catch (std::exception& e)
 		{
-			set_error(old_name, error_code(e.system_error()
-				, get_system_category()));
+			set_error(old_name, error_code(errno
+				, get_posix_category()));
 			return true;
 		}
 #endif // BOOST_VERSION
@@ -593,7 +593,7 @@
 #endif
 		{ fs::remove(safe_convert(p)); }
 #ifndef BOOST_NO_EXCEPTIONS
-#if BOOST_VERSION >= 103500
+#if 0 // BOOST_VERSION >= 103500
 		catch (boost::system::system_error& e)
 		{
 			// no such file or directory is not an error
@@ -601,9 +601,9 @@
 				set_error(p, e.code());
 		}
 #else
-		catch (boost::filesystem::filesystem_error& e)
+		catch (std::exception& e)
 		{
-			set_error(p, error_code(e.system_error(), get_system_category()));
+			set_error(p, errno, get_posix_category()));
 		}
 #endif // BOOST_VERSION
 #endif // BOOST_NO_EXCEPTIONS
