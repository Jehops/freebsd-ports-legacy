#!/bin/sh
#

# PROVIDE: jabber
# REQUIRE: LOGIN
# KEYWORD: shutdown

#
# Add the following lines to /etc/rc.conf to enable rsyncd:
#
#jabber_enable="YES"
#

. /usr/local/etc/rc.subr

name=jabber
rcvar=`set_rcvar`

command=/usr/local/sbin/jabberd
required_files=/usr/local/etc/${name}.xml

HOSTNAME=`/bin/hostname`

# set defaults

jabber_enable=${jabber_enable:-"NO"}
jabber_pidfile=${jabber_pidfile:-"/var/spool/jabber/${name}.pid"}
jabber_flags=${jabber_flags:-"-B -h ${HOSTNAME} -c ${required_files}"}
jabber_user=${jabber_user:-"jabber"}
jabber_group=${jabber_group:-"jabber"}

pidfile=${jabber_pidfile}

load_rc_config ${name}
run_rc_command "$1"
