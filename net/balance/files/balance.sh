#!/bin/sh
#
# $FreeBSD$
#

# PROVIDE: balance
# REQUIRE: LOGIN
# KEYWORD: FreeBSD shutdown

#
# Add the following lines to /etc/rc.conf to enable balance:
#
#balance_enable="YES"
#balance_hosts="host1"
#balance_host1_adress="host1.external.example"
#balance_host1_ports="http 8180"
#balance_host1_targets="host1.internal.example"
#
# See balance(8) for flags
#

. %%RC_SUBR%%

name=balance
rcvar=`set_rcvar`
command=%%PREFIX%%/bin/balance

start_cmd=start_cmd
stop_cmd=stop_cmd
status_cmd=status_cmd

start_cmd()
{
	if [ -x "${command}" ]; then
		for host in ${balance_hosts}; do
			eval ports=\"\${balance_${host}_ports}\"
			eval adress=\"\${balance_${host}_adress}\"
			eval targets=\"\${balance_${host}_targets}\"
			for port in ${ports}; do
				"${command}" -b ${adress} ${port} ${targets}
			done
		done
	fi
}

stop_cmd()
{
	if [ -x "${command}" ]; then
		for host in ${balance_hosts}; do
			eval ports=\"\${balance_${host}_ports}\"
			eval adress=\"\${balance_${host}_adress}\"
			for port in ${ports}; do
				echo "balance at ${adress}:${port}"
				"${command}" -b ${adress} -c kill ${port}
			done
		done
	fi
}

status_cmd()
{
	if [ -x "${command}" ]; then
		for host in ${balance_hosts}; do
			eval ports=\"\${balance_${host}_ports}\"
			eval adress=\"\${balance_${host}_adress}\"
			for port in ${ports}; do
				echo "balance at ${adress}:${port}"
				"${command}" -b ${adress} -c show ${port}
			done
		done
	fi
}

# set defaults

balance_enable=${balance_enable:-"NO"}

load_rc_config $name
run_rc_command "$1"
