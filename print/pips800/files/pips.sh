#!/bin/sh
#
# $FreeBSD$
#

# PROVIDE: pips
# REQUIRE: DAEMON
# BEFORE: LOGIN
# KEYWORD: shutdown

# Define these pips_* variables in one of these files:
#	/etc/rc.conf
#	/etc/rc.conf.local
#	/etc/rc.conf.d/pips
#
# DO NOT CHANGE THESE DEFAULT VALUES HERE
#
pips_enable=${pips_enable:-"YES"}		# Enable pips

. /etc/rc.subr

name="pips"
rcvar=pips_enable
start_cmd="/sbin/ldconfig -m %%PREFIX%%/lib/pips"
stop_cmd=":"

load_rc_config $name
run_rc_command "$1"
