#!/bin/sh
#

# PROVIDE: quagga
# REQUIRE: netif routing mountcritlocal
# BEFORE:  NETWORKING
# KEYWORD: FreeBSD NetBSD

#
# Add the following line to /etc/rc.conf to enable quagga:
#quagga_enable="YES"
#
# You may also wish to use the following variables to fine-tune startup:
#quagga_flags="-d"
#quagga_daemons="zebra ripd ripng ospfd ospf6d bgpd isisd"
#
# If the quagga daemons require additional shared libraries to start,
# use the following variable to run ldconfig(8) in advance:
#quagga_extralibs_path="/usr/local/lib ..."
#

. %%RC_SUBR%%

name="quagga"
rcvar=`set_rcvar`


stop_postcmd=stop_postcmd

stop_postcmd()
{
  rm -f $pidfile
}

# set defaults

quagga_enable=${quagga_enable:-"NO"}
quagga_flags=${quagga_flags:-"-d"}
quagga_daemons=${quagga_daemons:-"zebra ripd ripng ospfd ospf6d bgpd isisd"}
quagga_extralibs_path=${quagga_extralibs_path:-""}
load_rc_config $name

quagga_cmd=$1

case "$1" in
    force*)
	quagga_cmd=${quagga_cmd#force}
	;;
    fast*)
	quagga_cmd=${quagga_cmd#fast}
	;;
esac

case "${quagga_cmd}" in
    start)
	if [ ! -z ${quagga_extralibs_path} ]; then
	    /sbin/ldconfig -m ${quagga_extralibs_path}
	fi
	;;
    stop)
	quagga_daemons=$(reverse_list ${quagga_daemons})
	;;
esac

for daemon in ${quagga_daemons}; do
    command=%%PREFIX%%/sbin/${daemon}
    required_files=%%SYSCONF_DIR%%/${daemon}.conf
    pidfile=%%LOCALSTATE_DIR%%/${daemon}.pid
    if [ ${quagga_cmd} = "start" -a ! -f ${required_files} ]; then
		continue
    fi
    if [ ${quagga_cmd} = "stop" -a -z $(check_process ${command}) ]; then
		continue
    fi
    run_rc_command "$1"
done
