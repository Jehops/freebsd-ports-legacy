#!/bin/sh

# Start or stop vmpsd
# $FreeBSD$

# PROVIDE: vmpsd
# REQUIRE: DAEMON
# KEYWORD: FreeBSD shutdown
#
# NOTE for FreeBSD 5.0+:
# If you want this script to start with the base rc scripts
# move imapd.sh to /etc/rc.d/vmpsd

prefix=%%PREFIX%%

# Define these vmpsd_* variables in one of these files:
#       /etc/rc.conf
#       /etc/rc.conf.local
#       /etc/rc.conf.d/vmpsd
#
# DO NOT CHANGE THESE DEFAULT VALUES HERE 
#
[ -z "$vmpsd_enable" ] && vmpsd_enable="NO" # Enable vmpsd
#vmpsd_program="${prefix}/sbin/vmpsd"       # Location of vmpsd
[ -z "$vmpsd_flags" ] && vmpsd_flags="-f /usr/local/etc/vmps.db"   # Flags to vmpsd program

. %%RC_SUBR%%

name="vmpsd"
rcvar=`set_rcvar`
command="${prefix}/sbin/${name}"

load_rc_config $name
run_rc_command "$1"
