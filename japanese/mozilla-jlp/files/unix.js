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

pref("mail.empty_trash", false);

// Handled differently under Mac/Windows
pref("network.hosts.smtp_server", "localhost");
pref("network.hosts.pop_server", "pop");
pref("mail.check_new_mail", true);
pref("browser.display.screen_resolution", 0); // System setting
pref("browser.startup.license_accepted", "");
pref("browser.cache.memory_cache_size", 4096);
pref("browser.cache.disk_cache_size", 50000);
pref("browser.ncols", 0);
pref("browser.installcmap", false);
pref("browser.drag_out_of_frame_style", 1);
pref("mail.signature_file", "~/.signature");
pref("mail.default_fcc", "~/nsmail/Sent");
pref("news.default_fcc", "~/nsmail/Sent");
pref("mailnews.reply_with_extra_lines", 0);
pref("security.warn_accept_cookie", false);
pref("editor.disable_spell_checker", false);
pref("editor.dont_lock_spell_files", true);
pref("editor.singleLine.pasteNewlines", 0);

// Middle-mouse handling
pref("middlemouse.paste", true);
pref("middlemouse.contentLoadURL", true);
pref("middlemouse.openNewWindow", true);
pref("middlemouse.scrollbarPosition", true);

// Clipboard behavior
pref("clipboard.autocopy", true);

// autocomplete keyboard grab workaround
pref("autocomplete.grab_during_popup", true);
pref("autocomplete.ungrab_during_mode_switch", true);

// Most Unix people think modal pref windows are stupid:
pref("browser.prefWindowModal", false);

// Unix only
pref("mail.use_movemail", true);
pref("mail.use_builtin_movemail", true);
pref("mail.movemail_program", "");
pref("mail.movemail_warn", false);
pref("mail.sash_geometry", "");
pref("news.cache_xover", false);
pref("news.show_first_unread", false);
pref("news.sash_geometry", "");
pref("helpers.global_mime_types_file", "/usr/local/lib/netscape/mime.types");
pref("helpers.global_mailcap_file", "/usr/local/lib/netscape/mailcap");
pref("helpers.private_mime_types_file", "~/.mime.types");
pref("helpers.private_mailcap_file", "~/.mailcap");
pref("applications.telnet", "xterm -e telnet %h %p");
pref("applications.tn3270", "xterm -e tn3270 %h");
pref("applications.rlogin", "xterm -e rlogin %h");
pref("applications.rlogin_with_user", "xterm -e rlogin %h -l %u");
pref("applications.tmp_dir", "/tmp");
// On Solaris/IRIX, this should be "lp"
pref("print.print_command", "lpr");
pref("print.print_reversed", false);
pref("print.print_color", true);
pref("print.print_landscape", false);
pref("print.print_paper_size", 0);

pref("font.allow_double_byte_special_chars", true);
// font names

// ar

pref("font.name.serif.el", "misc-fixed-iso8859-7");
pref("font.name.sans-serif.el", "misc-fixed-iso8859-7");
pref("font.name.monospace.el", "misc-fixed-iso8859-7");

pref("font.name.serif.he", "misc-fixed-iso8859-8");
pref("font.name.sans-serif.he", "misc-fixed-iso8859-8");
pref("font.name.monospace.he", "misc-fixed-iso8859-8");

pref("font.name.serif.ja", "netscape-fixed-jisx0208.1983-0");
pref("font.name.sans-serif.ja", "netscape-fixed-jisx0208.1983-0");
pref("font.name.monospace.ja", "netscape-fixed-jisx0208.1983-0");

pref("font.name.serif.ko", "daewoo-mincho-ksc5601.1987-0");
pref("font.name.sans-serif.ko", "daewoo-mincho-ksc5601.1987-0");
pref("font.name.monospace.ko", "daewoo-mincho-ksc5601.1987-0");

// th

pref("font.name.serif.tr", "adobe-times-iso8859-9");
pref("font.name.sans-serif.tr", "adobe-helvetica-iso8859-9");
pref("font.name.monospace.tr", "adobe-courier-iso8859-9");

