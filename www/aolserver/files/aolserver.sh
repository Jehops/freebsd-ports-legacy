#! /bin/sh
#
#
# PROVIDE: aolserver
# REQUIRE: DAEMON NETWORKING SERVERS
# KEYWORD: FreeBSD
#
# Add the following line to /etc/rc.conf to enable aolserver:
#
# aolserver_enable="YES"
#
# Tweakable parameters for users to override in rc.conf

aolserver_enable=NO
aolserver_home=%%PREFIX%%/aolserver
aolserver_conf=${aolserver_home}/nsd.tcl 
aolserver_flags="-t ${aolserver_conf} -u nobody -g nobody"
aolserver_prog=nsd8x

. /etc/rc.subr

name=aolserver
rcvar=$(set_rcvar)
required_files=${aolserver_conf}
command=${aolserver_home}/bin/${aolserver_prog}
procname=${aolserver_home}/bin/${aolserver_prog}

stop_cmd="stop_cmd"

stop_cmd() {
        ${command} ${aolserver_flags} -K
}

load_rc_config ${name}
run_rc_command "$1"
