/* -*- Mode: Java; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*-
 *
 * The contents of this file are subject to the Netscape Public
 * License Version 1.1 (the "License"); you may not use this file
 * except in compliance with the License. You may obtain a copy of
 * the License at http://www.mozilla.org/NPL/
 *
 * Software distributed under the License is distributed on an "AS
 * IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * rights and limitations under the License.
 *
 * The Original Code is mozilla.org code.
 *
 * The Initial Developer of the Original Code is Netscape
 * Communications Corporation.  Portions created by Netscape are
 * Copyright (C) 1998 Netscape Communications Corporation. All
 * Rights Reserved.
 *
 * Contributor(s):
 */

// SYNTAX HINTS:  dashes are delimiters.  Use underscores instead.
//  The first character after a period must be alphabetic.

pref("network.search.url","http://cgi.netscape.com/cgi-bin/url_search.cgi?search=");

pref("keyword.URL", "http://keyword.netscape.com/keyword/");
pref("keyword.enabled", true);
pref("general.useragent.locale", "chrome://navigator/locale/navigator.properties");
pref("general.useragent.misc", "rv:0.9");

pref("general.startup.browser",             true);
pref("general.startup.mail",                false);
pref("general.startup.news",                false);
pref("general.startup.editor",              false);
pref("general.startup.compose",             false);
pref("general.startup.addressbook",         false);

pref("general.open_location.last_url",      "");
pref("general.open_location.last_window_choice", 0);

// 0 = blank, 1 = home (browser.startup.homepage), 2 = last
pref("browser.startup.page",                1);
pref("browser.startup.homepage",	   "chrome://navigator-region/locale/region.properties");
// "browser.startup.homepage_override" was for 4.x
pref("browser.startup.homepage_override.1", true);
pref("browser.startup.autoload_homepage",   true);

pref("browser.cache.disk_cache_size",       7680);
pref("browser.cache.enable",                true);
pref("browser.cache.disk.enable",           true);
pref("browser.cache.memory_cache_size",     1024);
pref("browser.cache.disk_cache_ssl",        false);
pref("browser.cache.check_doc_frequency",   0);

pref("browser.display.use_document_fonts",  1);  // 0 = never, 1 = quick, 2 = always
pref("browser.display.use_document_colors", true);
pref("browser.display.use_system_colors",true);
pref("browser.display.foreground_color",    "#000000");
pref("browser.display.background_color",    "#C0C0C0");
pref("browser.anchor_color",                "#0000EE");
pref("browser.visited_color",               "#551A8B");
pref("browser.underline_anchors",           true);

pref("browser.display.use_focus_colors",    false);
pref("browser.display.focus_background_color", "#117722");
pref("browser.display.focus_text_color",     "#ffffff");
pref("browser.display.focus_ring_width",     1);
pref("browser.display.focus_ring_on_anything", false);

pref("browser.chrome.toolbar_tips",         true);
pref("browser.chrome.toolbar_style",        2);

pref("browser.toolbars.showbutton.bookmarks", true);
pref("browser.toolbars.showbutton.go",      false);
pref("browser.toolbars.showbutton.home",    true);
pref("browser.toolbars.showbutton.mynetscape", true);
pref("browser.toolbars.showbutton.net2phone", true);
pref("browser.toolbars.showbutton.print",   true);
pref("browser.toolbars.showbutton.search",  true);

pref("accessibility.browsewithcaret", false);
pref("accessibility.usetexttospeech", "");
pref("accessibility.usebrailledisplay", "");

// Dialog modality issues
pref("browser.prefWindowModal", true);
pref("browser.show_about_as_stupid_modal_window", false);

pref("browser.download.progressDnldDialog.keepAlive", false); // keep the dnload progress dialog up after dnload is complete

// various default search settings
pref("browser.search.defaulturl", "chrome://navigator-region/locale/region.properties");
pref("browser.search.opensidebarsearchpanel", true);
pref("browser.search.last_search_category", "NC:SearchCategory?category=urn:search:category:1");
pref("browser.search.mode", 0);
pref("browser.search.powermode", 0);
pref("browser.urlbar.autocomplete.enabled", true);
pref("browser.urlbar.clickSelectsAll",false);

pref("browser.history.last_page_visited", "");
pref("browser.history_expire_days", 9);
pref("browser.sessionhistory.max_entries", 50);

pref("browser.PICS.ratings_enabled", false);
pref("browser.PICS.pages_must_be_rated", false);
pref("browser.PICS.disable_for_this_session", false);
pref("browser.PICS.reenable_for_this_session", false);
pref("browser.PICS.service.http___home_netscape_com_default_rating.service_enabled", true);
pref("browser.PICS.service.http___home_netscape_com_default_rating.s", 0);

