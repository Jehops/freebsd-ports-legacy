#!/bin/sh

MOZILLA_DIR="%%PREFIX%%/lib/%%MOZILLA%%"
MOZILLA_EXEC="mozilla"
LOCATION='new-tab'

cd $MOZILLA_DIR                                     || exit 1

case $1 in
    -browser)
    	REMOTE_COMMAND="xfeDoCommand (openBrowser)"
	;;
    -mail)
    	REMOTE_COMMAND="xfeDoCommand (openInbox)"
	;;
    -compose)
    	REMOTE_COMMAND="xfeDoCommand (composeMessage)"
	;;
    -*)
    	exec ./$MOZILLA_EXEC "$@"
	;;
    *)
    	REMOTE_COMMAND="openURL($@,$LOCATION)"
	;;
esac

# process found
./$MOZILLA_EXEC -remote "ping()"                    &&
./$MOZILLA_EXEC -remote "$REMOTE_COMMAND"           && exit 0

# no existing process
exec ./$MOZILLA_EXEC "$@"

