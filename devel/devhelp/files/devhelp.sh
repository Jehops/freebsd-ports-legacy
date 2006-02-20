#!/bin/sh
#
# $FreeBSD$
#
# PROVIDE: devhelp
# REQUIRE: ldconfig

. /etc/rc.subr

name=devhelp

start_cmd=devhelp_start
stop_cmd=:

[ -z "$devhelp_libdir" ] && devhelp_libdir="%%PREFIX%%/lib/%%MOZILLA%%"

devhelp_start() {
    if [ -d "$devhelp_libdir" ]; then
	/sbin/ldconfig -m "$devhelp_libdir"
    fi
}

load_rc_config $name
run_rc_command "$1"