pref("browser.target_new_blocked", false);

// loading and rendering of framesets and iframes
pref("browser.frames.enabled", true);

// view source
pref("view_source.syntax_highlight", true);

// gfx widgets
pref("nglayout.widget.mode", 2);
pref("nglayout.widget.gfxscrollbars", true);

// use nsViewManager2
pref("nglayout.view.useViewManager2", true);

// css2 hover pref
pref("nglayout.events.showHierarchicalHover", false);

// whether or not to use xbl form controls
pref("nglayout.debug.enable_xbl_forms", false);

// Smart Browsing prefs
pref("browser.related.enabled", true);
pref("browser.related.autoload", 1);  // 0 = Always, 1 = After first use, 2 = Never
pref("browser.related.provider", "http://www-rl.netscape.com/wtgn?");
pref("browser.related.disabledForDomains", "");
pref("browser.goBrowsing.enabled", true);

//Internet Search
pref("browser.search.defaultenginename", "chrome://navigator/locale/navigator.properties");

// Default Capability Preferences: Security-Critical! 
// Editing these may create a security risk - be sure you know what you're doing
pref("capability.policy.default.barprop.visible.write", "UniversalBrowserWrite");

pref("capability.policy.default.domexception.code", "allAccess");
pref("capability.policy.default.domexception.message", "allAccess");
pref("capability.policy.default.domexception.name", "allAccess");
pref("capability.policy.default.domexception.result", "allAccess");
pref("capability.policy.default.domexception.tostring", "allAccess");

pref("capability.policy.default.history.current.read", "UniversalBrowserRead");
pref("capability.policy.default.history.next.read", "UniversalBrowserRead");
pref("capability.policy.default.history.previous.read", "UniversalBrowserRead");
pref("capability.policy.default.history.item.read", "UniversalBrowserRead");

pref("capability.policy.default.location.hash.write", "allAccess");
pref("capability.policy.default.location.host.write", "allAccess");
pref("capability.policy.default.location.hostname.write", "allAccess");
pref("capability.policy.default.location.href.write", "allAccess");
pref("capability.policy.default.location.pathname.write", "allAccess");
pref("capability.policy.default.location.port.write", "allAccess");
pref("capability.policy.default.location.protocol.write", "allAccess");
pref("capability.policy.default.location.search.write", "allAccess");

pref("capability.policy.default.navigator.preference.read", "UniversalPreferencesRead");
pref("capability.policy.default.navigator.preference.write", "UniversalPreferencesWrite");

pref("capability.policy.default.windowinternal.blur", "allAccess");
pref("capability.policy.default.windowinternal.close", "allAccess");
pref("capability.policy.default.windowinternal.focus", "allAccess");
pref("capability.policy.default.windowinternal.location.write", "allAccess");

// window.openDialog is insecure and must be made inaccessible from web scripts - see bug 56009
pref("capability.policy.default.windowinternal.opendialog", "noAccess");

