#!/bin/sh
/usr/bin/dialog --title "ja-diclookup-mule deinstallation script" --clear \
	--yesno "\n\
Removing diclookup-mule initialization code from site-start.el \n\
Are you sure?" -1 -1
RETVAL=$?

if [ "X${RETVAL}" = "X0" ] ; then # answer is `Yes'. hack diclookup-mule.
cp PREFIX_DIR/lib/mule/site-lisp/site-start.el PREFIX_DIR/lib/mule/site-lisp/site-start.el.bak
grep -v diclookup-mule PREFIX_DIR/lib/mule/site-lisp/site-start.el.bak > PREFIX_DIR/lib/mule/site-lisp/site-start.el

/usr/bin/dialog --title "Message" --clear \
	--msgbox "Thank you for using diclookup-mule.  A bientot." -1 -1
fi
