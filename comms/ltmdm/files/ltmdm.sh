#!/bin/sh
# $FreeBSD$

# PROVIDE: ltmdm
# REQUIRE: DAEMON
# BEFORE: LOGIN
# KEYWORD: FreeBSD shutdown

# Define these ltmdm_* variables in one of these files:
#       /etc/rc.conf
#       /etc/rc.conf.local
#       /etc/rc.conf.d/ltmdm
#
# DO NOT CHANGE THESE DEFAULT VALUES HERE
#
ltmdm_enable=${ltmdm_enable-"NO"}

. %%RC_SUBR%%

name="ltmdm"
rcvar=`set_rcvar`
start_cmd="ltmdm_start"
stop_cmd="ltmdm_stop"
MAJOR="%%MAJOR%%"

load_rc_config $name

ltmdm_devfs_check()
{
	# Check devfs status, return 
	# 0 - if devfs present
	# 1 - if devfs do not present
	if mount -p | awk '{print $3}'| grep -q devfs ; then
		return 0
	else
		return 1
	fi
}

ltmdm_start()
{
	echo "Enabling ltmdm."

	# Check devfs status, if devfs do not presented
	# create cua* and tty* devices
	if ! ltmdm_devfs_check ; then
		umask 7
		mknod /dev/cual0  c ${MAJOR} 128 uucp:dialer
		mknod /dev/cuail0 c ${MAJOR} 160 uucp:dialer
		mknod /dev/cuall0 c ${MAJOR} 192 uucp:dialer
		umask 77
		mknod /dev/ttyl0  c ${MAJOR} 0  root:wheel
		mknod /dev/ttyil0 c ${MAJOR} 32 root:wheel
		mknod /dev/ttyll0 c ${MAJOR} 64 root:wheel
	fi

	# Load ltmdm kernel module if needed
	if ! kldstat -v | grep -q ltmdm\$; then
		if kldload %%PREFIX%%/share/ltmdm/ltmdm.ko; then
			info 'ltmdm module loaded.'
		else
			err 1 'ltmdm module failed to load.'
		fi
	fi

	# Ignore incoming calls
	echo "ats0=0">/dev/cual0
}

ltmdm_stop()
{
	echo "Disabling ltmdm."

	# Check devfs status, if devfs do not presented
	# remove cua* and tty* devices
	if ! ltmdm_devfs_check ; then
		rm -f /dev/cual0 /dev/cuail0 /dev/cuall0 \
			/dev/ttyl0 /dev/ttyil0 /dev/ttyll0
	fi

	# Unload ltmdm kernel module
	kldstat -n ltmdm 2>/dev/null >/dev/null && kldunload ltmdm
}

run_rc_command "$1"