// Mailnews DOM restrictions - see bug 66938
pref("capability.policy.mailnews.characterdata.data", "noAccess");
pref("capability.policy.mailnews.characterdata.substringdata", "noAccess");
pref("capability.policy.mailnews.element.getattribute", "noAccess");
pref("capability.policy.mailnews.element.getattributenode", "noAccess");
pref("capability.policy.mailnews.element.getattributenodens", "noAccess");
pref("capability.policy.mailnews.element.getattributens", "noAccess");
pref("capability.policy.mailnews.htmlanchorelement.href", "noAccess");
pref("capability.policy.mailnews.htmlareaelement.href", "noAccess");
pref("capability.policy.mailnews.htmlbaseelement.href", "noAccess");
pref("capability.policy.mailnews.htmlblockquoteelement.cite", "noAccess");
pref("capability.policy.mailnews.domexception.tostring", "noAccess");
pref("capability.policy.mailnews.htmldocument.domain", "noAccess");
pref("capability.policy.mailnews.htmldocument.url", "noAccess");
pref("capability.policy.mailnews.htmlelement.innerhtml", "noAccess");
pref("capability.policy.mailnews.htmlimageelement.src", "noAccess");
pref("capability.policy.mailnews.image.lowsrc", "noAccess");
pref("capability.policy.mailnews.node.attributes", "noAccess");
pref("capability.policy.mailnews.node.nodevalue", "noAccess");
pref("capability.policy.mailnews.nsdocument.location", "noAccess");
pref("capability.policy.mailnews.window.name.write", "noAccess");
pref("capability.policy.mailnews.windowinternal.location", "noAccess");
pref("capability.policy.mailnews.nshtmlanchorelement.hash", "noAccess");
pref("capability.policy.mailnews.nshtmlanchorelement.host", "noAccess");
pref("capability.policy.mailnews.nshtmlanchorelement.hostname", "noAccess");
pref("capability.policy.mailnews.nshtmlanchorelement.pathname", "noAccess");
pref("capability.policy.mailnews.nshtmlanchorelement.port", "noAccess");
pref("capability.policy.mailnews.nshtmlanchorelement.protocol", "noAccess");
pref("capability.policy.mailnews.nshtmlanchorelement.search", "noAccess");
pref("capability.policy.mailnews.nshtmlanchorelement.text", "noAccess");
pref("capability.policy.mailnews.nshtmlareaelement.hash", "noAccess");
pref("capability.policy.mailnews.nshtmlareaelement.host", "noAccess");
pref("capability.policy.mailnews.nshtmlareaelement.hostname", "noAccess");
pref("capability.policy.mailnews.nshtmlareaelement.pathname", "noAccess");
pref("capability.policy.mailnews.nshtmlareaelement.port", "noAccess");
pref("capability.policy.mailnews.nshtmlareaelement.protocol", "noAccess");
pref("capability.policy.mailnews.nshtmlareaelement.search", "noAccess");
pref("capability.policy.mailnews.range.tostring", "noAccess");
pref("capability.policy.mailnews.sites", "mailbox: imap: news: pop: pop3:");

pref("javascript.enabled",                  true);
pref("javascript.allow.mailnews",           false);
pref("javascript.options.strict",           false);

// advanced prefs
pref("advanced.always_load_images",         true);
pref("security.enable_java",                 true);
pref("css.allow",                           true);
pref("advanced.mailftp",                    false);
pref("image.animation_mode",                "normal");

pref("offline.startup_state",            0);
pref("offline.send.unsent_messages",            0);
pref("offline.prompt_synch_on_exit",            true);
pref("offline.news.download.use_days",          0);

pref("network.hosts.smtp_server",           "mail");
pref("network.hosts.pop_server",            "mail");
pref("network.protocols.useSystemDefaults",   false); // set to true if user links should use system default handlers

// <ruslan>
pref("network.http.version", "1.1");	  // default
// pref("network.http.version", "1.0");   // uncomment this out in case of problems
// pref("network.http.version", "0.9");   // it'll work too if you're crazy
// keep-alive option is effectively obsolete. Nevertheless it'll work with
// some older 1.0 servers:

pref("network.http.keep-alive", true); // set it to false in case of problems
pref("network.http.proxy.keep-alive", true );
pref("network.http.keep-alive.timeout", 300);

pref("network.http.max-connections",  8);
pref("network.http.keep-alive.max-connections", 20); // max connections to be kept alive
pref("network.http.keep-alive.max-connections-per-server", 8);

pref("network.http.connect.timeout",  30);	// in seconds
pref("network.http.request.timeout", 120);	// in seconds

// Enable http compression: comment this out in case of problems with 1.1
pref("network.http.accept-encoding" ,"gzip,deflate,compress,identity");

pref("network.http.pipelining"      , false);
pref("network.http.proxy.pipelining", false);

// Always pipeling the very first request:  this will only work when you are
// absolutely sure the the site or proxy you are browsing to/through support
// pipelining; the default behavior will be that the browser will first make
// a normal, non-pipelined request, then  examine  and remember the responce
// and only the subsequent requests to that site will be pipeline
pref("network.http.pipelining.firstrequest", false);

// Max number of requests in the pipeline
pref("network.http.pipelining.maxrequests" , 4);

pref("network.http.proxy.ssl.connect",true);
// </ruslan>

// sspitzer:  change this back to "news" when we get to beta.
// for now, set this to news.mozilla.org because you can only
// post to the server specified by this pref.
pref("network.hosts.nntp_server",           "news.mozilla.org");