pref("font.name.serif.x-baltic", "b&h-lucidux serif-iso8859-4");
pref("font.name.sans-serif.x-baltic", "b&h-lucidux sans-iso8859-4");
pref("font.name.monospace.x-baltic", "b&h-lucidux mono-iso8859-4");

pref("font.name.serif.x-central-euro", "adobe-times-iso8859-2");
pref("font.name.sans-serif.x-central-euro", "adobe-helvetica-iso8859-2");
pref("font.name.monospace.x-central-euro", "adobe-courier-iso8859-2");

pref("font.name.serif.x-cyrillic", "cronyx-times-koi8-r");
pref("font.name.sans-serif.x-cyrillic", "cronyx-helvetica-koi8-r");
pref("font.name.monospace.x-cyrillic", "cronyx-courier-koi8-r");

pref("font.name.serif.x-unicode", "adobe-times-iso8859-1");
pref("font.name.sans-serif.x-unicode", "adobe-helvetica-iso8859-1");
pref("font.name.monospace.x-unicode", "adobe-courier-iso8859-1");

pref("font.name.serif.x-user-def", "adobe-times-iso8859-1");
pref("font.name.sans-serif.x-user-def", "adobe-helvetica-iso8859-1");
pref("font.name.monospace.x-user-def", "adobe-courier-iso8859-1");

pref("font.name.serif.x-western", "adobe-times-iso8859-1");
pref("font.name.sans-serif.x-western", "adobe-helvetica-iso8859-1");
pref("font.name.monospace.x-western", "adobe-courier-iso8859-1");

pref("font.name.serif.zh-CN", "isas-song ti-gb2312.1980-0");
pref("font.name.sans-serif.zh-CN", "isas-song ti-gb2312.1980-0");
pref("font.name.monospace.zh-CN", "isas-song ti-gb2312.1980-0");

// zh-TW

// below a certian pixel size scaled fonts produce poor results
pref("font.scale.outline.min",      6);
pref("font.scale.bitmap.min",       12);
pref("font.scale.bitmap.undersize", 80);
pref("font.scale.bitmap.oversize",  120);

pref("font.scale.outline.min.ja",      10);
pref("font.scale.bitmap.min.ja",       14);
pref("font.scale.bitmap.undersize.ja", 80);
pref("font.scale.bitmap.oversize.ja",  120);

pref("font.scale.outline.min.zh-CN",      10);
pref("font.scale.bitmap.min.zh-CN",       14);
pref("font.scale.bitmap.undersize.zh-CN", 80);
pref("font.scale.bitmap.oversize.zh-CN",  120);

pref("font.scale.outline.min.zh-TW",      10);
pref("font.scale.bitmap.min.zh-TW",       14);
pref("font.scale.bitmap.undersize.zh-TW", 80);
pref("font.scale.bitmap.oversize.zh-TW",  120);

// minimum font sizes

pref("font.min-size.variable.ja", 8);
pref("font.min-size.fixed.ja", 8);

pref("font.min-size.variable.ko", 10);
pref("font.min-size.fixed.ko", 10);

pref("font.min-size.variable.zh-CN", 10);
pref("font.min-size.fixed.zh-CN", 10);

pref("font.min-size.variable.zh-TW", 10);
pref("font.min-size.fixed.zh-TW", 10);

// ps font
// this list is used by the postscript font
// to enumerate the list of langGroups
// there should be a call to get the
// langGroups; see bug 75054
pref("print.psnativefont.ar", "");
pref("print.psnativefont.el", "");
pref("print.psnativefont.he", "");
pref("print.psnativefont.ja", "");
pref("print.psnativefont.ko", "");
pref("print.psnativefont.th", "");
pref("print.psnativefont.tr", "");
pref("print.psnativefont.x-baltic", "");
pref("print.psnativefont.x-central-euro", "");
pref("print.psnativefont.x-cyrillic", "");
pref("print.psnativefont.x-unicode", "");
pref("print.psnativefont.x-user-def", "");
pref("print.psnativefont.x-western", "");
pref("print.psnativefont.zh-CN", "");
pref("print.psnativefont.zh-TW", "");

pref("mail.signature_date", 0);
