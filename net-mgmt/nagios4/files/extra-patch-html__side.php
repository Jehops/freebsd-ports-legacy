--- html/side.php.orig	2014-08-12 15:00:01 UTC
+++ html/side.php
@@ -56,8 +56,8 @@ $link_target = 'main';
 			<li>
 				<a href="<?php echo $cfg["cgi_base_url"];?>/status.cgi?host=all&amp;servicestatustypes=28" target="<?php echo $link_target;?>">Problems</a>
 				<ul>
-					<li><a href="<?php echo $cfg["cgi_base_url"];?>/status.cgi?host=all&amp;servicestatustypes=28" target="<?php echo $link_target;?>">Services</a> (<a href="<?php echo $cfg["cgi_base_url"];?>/status.cgi?host=all&amp;type=detail&amp;hoststatustypes=3&amp;serviceprops=42&amp;servicestatustypes=28" target="<?php echo $link_target;?>">Unhandled</a>)</li>
-					<li><a href="<?php echo $cfg["cgi_base_url"];?>/status.cgi?hostgroup=all&amp;style=hostdetail&amp;hoststatustypes=12" target="<?php echo $link_target;?>">Hosts</a> (<a href="<?php echo $cfg["cgi_base_url"];?>/status.cgi?hostgroup=all&amp;style=hostdetail&amp;hoststatustypes=12&amp;hostprops=42" target="<?php echo $link_target;?>">Unhandled</a>)</li>
+					<li><a href="<?php echo $cfg["cgi_base_url"];?>/status.cgi?host=all&amp;servicestatustypes=28" target="<?php echo $link_target;?>">Services</a> (<a href="<?php echo $cfg["cgi_base_url"];?>/status.cgi?host=all&amp;type=detail&amp;hoststatustypes=3&amp;serviceprops=10&amp;servicestatustypes=28" target="<?php echo $link_target;?>">Unhandled</a>)</li>
+					<li><a href="<?php echo $cfg["cgi_base_url"];?>/status.cgi?hostgroup=all&amp;style=hostdetail&amp;hoststatustypes=12" target="<?php echo $link_target;?>">Hosts</a> (<a href="<?php echo $cfg["cgi_base_url"];?>/status.cgi?hostgroup=all&amp;style=hostdetail&amp;hoststatustypes=12&amp;hostprops=10" target="<?php echo $link_target;?>">Unhandled</a>)</li>
 					<li><a href="<?php echo $cfg["cgi_base_url"];?>/outages.cgi" target="<?php echo $link_target;?>">Network Outages</a></li>
 				</ul>
 			</li>
