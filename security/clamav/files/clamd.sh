#!/bin/sh
#
# $FreeBSD$
#

# PROVIDE: clamd
# REQUIRE: LOGIN
# BEFORE: mail
# KEYWORD: FreeBSD shutdown

#
# Add the following lines to /etc/rc.conf to enable clamd:
#
#clamd_enable="YES"
#
# See clamd(8) for flags
#

. %%RC_SUBR%%

name=clamd
rcvar=`set_rcvar`

command=%%PREFIX%%/sbin/clamd
pidfile=/var/run/clamav/clamd.pid
required_dirs=%%DATADIR%%
required_files=%%PREFIX%%/etc/clamav.conf

stop_postcmd=stop_postcmd

stop_postcmd()
{
  rm -f $pidfile
}

# set defaults

clamd_enable=${clamd_enable:-"NO"}
clamd_flags=${clamd_flags:-""}

load_rc_config $name
run_rc_command "$1"