pref("network.hosts.socks_server",          "");
pref("network.hosts.socks_serverport",      1080);
pref("network.hosts.socks_conf",            "");
pref("network.image.imageBehavior",         0); // 0-Accept, 1-dontAcceptForeign, 2-dontUse
pref("network.image.warnAboutImages",       false);
pref("network.proxy.autoconfig_url",        "");
pref("network.proxy.type",                  0);
pref("network.proxy.ftp",                   "");
pref("network.proxy.ftp_port",              0);
pref("network.proxy.gopher",                "");
pref("network.proxy.gopher_port",           0);
pref("network.proxy.news",                  "");
pref("network.proxy.news_port",             0);
pref("network.proxy.http",                  "");
pref("network.proxy.http_port",             0);
pref("network.proxy.wais",                  "");
pref("network.proxy.wais_port",             0);
pref("network.proxy.ssl",                   "");
pref("network.proxy.ssl_port",              0);
pref("network.proxy.socks",                 "");
pref("network.proxy.socks_port",            0);
pref("network.proxy.no_proxies_on",         "");
pref("network.online",                      true); //online/offline
pref("network.accept_cookies",              0);     // 0 = Always, 1 = warn, 2 = never
pref("network.foreign_cookies",             0); // 0 = Accept, 1 = Don't accept
pref("network.cookie.cookieBehavior",       0); // 0-Accept, 1-dontAcceptForeign, 2-dontUse
pref("network.cookie.warnAboutCookies",     false);
pref("signon.rememberSignons",              true);
pref("network.sendRefererHeader",           2); // 0=don't send any, 1=send only on clicks, 2=send on image requests as well
pref("network.enablePad",                   false); // Allow client to do proxy autodiscovery
pref("converter.html2txt.structs",          true); // Output structured phrases (strong, em, code, sub, sup, b, i, u)
pref("converter.html2txt.header_strategy",  1); // 0 = no indention; 1 = indention, increased with header level; 2 = numbering and slight indention
pref("wallet.captureForms",                 true);
pref("wallet.notified",                     false);
pref("wallet.TutorialFromMenu",             "chrome://navigator/locale/navigator.properties");
pref("wallet.Server",                       "chrome://navigator/locale/navigator.properties");
pref("wallet.Samples",                      "chrome://navigator/locale/navigator.properties");
pref("wallet.version",                      "1");
pref("wallet.enabled",                      true);
pref("wallet.crypto",                       false);
pref("imageblocker.enabled",                true);
pref("intl.accept_languages",               "chrome://navigator/locale/navigator.properties");
pref("intl.accept_charsets",                "iso-8859-1,*,utf-8");
pref("intl.collationOption",                "chrome://navigator/locale/navigator.properties");
pref("intl.menuitems.alwaysappendacceskeys","chrome://navigator/locale/navigator.properties");
pref("intl.charsetmenu.browser.static",     "chrome://navigator/locale/navigator.properties");
pref("intl.charsetmenu.browser.more1",      "chrome://navigator/locale/navigator.properties");
pref("intl.charsetmenu.browser.more2",      "chrome://navigator/locale/navigator.properties");
pref("intl.charsetmenu.browser.more3",      "chrome://navigator/locale/navigator.properties");
pref("intl.charsetmenu.browser.more4",      "chrome://navigator/locale/navigator.properties");
pref("intl.charsetmenu.browser.more5",      "chrome://navigator/locale/navigator.properties");
pref("intl.charsetmenu.mailedit",           "chrome://navigator/locale/navigator.properties");
pref("intl.charsetmenu.browser.cache",      "");
pref("intl.charsetmenu.mailview.cache",     "");
pref("intl.charsetmenu.composer.cache",     "");
pref("intl.charsetmenu.browser.cache.size", 5);
pref("intl.charset.detector",                "chrome://navigator/locale/navigator.properties");
pref("intl.charset.default",                "chrome://navigator/locale/navigator.properties");

pref("font.default", "serif");
pref("font.size.variable.ar", 16);
pref("font.size.fixed.ar", 13);

pref("font.size.variable.el", 16);
pref("font.size.fixed.el", 13);

pref("font.size.variable.he", 16);
pref("font.size.fixed.he", 13);

pref("font.size.variable.ja", 14);
pref("font.size.fixed.ja", 14);

pref("font.size.variable.ko", 16);
pref("font.size.fixed.ko", 16);

pref("font.size.variable.th", 16);
pref("font.size.fixed.th", 13);

pref("font.size.variable.tr", 16);
pref("font.size.fixed.tr", 13);

pref("font.size.variable.x-baltic", 16);
pref("font.size.fixed.x-baltic", 13);

pref("font.size.variable.x-central-euro", 16);
pref("font.size.fixed.x-central-euro", 13);

pref("font.size.variable.x-cyrillic", 16);
pref("font.size.fixed.x-cyrillic", 13);

pref("font.size.variable.x-unicode", 16);
pref("font.size.fixed.x-unicode", 13);

