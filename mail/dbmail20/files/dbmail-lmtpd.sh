#!/bin/sh
#
# $FreeBSD$
#

# PROVIDE: dbmail-lmtpd
# REQUIRE: DAEMON
# KEYWORD: shutdown

#
# Add the following lines to /etc/rc.conf to enable dbmail-lmtpd: 
#
#dbmail_lmtpd_enable="YES"
#
# See dbmail-lmtpd(8) for flags
#

. %%RC_SUBR%%

name=dbmail_lmtpd
rcvar=`set_rcvar`

command=%%PREFIX%%/sbin/dbmail-lmtpd
pidfile=/var/run/dbmail-lmtpd.pid
required_files=%%PREFIX%%/etc/dbmail.conf

# read settings, set default values
load_rc_config "$name"
: ${dbmail_lmtpd_enable="NO"}
: ${dbmail_lmtpd_flags=""}

run_rc_command "$1"
