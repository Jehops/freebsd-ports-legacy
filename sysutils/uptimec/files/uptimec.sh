#!/bin/sh
#
# $FreeBSD$
#

# PROVIDE: uptimec
# REQUIRE: LOGIN
# KEYWORD: FreeBSD shutdown

# Uptimec is enabled by default, if you have configuration file
#
# Add the following line to /etc/rc.conf to disable uptimec:
#
#uptimec_enable="NO"
#

. %%RC_SUBR%%

name=uptimec
rcvar=`set_rcvar`

command=%%PREFIX%%/sbin/uptimec
required_files=%%PREFIX%%/etc/uptimecrc

# default to enable
uptimec_enable=${uptimec_enable:-"YES"}
uptimec_user=${uptimec_user:-"nobody"}

load_rc_config $name

#if no uptimec_flags, parse rcfile
if [ -z "$uptimec_flags" -a -r $required_files ]; then
    #get hostid from configuration file
    hostid=`awk -F '( |\t)*=( |\t)*' '/^HOSTID/ { print $2;exit 0;}' $required_files`
    password=`awk -F '( |\t)*=( |\t)*' '/^PASSWORD/ { print $2;exit 0;}' $required_files`
    server=`awk -F '( |\t)*=( |\t)*' '/^SERVER/ { print $2;exit 0;}' $required_files`
    port=`awk -F '( |\t)*=( |\t)*' '/^PORT/ { print $2;exit 0;}' $required_files`
    if [ -z "$hostid" -o -z "$password" ]; then
	exit 0;
    fi
    if [ -n "$server" ]; then
	uptimec_flags="-s $server"
    fi
    if [ -n "$port" ]; then
	uptimec_flags="$uptimec_flags -P $port"
    fi	
    uptimec_flags="$uptimec_flags -i $hostid -p $password" 	
else
    exit 0;
fi    

run_rc_command "$1"