pref("font.size.variable.x-western", 14);
pref("font.size.fixed.x-western", 13);

pref("font.size.variable.zh-CN", 16);
pref("font.size.fixed.zh-CN", 16);

pref("font.size.variable.zh-TW", 16);
pref("font.size.fixed.zh-TW", 16);

// -- folders (Mac: these are binary aliases.)
localDefPref("mail.signature_file",             "");
localDefPref("mail.directory",                  "");

pref("images.dither", "auto");
localDefPref("news.directory",                  "");
localDefPref("security.directory",              "");

pref("autoupdate.enabled",              true);

pref("silentdownload.enabled",    true);
pref("silentdownload.directory",  "");
pref("silentdownload.range",      3000);
pref("silentdownload.interval",  10000);

pref("browser.editor.disabled", false);

pref("spellchecker.dictionary", "");

pref("signed.applets.codebase_principal_support", false);
pref("security.checkloaduri", true);
pref("security.xpconnect.plugin.unrestricted", true);

// Modifier key prefs: default to Windows settings,
// menu access key = alt, accelerator key = control.
pref("ui.key.accelKey", 17);
pref("ui.key.menuAccessKey", 18);
pref("ui.key.menuAccessKeyFocuses", false);
pref("ui.key.saveLink.shift", true); // true = shift, false = meta

// Middle-mouse handling
pref("middlemouse.paste", false);
pref("middlemouse.openNewWindow", true);
pref("middlemouse.contentLoadURL", false);
pref("middlemouse.scrollbarPosition", false);

// Clipboard behavior
pref("clipboard.autocopy", false);

// 0=lines, 1=pages, 2=history , 3=text size
pref("mousewheel.withnokey.action",0);
pref("mousewheel.withnokey.numlines",1);	
pref("mousewheel.withnokey.sysnumlines",true);
pref("mousewheel.withcontrolkey.action",0);
pref("mousewheel.withcontrolkey.numlines",1);
pref("mousewheel.withcontrolkey.sysnumlines",true);
pref("mousewheel.withshiftkey.action",0);
pref("mousewheel.withshiftkey.numlines",1);
pref("mousewheel.withshiftkey.sysnumlines",false);
pref("mousewheel.withaltkey.action",2);
pref("mousewheel.withaltkey.numlines",1);
pref("mousewheel.withaltkey.sysnumlines",false);

pref("profile.confirm_automigration",true);

// Customizable toolbar stuff
pref("custtoolbar.personal_toolbar_folder", "");

pref("sidebar.customize.all_panels.url", "http://sidebar-rdf.netscape.com/%LOCALE%/sidebar-rdf/%SIDEBAR_VERSION%/all-panels.rdf");
pref("sidebar.customize.more_panels.url", "http://dmoz.org/Netscape/Sidebar/");

pref("prefs.converted-to-utf8",false);
// --------------------------------------------------
// IBMBIDI 
// --------------------------------------------------
//
// ------------------
//  Text Direction
// ------------------
// 1 = directionLTRBidi *
// 2 = directionRTLBidi
pref("bidi.direction", 1);
// ------------------
//  Text Type
// ------------------
// 1 = charsettexttypeBidi *
// 2 = logicaltexttypeBidi
// 3 = visualtexttypeBidi
pref("bidi.texttype", 1);
// ------------------
//  Controls Text Mode
// ------------------
// 1 = logicalcontrolstextmodeBidiCmd
// 2 = visiualcontrolstextmodeBidi
// 3 = containercontrolstextmodeBidi *
pref("bidi.controlstextmode", 1);
// ------------------
//  Clipboard Text Mode
// ------------------
//  1 = logicalclipboardtextmodeBidi
// 2 = visiualclipboardtextmodeBidi
// 3 = sourceclipboardtextmodeBidi *
pref("bidi.clipboardtextmode", 3);
// ------------------
//  Numeral Style
// ------------------
// 1 = regularcontextnumeralBidi *
// 2 = hindicontextnumeralBidi
// 3 = arabicnumeralBidi
// 4 = hindinumeralBidi
pref("bidi.numeral", 1);
// ------------------
//  Support Mode
// ------------------
// 1 = mozillaBidisupport *
// 2 = OsBidisupport
// 3 = disableBidisupport
pref("bidi.support", 1);
// ------------------
//  Charset Mode
// ------------------
// 1 = doccharactersetBidi *
// 2 = defaultcharactersetBidi
pref("bidi.characterset", 1);


pref("browser.throbber.url","chrome://navigator-region/locale/region.properties");
