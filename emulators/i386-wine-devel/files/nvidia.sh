#!/bin/sh
# Copyright 2010, 2011, 2012 David Naylor <naylor.b.david@gmail.com>.
# Copyright 2012 Jan Beich <jbeich@tormail.org>
#       All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#   1. Redistributions of source code must retain the above copyright notice,
#      this list of conditions and the following disclaimer.
#
#   2. Redistributions in binary form must reproduce the above copyright notice,
#      this list of conditions and the following disclaimer in the documentation
#      and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY David Naylor ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
# EVENT SHALL David Naylor OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are
# those of the authors and should not be interpreted as representing official
# policies, either expressed or implied, of David Naylor.

# Version 1.0 - 2010/05/28
#  - initial release
# Version 1.1 - 2010/10/04
#  - add support for 256 driver series
#  - use passive connections for FTP
#  - allow resuming of downloads if they were interrupted
#  - add license and copyright notice
# Version 1.2 - 2010/10/17
#  - try to save the NVIDIA tarball under $PORTSDIR/distfiles
#  - obay $PREFIX
#  - extract files directly to destination (avoids using /tmp)
# Version 1.3 - 2010/11/02
#  - add support for future driver series
# Version 1.4 - 2011/05/23
#  - add support for legacy drivers
# Version 1.5 - 2011/10/23
#  - add support for no-fetch mode
#  - backup the original openGL.so.1 library
# Version 1.6 - 2012/06/06
#  - add support for pkgng
# Version 1.7 - 2012/06/23
#  - make nVidia detection more robust
#  - allow mixed pkg/pkgng operation
# Version 1.8 - 2012/07/02
#  - fix mixed pkg/pkgng operation
# Version 1.9 - 2012/10/31
#  - fix permission of extracts files

set -e

PORTSDIR=${PORTSDIR:-/usr/ports}
PREFIX=${PREFIX:-/usr/local}
DISTDIR=${DISTDIR:-${PORTSDIR}/distfiles}

if [ -d $DISTDIR ]
then
  cd $DISTDIR
  NO_REMOVE_NVIDIA="yes"
else
  cd /tmp/
fi

terminate() {

  echo "!!! $2 !!!"
  echo "Terminating..."
  exit $1

}

args=`getopt -n $*`
if [ $? -ne 0 ]
then
  echo "Usage: $0 [-n]"
  exit 7
fi
set -- $args
while true
do
  case $1 in
    -n)
      NO_FETCH=yes
      ;;
    --)
      shift
      break
      ;;
  esac
  shift
done

version() {
  local ret pkg="$1"
  if [ -f "/usr/local/sbin/pkg" ]
  then
    ret=`pkg query -g '%v' $pkg`
  fi

  if [ -z "$ret" ]
  then
    ret=`pkg_info -E $pkg'*' | cut -f 3 -d -`
  fi
  # installed manually or failed to register
  if [ -z "$ret" ] && [ "$pkg" = "nvidia-driver" ]
  then
    ret=`sed -n "s/.*Version: //p" 2> /dev/null \
      $PREFIX/share/doc/NVIDIA_GLX-1.0/README || true`
  fi
  echo "$ret"
}

[ `whoami` = root ] \
  || terminate 254 "This script should be run as root"

echo "===> Patching wine-fbsd64 to work with x11/nvidia-driver:"

if [ -z "${WINE}" ]
then
  WINE=`version wine-fbsd64`
fi
[ -n "$WINE" ] \
  || terminate 255 "Unable to detect wine-fbsd64, please install first"
echo "=> Detected wine-fbsd64: ${WINE}"

NV=`version nvidia-driver`
[ -n "$NV" ] \
  || terminate 1 "Unable to detect nvidia-driver, please install first"
echo "=> Detected nvidia-driver: ${NV}"

NVIDIA=${NV}
NV=`echo ${NV} | cut -f 1 -d _ | cut -f 1 -d ,`

if [ ! -f NVIDIA-FreeBSD-x86-${NV}.tar.gz ]
then
  [ -n "$NO_FETCH" ] \
    && terminate 8 "NVIDIA-FreeBSD-x86-${NV}.tar.gz unavailable"
  echo "=> Downloading NVIDIA-FreeBSD-x86-${NV}.tar.gz from ftp://download.nvidia.com..."
  fetch -apRr ftp://download.nvidia.com/XFree86/FreeBSD-x86/${NV}/NVIDIA-FreeBSD-x86-${NV}.tar.gz \
    || terminate 2 "Failed to download NVIDIA-FreeBSD-x86-${NV}.tar.gz"
fi

echo "=> Extracting NVIDIA-FreeBSD-x86-${NV}.tar.gz to $PREFIX/lib32..."
EXTRACT_LIST="libGL.so.1"
case $NV in
  195*|173*|96*|71*)
    EXTRACT_LIST="$EXTRACT_LIST libGLcore.so.1 libnvidia-tls.so.1"
    ;;
  *)
    EXTRACT_LIST="$EXTRACT_LIST libnvidia-glcore.so.1 libnvidia-tls.so.1"
    ;;
esac

EXTRACT_ARGS="--no-same-owner --no-same-permissions --strip-components 2 -C $PREFIX/lib32"
for i in $EXTRACT_LIST
do
  EXTRACT_ARGS="$EXTRACT_ARGS --include NVIDIA-FreeBSD-x86-${NV}/obj/$i"
done
[ -f ${PREFIX}/lib32/libGL.so.1~ ] \
  || cp ${PREFIX}/lib32/libGL.so.1 ${PREFIX}/lib32/libGL.so.1~
umask 0333
tar $EXTRACT_ARGS -xvf NVIDIA-FreeBSD-x86-${NV}.tar.gz \
  || terminate 3 "Failed to extract NVIDIA-FreeBSD-x86-${NV}.tar.gz"

echo "=> Cleaning up..."
[ -n "$NO_REMOVE_NVIDIA" ] || rm -vf NVIDIA-FreeBSD-x86-${NV}.tar.gz \
  || terminate 6 "Failed to remove files"

echo "===> wine-fbsd64-${WINE} successfully patched for nvidia-driver-${NVIDIA}"
