#!/bin/sh

#
# Copyright (C) 2007 Alexander Leidinger <netchild@FreeBSD.org>.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#

# $FreeBSD$

#
# The purpose of this script is to find the installed port which contains
# the specified libraries.
#

print_usage() {
	echo "Usage: $0 [-b base ...] lib_name ..."
	echo "Example: $0 -b /usr/local -b /space/porttest libX11.so"
}

which pkg_which >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "pkg_which not found in path (${PATH}), aborting" | fmt
	exit 1
fi

args=$(getopt b:h $@)
if [ $? -ne 0 ]; then
	print_usage
	exit 2
fi

set -- ${args}
for arg; do
	case "${arg}" in
	-b)
		bases="${bases} $2"
		shift; shift
		;;
	-h)
		print_usage
		exit 0
		;;
	--)
		shift
		break
		;;
	esac
done

if [ -z "$1" ]; then
	print_usage
	exit 2
fi

if [ -z "${bases}" ]; then
	bases=/usr/local
fi

for i in $@; do
	if [ -e /lib/$i -o -e /usr/lib/$i ]; then
		# base system lib, skipping
		shift
		continue
	fi


	lib="$(echo $i | sed -e 's:^lib:: ; s:\.so.*::')"

	origin=unknown
	for base in ${bases}; do
		port=$(pkg_which "${base}/lib/$i")

		if [ -f /var/db/pkg/$port/+CONTENTS ]; then
			origin=$(grep "@comment ORIGIN:" /var/db/pkg/$port/+CONTENTS | sed -e 's/@comment ORIGIN://')
			break
		else
			continue
		fi
	done

	echo ${lib}:${origin}
	shift
done | sort -u
