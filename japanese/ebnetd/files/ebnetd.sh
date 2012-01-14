#!/bin/sh
#
# $FreeBSD$
#

# PROVIDE: ebnetd ndtpd ebhttpd
# REQUIRE: NETWORKING SERVERS
# BEFORE: DAEMON
# KEYWORD: shutdown

#
# Add the following lines to /etc/rc.conf to enable EBNETD servers:
# ebnetd_enable (bool):  Set to "NO" by default.
#                        Set it to "YES" to enable ebnetd.
# ebnetd_flags (str):    Set to "" by default.
#                        Extra flags passed to start ebnetd.
# ndtpd_enable (bool):   Set to "NO" by default.
#                        Set it to "YES" to enable ndtpd.
# ndtpd_flags (str):     Set to "" by default.
#                        Extra flags passed to start ndtpd.
# ebhttpd_enable (bool): Set to "NO" by default.
#                        Set it to "YES" to enable ebhttpd.
# ebhttpd_flags (str):   Set to "" by default.
#                        Extra flags passed to start ebhttpd.

. /etc/rc.subr

# ebnetd
name=ebnetd
rcvar=ebnetd_enable
command="%%PREFIX%%/sbin/${name}"
pidfile="/var/run/ebnetd/ebnd.pid"
required_dirs="/var/run/ebnetd"
required_files=%%PREFIX%%/etc/ebnetd.conf

ebnetd_enable=${ebnetd_enable:-"NO"}
ebnetd_flags=${ebnetd_flags:-""}

sig_reload=SIGHUP
extra_commands="reload"

load_rc_config $name
run_rc_command "$1"

# ndtpd
name=ndtpd
rcvar=ndtpd_enable
command="%%PREFIX%%/sbin/${name}"
pidfile="/var/run/ebnetd/${name}.pid"
required_dirs="/var/run/ebnetd"
required_files=%%PREFIX%%/etc/ebnetd.conf

ndtpd_enable=${ndtpd_enable:-"NO"}
ndtpd_flags=${ndtpd_flags:-""}

sig_reload=SIGHUP
extra_commands="reload"

load_rc_config $name
run_rc_command "$1"

# ebhttpd
name=ebhttpd
rcvar=ebhttpd_enable
command="%%PREFIX%%/sbin/${name}"
pidfile="/var/run/ebnetd/${name}.pid"
required_dirs="/var/run/ebnetd"
required_files=%%PREFIX%%/etc/ebnetd.conf

ebhttpd_enable=${ebhttpd_enable:-"NO"}
ebhttpd_flags=${ebhttpd_flags:-""}

sig_reload=SIGHUP
extra_commands="reload"

load_rc_config $name
run_rc_command "$1"
