#!/bin/sh
#
# UNIX installation and upgrade script for Urchin
# Copyright (c) 2003 Urchin Software Corporation

# Set shell variables and defaults for installation
PATH=/usr/bin:/usr/sbin:/bin:/sbin:$PATH
OS=`uname -s`
HOST=`uname -n`
INSTALLDIR=/usr/local/urchin
PORT=9999
NOW=`date +%Y%m%d%H%M%S`
LANGUAGE=en

# This sets up a portable way to have echo \c and echo -n be equivalent
case "`echo 'x\c'`" in 
   'x\c') echo="echo -n" nnl= ;;      #BSD style echo
       x) echo="echo"    nnl="\c" ;;  #SysV style echo
       *) echo "$0 quitting: Can't set up echo command" 1>&2; exit 1 ;;
esac

# Ask user to choose language
if [ $# -eq 0 ]; then
   echo "Choose Language: [Default: 1]"
   echo "   1. English"
   echo "   2. Japanese / ���ܸ�"
   $echo "-> ${nnl}"
   read ans
   case $ans in
      ""|1) LANGUAGE=en
            ;;
         2) LANGUAGE=ja
            ;;
   esac
fi

# Language Dictionary
case $LANGUAGE in
   en)
      ENTRY0001="Error"
      ENTRY0002="Unable to determine the current directory"
      ENTRY0003="Missing installer file"
      ENTRY0004="Welcome to the Urchin Installation and Upgrade Utility"
      ENTRY0005="Please select the installation type"
      ENTRY0006="New"
      ENTRY0007="Upgrade"
      ENTRY0008="Default"
      ENTRY0009="Version"
      ENTRY0010="Invalid response.  Please try again."
      ENTRY0011="Please read the install.txt file before continuing.  Urchin installs and uses a lightweight Apache webserver for web-based administration and report delivery.  The installer may ask for the following information during installation"
      ENTRY0012="Be sure to backup the current installation before continuing with this upgrade."
      ENTRY0013="Japanese"
      ENTRY0014="A port number for the Urchin webserver.  Port numbers below 1024 require superuser privileges."
      ENTRY0015="A valid user and group for ownership and operation."
      ENTRY0016="Specify the installation directory"
      ENTRY0017="Specify the directory where Urchin was installed"
      ENTRY0018="The specified location exists and is not a directory"
      ENTRY0019="The specified location is not a directory"
      ENTRY0020="The specified directory does not exist"
      ENTRY0021="Do you want the script to create it?"
      ENTRY0022="Yes"
      ENTRY0023="No"
      ENTRY0024="Failed to make directory"
      ENTRY0025="You do not have permissions to write to the specified directory.  You may need to rerun this script as root or a different user."
      ENTRY0026="The specified directory already exists."
      ENTRY0027="Are you sure you want to install in this location?"
      ENTRY0028="The specified directory does not contain the necessary files for performing an upgrade."
      ENTRY0029="Unable to change ownership of files to the specified group.  The group is either invalid or you don't have permission to change files to that group."
      ENTRY0030="Unable to test group argument."
      ENTRY0031="Invalid option.  You cannot specify a new installation and an upgrade at the same time."
      ENTRY0032="Invalid user."
      ENTRY0033="You must be root to specify a different user."
      ENTRY0034="The webserver cannot be run as root."
      ENTRY0035="Invalid argument supplied after -s option."
      ENTRY0036="A port number less than 1024 requires superuser privileges."
      ENTRY0037="The specified port is not available."
      ENTRY0038="You appear to be downgrading Urchin."
      ENTRY0039="Installed Version"
      ENTRY0040="Installer Version"
      ENTRY0041="Stopping Urchin webserver and scheduler"
      ENTRY0042="Choose a port number for the webserver"
      ENTRY0043="Choose a user for the webserver and file ownership"
      ENTRY0044="Choose a group for the webserver and file ownership"
      ENTRY0045="Would you like the installer to start the Urchin webserver and scheduler at the end of the installation?"
      ENTRY0046="Summary Information"
      ENTRY0047="Installing Urchin"
      ENTRY0048="Upgrading Urchin"
      ENTRY0049="Installation Directory"
      ENTRY0050="Webserver Port"
      ENTRY0051="Webserver User"
      ENTRY0052="Webserver Group"
      ENTRY0053="Start Webserver and Scheduler"
      ENTRY0054="Press return to continue"
      ENTRY0055="Please select continue or exit"
      ENTRY0056="Backing up configuration databases and files"
      ENTRY0057="The following configuration file is not the same as the distributed version.  Please check this file to make sure it contains the correct options"
      ENTRY0058="Installing Urchin"
      ENTRY0059="Continue"
      ENTRY0060="Creating webserver configuration"
      ENTRY0061="Initializing the configuration databases"
      ENTRY0062="Upgrading Urchin"
      ENTRY0063="Updating the configuration databases"
      ENTRY0064="Setting file ownership and permission"
      ENTRY0065="Starting the Urchin webserver and scheduler daemon"
      ENTRY0066="Installation Complete"
      ENTRY0067="Problems changing permissions on the distribution files"
      ENTRY0068="The Urchin administrative interface should be ready to use at"
      ENTRY0069="The Urchin administrative interface will be ready to use at the following address after the webserver and scheduler have been started."
      ENTRY0070="The administrative interface default username is admin and the password is urchin.  A wizard will direct you through the process of licensing the product and changing the default password.  We strongly recommend that you  change the default value to something more secure."
      ENTRY0071="To start or stop the Urchin webserver or scheduler, run 'urchinctl start' or 'urchinctl stop' from the installation bin directory."
      ENTRY0072="Usage"
      ENTRY0073="directory"
      ENTRY0074="port"
      ENTRY0075="user"
      ENTRY0076="group"
      ENTRY0077="prints this help message"
      ENTRY0078="operates the installer in quiet mode (disables some messages)"
      ENTRY0079="specifies the installation directory"
      ENTRY0080="specifies the port for the webserver"
      ENTRY0081="specifies the group for the webserver"
      ENTRY0082="specifies the user for the webserver"
      ENTRY0083="specifies whether to start the Urchin webserver and scheduler"
      ENTRY0084="specifies a new installation"
      ENTRY0085="specifies an upgrade installation"
      ENTRY0086="Exit"
      ENTRY0087="Restarting Urchin webserver and scheduler"
      ENTRY0088="Determining data and var directory locations"
      ENTRY0089="Installer cannot continue with upgrade"
      ENTRY0090="Warning"
      ;;
   ja)
      ENTRY0001="���顼"
      ENTRY0002="���ߤΥǥ��쥯�ȥ꤬���Ĥ���ޤ���"
      ENTRY0003="���󥹥ȡ���ե����뤬��­���Ƥ��ޤ�"
      ENTRY0004="Urchin ���󥹥ȡ���ȥ��åץ��졼�ɥ桼�ƥ���ƥ��ؤ褦����"
      ENTRY0005="���󥹥ȡ��륿���פ����򤷤Ƥ���������"
      ENTRY0006="����"
      ENTRY0007="���åץ��졼��"
      ENTRY0008="�ǥե����"
      ENTRY0009="�С������"
      ENTRY0010="���Ϥ��ְ�äƤ��ޤ����⤦�������Ϥ��Ƥ���������"
      ENTRY0011="³�Ԥ������� install.txt ���ɤߤ���������Urchin �ϡ������֥١����δ�������ݡ������ۤ˹Ԥ����ᡢ���̲����줿 Apache �����֥����С��򥤥󥹥ȡ��뤷�ޤ������󥹥ȡ�����ˤ����ξ����ɬ�פȤ��뤳�Ȥ�����ޤ���"
      ENTRY0012="���åץ��졼�ɤ�³�Ԥ������ˡ����ߥ��󥹥ȡ��뤵��Ƥ��� Urchin ��Хå����åפ��Ƥ���������"
      ENTRY0013="���ܸ�"
      ENTRY0014="Urchin �����֥����С��ѤΥݡ����ֹ�Ǥ���1024�ʲ��Υݡ����ֹ���Ѥˤϥ����ѡ��桼�����θ��¤�ɬ�פȤ��ޤ���"
      ENTRY0015="��ͭ�Ѥ�����Ѥ�ͭ���ʥ桼���ȥ��롼��"
      ENTRY0016="���󥹥ȡ���ǥ��쥯�ȥ����ꤷ�Ƥ�������"
      ENTRY0017="Urchin �����󥹥ȡ��뤵��Ƥ���ǥ��쥯�ȥ����ꤷ�Ƥ�������"
      ENTRY0018="���ꤵ�줿����¸�ߤ��ޤ������ǥ��쥯�ȥ�ǤϤ���ޤ���"
      ENTRY0019="���ꤵ�줿���ϥǥ��쥯�ȥ�ǤϤ���ޤ���"
      ENTRY0020="���ꤵ�줿�ǥ��쥯�ȥ��¸�ߤ��ޤ���"
      ENTRY0021="������ץȤˤ�äƤ����������ޤ�����"
      ENTRY0022="�Ϥ�"
      ENTRY0023="������"
      ENTRY0024="�ǥ��쥯�ȥ�����˼��Ԥ��ޤ���"
      ENTRY0025="���ꤵ�줿�ǥ��쥯�ȥ�˽񤭹��ย�¤�����ޤ��󡣥롼�ȡ������̤Υ桼�����Ǥ��Υ�����ץȤ�Ƶ�ư���Ƥ���������"
      ENTRY0026="���ꤵ�줿�ǥ��쥯�ȥ�Ϥ��Ǥ�¸�ߤ��ޤ���"
      ENTRY0027="�����ˤ��ξ��˥��󥹥ȡ��뤷�Ƥ������Ǥ�����"
      ENTRY0028="���ꤵ�줿�ǥ��쥯�ȥ�ˤϡ����åץ��졼�ɤ�ɬ�פʥե����뤬¸�ߤ��ޤ���"
      ENTRY0029="�ե�����ν�ͭ���򡢻��ꤷ�����롼�פ��ѹ��Ǥ��ޤ��󡣤��Υ��롼�פ������Ǥ��뤫�����ʤ��˥ե�����򤳤Υ��롼�פ��ѹ����븢�¤�����ޤ���"
      ENTRY0030="���롼�װ������ѹ��Ǥ��ޤ���"
      ENTRY0031="�����ʥ��ץ����Ǥ����������󥹥ȡ���ȥ��åץ��졼�ɤ�Ʊ���˹Ԥ��ޤ���"
      ENTRY0032="�����ʥ桼����"
      ENTRY0033="�㤦�桼��������ꤹ��ˤϥ롼�ȥ桼�����ˤʤ�ɬ�פ�����ޤ���"
      ENTRY0034="�����֥����Фϥ롼�ȤǤϵ�ư�Ǥ��ޤ���"
      ENTRY0035="-s �θ�������ʰ������դ��Ƥ��ޤ���"
      ENTRY0036="1024��꾮�����ݡ����ֹ�ˤϥ����ѡ��桼�����θ��¤�ɬ�פǤ���A"
      ENTRY0037="���򤵤줿�ݡ��Ȥ�ͭ���ǤϤ���ޤ���"
      ENTRY0038="Urchin ������󥰥졼�ɤ��褦�Ȥ��Ƥ��ޤ���"
      ENTRY0039="���󥹥ȡ��뤵�줿�С������"
      ENTRY0040="���󥹥ȡ���ΥС������"
      ENTRY0041="Urchin �����֥����С��ȥ������塼�����ߤ����ޤ���"
      ENTRY0042="�����֥������ѤΥݡ����ֹ�����򤷤Ƥ�������"
      ENTRY0043="�����֥����Фȥե�����ν�ͭ������ĥ桼�������򤷤Ƥ�������"
      ENTRY0044="�����֥����Фȥե�����ν�ͭ������ĥ��롼�פ����򤷤Ƥ�������"
      ENTRY0045="���󥹥ȡ���κǸ�� Urchin �����֥����Фȥ������塼���Ω���夲�ޤ�����"
      ENTRY0046="�������"
      ENTRY0047="Urchin ���󥹥ȡ�����"
      ENTRY0048="Urchin ���åץ��졼����"
      ENTRY0049="���󥹥ȡ���ǥ��쥯�ȥ�"
      ENTRY0050="�����֥����Хݡ���"
      ENTRY0051="�����֥����Х桼����"
      ENTRY0052="�����֥����Х��롼��"
      ENTRY0053="�����֥����Фȥ������塼���ư���Ƥ�������"
      ENTRY0054="³���뤿��ˤϥ꥿����򲡤��Ƥ�������"
      ENTRY0055="Please select continue or exit"
      ENTRY0056="Backing up configuration databases and files"
      ENTRY0057="The following configuration file is not the same as the distributed version.  Please check this file to make sure it contains the correct options"
      ENTRY0058="Urchin �Υ��󥹥ȡ�����"
      ENTRY0059="Continue"
      ENTRY0060="�����֥���������κ�����"
      ENTRY0061="����ǡ����١����ν������"
      ENTRY0062="Upgrading Urchin"
      ENTRY0063="����ǡ����١����Υ��åץǡ�����"
      ENTRY0064="�ե������ͭ�����ѡ��ߥå�����������"
      ENTRY0065="Urchin �����֥����Фȥ������塼��ǡ����ε�ư��"
      ENTRY0066="���󥹥ȡ��봰λ"
      ENTRY0067="���ۥե�����Υѡ��ߥå�����ѹ������꤬����ޤ�"
      ENTRY0068="Urchin �������󥿡��ե������ϻ�����Ǥ�"
      ENTRY0069="�����֥����Фȥ������塼�鵯ư�塢Urchin �������󥿡��ե��������ʲ��Υ��ɥ쥹�ǻ��Ѥ���ޤ���"
      ENTRY0070="�������󥿡��ե������Ǥϡ��ǥե���ȥ桼����̾�� admin���ѥ���ɤ�urchin �Ǥ������������ɤ������ʤΥ饤���󥹲��ȥǥե���ȥѥ���ɤ��ѹ���Ԥ��ޤ����ǥե�����ͤ�������ʤ�Τ��ѹ����뤳�Ȥ򤪴��ᤷ�ޤ���"
      ENTRY0071="Urchin �����֥����Фȥ������塼��ε�ư����ߤˤϡ����󥹥ȡ��� bin �ǥ��쥯�ȥ꤫�顢��urchinctl start�����ϡ�urchinctl stop�פ�ư���Ƥ���������"
      ENTRY0072="����ˡ"
      ENTRY0073="�ǥ��쥯�ȥ�"
      ENTRY0074="�ݡ���"
      ENTRY0075="�桼����"
      ENTRY0076="���롼��"
      ENTRY0077="���Υإ�ץ�å�������ץ��Ȥ��Ƥ�������"
      ENTRY0078="���󥹥ȡ���� quiet �⡼�ɡʴ��Ĥ��Υ�å���������ɽ���ˤʤ�ޤ��ˤǹԤäƤ�������"
      ENTRY0079="���󥹥ȡ���ǥ��쥯�ȥ����ꤷ�Ƥ�������"
      ENTRY0080="�����֥����ФΥݡ��Ȥ���ꤷ�Ƥ�������"
      ENTRY0081="�����֥����ФΥ��롼�פ���ꤷ�Ƥ�������"
      ENTRY0082="�����֥����ФΥ桼������ꤷ�Ƥ�������"
      ENTRY0083="Urchin �����֥����Фȥ������塼���ư���뤫����ꤷ�Ƥ�������"
      ENTRY0084="�������󥹥ȡ������ꤷ�Ƥ�������"
      ENTRY0085="���åץ��졼�ɥ��󥹥ȡ������ꤷ�Ƥ�������"
      ENTRY0086="Exit"
      ENTRY0087="Restarting Urchin webserver and scheduler"
      ENTRY0088="Determining data and var directory locations"
      ENTRY0089="Installer cannot continue with upgrade"
      ENTRY0090="Warning"
      ;;
esac

# Function to format text output
echof () {
   if [ -f /usr/bin/fmt ] && [ $LANGUAGE = en ]; then
      echo "$1" | fmt
   else
      echo "$1"
   fi
}

# Determine the current directory and the location of the installation files
CURRENTDIR=`pwd`
if [ "x$CURRENTDIR" = x ]; then
   echof "## $ENTRY0001: $ENTRY0002"
   exit 1
fi
TEMPDIR=`dirname $0`
if [ "x$TEMPDIR" != x ] && [ "x$TEMPDIR" != x. ]; then
   INSTALLERDIR=$CURRENTDIR/$TEMPDIR
else
   INSTALLERDIR=$CURRENTDIR
fi

# Verify installation files are present in the installer's directory
INSPECTOR=$INSTALLERDIR/inspector
if [ ! -f "$INSPECTOR" ]; then
   echof "## $ENTRY0001: $ENTRY0003: $INSPECTOR"
   exit 1
fi
GUNZIP=$INSTALLERDIR/gunzip
if [ ! -f "$GUNZIP" ]; then
   if [ -f /usr/bin/gunzip ] && [ -x /usr/bin/gunzip ]; then
      GUNZIP=/usr/bin/gunzip
   else
      echof "## $ENTRY0001: $ENTRY0003: $GUNZIP"
      exit 1
   fi
fi
DIST=$INSTALLERDIR/urchin.tar.gz
if [ ! -f "$DIST" ]; then
   echof "## $ENTRY0001: $ENTRY0003: $DIST"
   exit 1
fi

# Get the version number for displaying to the user
NEWVERSION=`"$INSPECTOR" -v | cut -d ":" -f 2 | cut -d " " -f 3 | cut -c 1,2,3,4`
MAJORVERSION=`echo $NEWVERSION | cut -c 1`
MINORVERSION=`echo $NEWVERSION | cut -c 2,3,4`

# Determine username of the person executing this script
if [ $OS = SunOS ]; then
   if [ -f /usr/xpg4/bin/id ]; then
      MYLOGIN=`/usr/xpg4/bin/id -un`
   fi 
else
   MYLOGIN=`id -un`
fi

# Verify MYLOGIN was set
if [ x$MYLOGIN = x ]; then
   if [ ! x$USER = x ]; then
      MYLOGIN=$USER
   elif [ ! x$LOGNAME = x ]; then
      MYLOGIN=$LOGNAME
   else
      MYLOGIN=nobody
   fi
fi

# Set the default user for the web server.  This will be verified later...
if [ $MYLOGIN = root ]; then
   WUSER=nobody
else
   WUSER=$MYLOGIN
fi

# Set the default group for the user.  This will be verified later...
if [ $OS = SunOS ]; then
   if [ -f /usr/xpg4/bin/id ]; then
      WGROUP=`/usr/xpg4/bin/id -gn $WUSER`
   fi 
else
   WGROUP=`id -gn $WUSER`
fi
if [ x$WGROUP = x ]; then
   WGROUP=`groups $WUSER | awk '{print $1}'`
fi

# Set flags for command line options
dflag=0   # Install Directory flag
gflag=0   # Group flag
pflag=0   # Port flag
qflag=0   # Quiet flag
sflag=0   # Start scheduler and webserver flag
tflag=0   # Installation type (new or upgrade)
uflag=0   # User flag

# Check for a --help argument
for arg in "$@"; do
   if [ "x$arg" = x--help ]; then
      $0 -h
      exit 0
   fi
done

# Read in command line arguments and set flags and variables accordingly
while getopts d:g:hnmp:qs:u: OPT; do
   case $OPT in
      # Partially verify the installation directory
      d) if [ "x$OPTARG" != x ]; then
            if [ -r "$OPTARG" ] || [ -w "$OPTARG" ] || [ -x "$OPTARG" ] && [ ! -d "$OPTARG" ]; then
               echof "## $ENTRY0001: $ENTRY0018: $OPTARG"
               exit 1
            fi
            # Perform remainder of directory checks at end of the getopts while loop right after
            # selection of installation type.
            INSTALLDIR=$OPTARG
            dflag=1
         fi
         ;;
      # Verify the group
      g) if [ x$OPTARG != x ]; then
            if [ ! -d /tmp/.urchin$$ ] && [ ! -f /tmp/.urchin$$ ] && [ ! -r /tmp/.urchin$$ ] && [ ! -w /tmp/.urchin$$ ] && [ ! -x /tmp/.urchin$$ ]; then
               touch /tmp/.urchin$$
               chgrp $OPTARG /tmp/.urchin$$ > /dev/null 2>&1
               if [ $? != 0 ]; then
                  echof "## $ENTRY0001: $ENTRY0029: $OPTARG"
                  exit 1
               else
                  WGROUP=$OPTARG
                  gflag=1
               fi
               if [ -f /tmp/.urchin$$ ]; then
                  rm /tmp/.urchin$$
               fi
            else
               echof "## $ENTRY0001: $ENTRY0030"
            fi
         fi
         ;;
      # Print help information
      h) echof "$ENTRY0072: $0 [-h] [-q] [-d $ENTRY0073] [-p $ENTRY0074] [-g $ENTRY0076] [-u $ENTRY0075] [-s (yes|no)] [-n|-m]"
         echof "      -h   $ENTRY0077"
         echof "      -q   $ENTRY0078"
         echof "      -d   $ENTRY0079"
         echof "      -p   $ENTRY0080"
         echof "      -g   $ENTRY0081"
         echof "      -u   $ENTRY0082"
         echof "      -s   $ENTRY0083"
         echof "      -n   $ENTRY0084"
         echof "      -m   $ENTRY0085"
         echof ""
         exit 0
         ;;
      # New installation
      n) if [ $tflag -eq 0 ]; then
            upgrade=0
            tflag=1
         else
            if [ $upgrade -eq 1 ]; then
               echof "## $ENTRY0001: $ENTRY0031"
               exit 1
            fi
         fi
         ;;
      # Upgrade installation
      m) if [ $tflag -eq 0 ]; then
            upgrade=1
            tflag=1
         else
            if [ $upgrade -eq 0 ]; then
               echof "## $ENTRY0001: $ENTRY0031"
               exit 1
            fi
         fi
         ;;
      # Verify the port
      p) if [ x$OPTARG != x ]; then
            if [ $MYLOGIN != root ] && [ $OPTARG -lt 1024 ]; then
               echof "## $ENTRY0001: $ENTRY0036: $OPTARG"
               exit 1
            else
               PORT=$OPTARG
               pflag=1
            fi
         fi
         ;;
      # Set the quiet flag
      q) qflag=1
         ;;
      # Set the start flag
      s) if [ x$OPTARG != x ]; then
            if [ x$OPTARG = xyes ]; then
               startservers=1
            elif [ x$OPTARG = xno ]; then
               startservers=0
            else
               echof "## $ENTRY0001: $ENTRY0035"
               exit 1
            fi
            sflag=1
         fi
         ;;
      # Verify the user
      u) if [ x$OPTARG != x ]; then
            if [ $OPTARG = root ]; then
               echof "## $ENTRY0001: $ENTRY0034: $OPTARG"
               exit 1
            fi
            id $OPTARG > /dev/null 2>&1
            if [ ! $? = 0 ]; then
               echof "## $ENTRY0001: $ENTRY0032: $OPTARG"
               exit 1
            elif [ $OPTARG != $MYLOGIN ] && [ $MYLOGIN != root ]; then
               echof "## $ENTRY0001: $ENTRY0033: $OPTARG"
               exit 1
            else
               WUSER=$OPTARG
               uflag=1
            fi
         fi
         ;;
      \?) $0 -h
         exit 1
         ;;
   esac  
done  

# Print installation splash screen and basic information
if [ $qflag -eq 0 ]; then
   clear
   echof "------------------------------------------------------------------------"
   echof "-- $ENTRY0004"
   echof "-- $ENTRY0009 $MAJORVERSION.$MINORVERSION"
   echof "------------------------------------------------------------------------"
   echof ""
   echof "$ENTRY0011:"
   echof "   1. $ENTRY0014"
   echof "   2. $ENTRY0015"
   echof ""
fi

# Prompt user for new install vs upgrade
if [ $tflag -eq 0 ]; then
   wflag=0
   while [ $wflag -eq 0 ]; do
      echof "$ENTRY0005 [$ENTRY0008: 1]"
      echof "   1. $ENTRY0006"
      echof "   2. $ENTRY0007"
      $echo "-> ${nnl}"
      read ans
      case $ans in
         ""|1) upgrade=0
               wflag=1
               ;;
            2) upgrade=1
               wflag=1
               ;;
            *) echof "$ENTRY0010"
               ;;
      esac
      echof ""
   done  
fi

# Warn user to backup before proceeding
if [ $upgrade -eq 1 ] && [ $qflag -eq 0 ]; then
   echof "$ENTRY0012"
   echof ""
fi

# Finish verification of directory entered as a command line option based on installation type.
if [ $dflag -eq 1 ]; then
   # Check if $INSTALLDIR does not exist
   if [ ! -d "$INSTALLDIR" ]; then
      if [ $upgrade -eq 0 ]; then
         mkdir "$INSTALLDIR"
         if [ $? -gt 0 ]; then
            echof "## $ENTRY0001: $ENTRY0024: $INSTALLDIR"
            exit 1
         fi
      else
         echof "## $ENTRY0001: $ENTRY0020: $INSTALLDIR"
         exit 1
      fi
   # Check if $INSTALLDIR is not writeable
   elif [ ! -w "$INSTALLDIR" ]; then
      echof "## $ENTRY0001: $ENTRY0025: $INSTALLDIR"
      exit 1
   fi
fi

# Verify the port is available if this is a new installation and the port was a command line option.
if [ $upgrade -eq 0 ] && [ $pflag -eq 1 ]; then
   "$INSPECTOR" -P $PORT
   if [ $? -ne 0 ]; then
      echof "## $ENTRY0001: $ENTRY0037: $PORT"
      exit 1
   fi
fi

# ---Installation Directory---
# Perform necessary checks on the installation directory entered by the user
if [ $dflag -eq 0 ]; then
   wflag=0
   while [ $wflag -eq 0 ]; do 
      # Prompt user for installation directory
      if [ $upgrade -eq 0 ]; then
         echof "$ENTRY0016 [$ENTRY0008: $INSTALLDIR]:"
         $echo "-> ${nnl}"
      else
         echof "$ENTRY0017 [$ENTRY0008: $INSTALLDIR]:"
         $echo "-> ${nnl}"
      fi
      read dir
      echof ""

      # Assign default answer to $dir if nothing was entered
      if [ "x$dir" = "x" ]; then
         dir=$INSTALLDIR
      fi

      # Verify that $dir is not already a file
      if [ -r "$dir" -o -w "$dir" -o -x "$dir" ] && [ ! -d "$dir" ]; then
         if [ $upgrade -eq 0 ]; then
            echof "$ENTRY0018: $dir"
         else
            echof "$ENTRY0019: $dir"
         fi
         echof ""
      # Check if $dir does not exist
      elif [ ! -d "$dir" ]; then
         if [ $upgrade -eq 0 ]; then
            echof "$ENTRY0020: $dir"
            echof ""
            wflag2=0
            while [ $wflag2 -eq 0 ]; do
               # Prompt user regarding creation of $dir
               echof "$ENTRY0021 [$ENTRY0008: 1]"
               echof "   1. $ENTRY0022"
               echof "   2. $ENTRY0023"
               $echo "-> ${nnl}"
               read ans
               case $ans in
                  ""|1) mkdir "$dir"
                        if [ $? -gt 0 ]; then
                           echof "## $ENTRY0001: $ENTRY0024: $dir"
                           exit 1
                        fi
                        INSTALLDIR=$dir
                        wflag2=1
                        wflag=1
                        ;;
                     2) wflag2=1
                        ;;
                     *) echof "$ENTRY0010"
                        ;;
               esac
               echof ""
            done
         else
            echof "$ENTRY0020: $dir"
            echof ""
         fi
      elif [ ! -w "$dir" ]; then
         echof "$ENTRY0025"
         echof ""
      else
         if [ $upgrade -eq 0 ]; then
            wflag2=0
            echof "$ENTRY0026"
            while [ $wflag2 -eq 0 ]; do
               echof "$ENTRY0027 [$ENTRY0008: 2]"
               echof "   1. $ENTRY0022"
               echof "   2. $ENTRY0023"
               $echo "-> ${nnl}"
               read ans
               case $ans in
                     1) wflag2=1
                        INSTALLDIR=$dir
                        wflag=1
                        ;;
                  ""|2) wflag2=1
                        ;;
                     *) echof "$ENTRY0010"
                        ;;
               esac
               echof ""
            done
         else
            if [ ! -f "$dir/bin/urchin" ]; then
               echof "$ENTRY0028"
               echof ""
            else
               INSTALLDIR=$dir
               wflag=1
            fi
         fi
      fi
   done
fi

# Verify this is an upgrade and not a downgrade
if [ $upgrade -eq 1 ]; then
   # Check the version number to make sure this is an upgrade and not a downgrade.
   OLDVERSION=0
   if [ -x "$INSTALLDIR/bin/urchin" ]; then
      OLDVERSION=`"$INSTALLDIR/bin/urchin" -v | cut -d ":" -f 2 | cut -d " " -f 3 | cut -c 1,2,3,4`
   fi
   if [ $NEWVERSION -lt $OLDVERSION ]; then
      echof "## $ENTRY0001: $ENTRY0038"
      echof "$ENTRY0039: $OLDVERSION"
      echof "$ENTRY0040: $NEWVERSION"
      exit 1
   fi
fi

# Determine the locations of the data and var directories from urchin.conf
INSTALLDATADIR="$INSTALLDIR/data"
INSTALLVARDIR="$INSTALLDIR/var"
if [ $upgrade -eq 1 ]; then
   if [ $qflag -eq 0 ]; then
      echof "$ENTRY0088"
   fi
   if [ -f "$INSTALLDIR/etc/urchin.conf" ]; then
      DATADIR=`grep "^[ \t]*dataDirectory:" "$INSTALLDIR/etc/urchin.conf" | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
      VARDIR=`grep "^[ \t]*varDirectory:" "$INSTALLDIR/etc/urchin.conf" | cut -d : -f 2 | sed -e 's/^[ \t]*//'`
   fi
   if [ x$DATADIR != x ]; then
      LETTER1=`echo "$DATADIR" | cut -c 1`
      if [ x$LETTER1 = x/ ]; then
         INSTALLDATADIR="$DATADIR"
      else
         INSTALLDATADIR="$INSTALLDIR/$DATADIR"
      fi
   fi
   if [ x$VARDIR != x ]; then
      LETTER1=`echo "$VARDIR" | cut -c 1`
      if [ x$LETTER1 = x/ ]; then
         INSTALLVARDIR="$VARDIR"
      else
         INSTALLVARDIR="$INSTALLDIR/$VARDIR"
      fi
   fi

   # Verify that the data directory is a directory and is writable
   if [ -r "$INSTALLDATADIR" -o -w "$INSTALLDATADIR" -o -x "$INSTALLDATADIR" ] && [ ! -d "$INSTALLDATADIR" ]; then
      echof "## $ENTRY0001: $ENTRY0018: $INSTALLDATADIR"
      echof "## $ENTRY0089"
      exit 1
   elif [ ! -d "$INSTALLDATADIR" ]; then
      echof "## $ENTRY0001: $ENTRY0020: $INSTALLDATADIR"
      echof "## $ENTRY0089"
      exit 1
   elif [ ! -w "$INSTALLDATADIR" ]; then
      echof "## $ENTRY0001: $ENTRY0025: $INSTALLDATADIR"
      echof "## $ENTRY0089"
      exit 1
   fi

   # Verify that the var directory is a directory and is writable
   if [ -r "$INSTALLVARDIR" -o -w "$INSTALLVARDIR" -o -x "$INSTALLVARDIR" ] && [ ! -d "$INSTALLVARDIR" ]; then
      echof "## $ENTRY0001: $ENTRY0018: $INSTALLVARDIR"
      echof "## $ENTRY0089"
      exit 1
   elif [ ! -d "$INSTALLVARDIR" ]; then
      echof "## $ENTRY0001: $ENTRY0020: $INSTALLVARDIR"
      echof "## $ENTRY0089"
      exit 1
   elif [ ! -w "$INSTALLVARDIR" ]; then
      echof "## $ENTRY0001: $ENTRY0025: $INSTALLVARDIR"
      echof "## $ENTRY0089"
      exit 1
   fi

   if [ $qflag -eq 0 ]; then
      echof ""
   fi
fi

# Shutdown the webserver and scheduler if they are running
if [ -f "$INSTALLVARDIR/httpd.pid" ] || [ -f "$INSTALLVARDIR/urchind.pid" ] || [ -f "$INSTALLVARDIR/urchinwebd.pid" ]; then
   if [ $qflag -eq 0 ]; then
      echof "$ENTRY0041"
      if [ -f "$INSTALLDIR/bin/wrapper" ]; then
         cd "$INSTALLDIR/bin"
         ./wrapper -disable
         cd "$CURRENTDIR"
      else
         "$INSTALLDIR/bin/urchinctl" stop
      fi
      echof ""
   else
      if [ -f "$INSTALLDIR/bin/wrapper" ]; then
         cd "$INSTALLDIR/bin"
         ./wrapper -disable > /dev/null 2>&1
         cd "$CURRENTDIR"
      else
         "$INSTALLDIR/bin/urchinctl" stop > /dev/null 2>&1
      fi
   fi
fi

# Verify the port is available if this is an upgrade and the port was a command line option.
if [ $upgrade -eq 1 ] && [ $pflag -eq 1 ]; then
   "$INSPECTOR" -P $PORT
   if [ $? -ne 0 ]; then
      echof "## $ENTRY0001: $ENTRY0037: $PORT"
      exit 1
   fi
fi

# ---Webserver Configuration---
# Prompt user for the webserver port
if [ $pflag -eq 0 ]; then
   wflag=0
   while [ $wflag -eq 0 ]; do
      if [ $upgrade -eq 0 ]; then
         echof "$ENTRY0042 [$ENTRY0008: $PORT]"
         $echo "-> ${nnl}"
      else
         port=0
         if [ -r "$INSTALLVARDIR/urchinwebd.conf" ]; then
            port=`grep "^Port" "$INSTALLVARDIR/urchinwebd.conf" | cut -d " " -f 2`
         elif [ -r "$INSTALLDIR/etc/httpd.conf" ]; then
            port=`grep "^Port" "$INSTALLDIR/etc/httpd.conf" | cut -d " " -f 2`
         fi
         if [ $port -ne 0 ]; then
            PORT=$port
         fi
         echof "$ENTRY0042 [$ENTRY0008: $PORT]"
         $echo "-> ${nnl}"
      fi
      read portin
      echof ""
      if [ x$portin = x ]; then
         portin=$PORT
      fi
      if [ $MYLOGIN != root ] && [ $portin -lt 1024 ]; then
         echof "$ENTRY0036"
         echof ""
      else
         # Verify the port is available
         "$INSPECTOR" -P $portin
         if [ $? -ne 0 ]; then
            echof "$ENTRY0037"
            echof ""
         else
            PORT=$portin
            wflag=1
         fi
      fi
   done
fi

# Determine and verify the user
if [ $uflag -eq 0 ]; then
   # If we're root, we can choose which user to run the webserver as
   if [ $MYLOGIN = root ]; then
      wflag=0
      while [ $wflag -eq 0 ]; do
         if [ $upgrade -eq 0 ]; then
            echof "$ENTRY0043 [$ENTRY0008: $WUSER]"
            $echo "-> ${nnl}"
         else
            if [ -r "$INSTALLVARDIR/urchinwebd.conf" ]; then
               user=`grep "^User" "$INSTALLVARDIR/urchinwebd.conf" | cut -d " " -f 2`
            elif [ -r "$INSTALLDIR/etc/httpd.conf" ]; then
               user=`grep "^User" "$INSTALLDIR/etc/httpd.conf" | cut -d " " -f 2`
            fi
            if [ x$user != x ]; then
               WUSER=$user
            fi
            echof "$ENTRY0043 [$ENTRY0008: $WUSER]"
            $echo "-> ${nnl}"
         fi
         read userin
         echof ""
         if [ x$userin = x ]; then
            userin=$WUSER
         fi
         if [ $userin = root ]; then
            echof "$ENTRY0034"
            echof ""
         else
            id $userin > /dev/null 2>&1
            if [ $? -ne 0 ]; then
               echof "$ENTRY0032"
               echof ""
            else
               WUSER=$userin
               wflag=1
            fi
         fi
      done
   fi
fi

# Determine and verify the group
if [ $gflag -eq 0 ]; then
   # If we're root, we can choose which group to run the webserver as
   if [ $MYLOGIN = root ]; then
      wflag=0
      while [ $wflag -eq 0 ]; do
         if [ $OS = SunOS ]; then
            if [ -f /usr/xpg4/bin/id ]; then
               WGROUP=`/usr/xpg4/bin/id -gn $WUSER`
            fi 
         else
            WGROUP=`id -gn $WUSER`
         fi
         if [ x$WGROUP = x ]; then
            WGROUP=`groups $WUSER | awk '{print $1}'`
         fi
         if [ $upgrade -eq 0 ]; then
            echof "$ENTRY0044 [$ENTRY0008: $WGROUP]"
            $echo "-> ${nnl}"
         else
            if [ -r "$INSTALLVARDIR/urchinwebd.conf" ]; then
               group=`grep "^Group" "$INSTALLVARDIR/urchinwebd.conf" | cut -d " " -f 2`
            elif [ -r "$INSTALLDIR/etc/httpd.conf" ]; then
               group=`grep "^Group" "$INSTALLDIR/etc/httpd.conf" | cut -d " " -f 2`
            fi
            if [ x$group != x ]; then
               WGROUP=$group
            fi
            echof "$ENTRY0044 [$ENTRY0008: $WGROUP]"
            $echo "-> ${nnl}"
         fi
         read groupin
         echof ""
         if [ x$groupin = x ]; then
            groupin=$WGROUP
         fi
         touch "$INSTALLDIR/.urchin$$"
         chgrp $groupin "$INSTALLDIR/.urchin$$" > /dev/null 2>&1
         if [ $? != 0 ]; then
            echof "$ENTRY0029"
            echof ""
         else
            WGROUP=$groupin
            wflag=1
         fi
         rm "$INSTALLDIR/.urchin$$"
      done
   fi
fi

# Verify the user wishes to start the webserver and scheduler
if [ $sflag -eq 0 ]; then
   wflag=0
   while [ $wflag -eq 0 ]; do
      echof "$ENTRY0045 [$ENTRY0008: 1]"
      echof "   1. $ENTRY0022"
      echof "   2. $ENTRY0023"
      $echo "-> ${nnl}"
      read ans
      case $ans in
         ""|1) startservers=1
               wflag=1
               ;;
            2) startservers=0
               wflag=1
               ;;
            *) echof "$ENTRY0010"
               ;;
      esac
      echof ""
   done
fi

# Print summary information for installation
if [ $qflag -eq 0 ]; then
   echof "------------------------------------------------------------------------"
   echof "-- $ENTRY0046"
   if [ $upgrade -eq 0 ]; then
      echof "-- $ENTRY0047 $MAJORVERSION.$MINORVERSION"
   else
      echof "-- $ENTRY0048 $MAJORVERSION.$MINORVERSION"
   fi
   echof "------------------------------------------------------------------------"
   echof ""
   echof "$ENTRY0049: $INSTALLDIR"
   echof "$ENTRY0050: $PORT"
   echof "$ENTRY0051: $WUSER"
   echof "$ENTRY0052: $WGROUP"
   if [ $startservers -eq 1 ]; then
      echof "$ENTRY0053: $ENTRY0022"
   else
      echof "$ENTRY0053: $ENTRY0023"
   fi
   echof ""
fi

# Prompt user to continue or exit
if [ $qflag -eq 0 ]; then
   wflag=0
   while [ $wflag -eq 0 ]; do
      echof "$ENTRY0055 [$ENTRY0008: 1]"
      echof "   1. $ENTRY0059"
      echof "   2. $ENTRY0086"
      $echo "-> ${nnl}"
      read ans
      case $ans in
         ""|1) wflag=1
               ;;
            2) if [ $upgrade -eq 1 ]; then
                  echof "$ENTRY0087"
                  if [ -f "$INSTALLDIR/bin/urchinctl" ]; then
                     "$INSTALLDIR/bin/urchinctl" start
                  elif [ -f "$INSTALLDIR/bin/wrapper" ]; then
                     cd "$INSTALLDIR/bin"
                     ./wrapper -enable
                     cd "$CURRENTDIR"
                  fi
               fi
               exit 0
               ;;
            *) echof "$ENTRY0010"
               ;;
      esac
   done
   echof ""
fi

# Backup configuration databases and files
if [ $upgrade -eq 1 ]; then
   if [ $qflag -eq 0 ]; then
      echof "$ENTRY0056"
      "$INSTALLDIR/util/uconf-export" -f "$INSTALLDIR/util/conf.backup.$NOW"
      echof ""
   else
      "$INSTALLDIR/util/uconf-export" -f "$INSTALLDIR/util/conf.backup.$NOW" > /dev/null 2>&1
   fi
   SESSIONCONF="$INSTALLDIR/etc/session.conf"
   URCHINCONF="$INSTALLDIR/etc/urchin.conf"
   HTTPDCONF="$INSTALLDIR/etc/httpd.conf"
   URCHINWEBDCONF="$INSTALLVARDIR/urchinwebd.conf.template"
   if [ -f "$SESSIONCONF" ]; then
      mv "$SESSIONCONF" "$SESSIONCONF.sav$NOW"
   fi
   if [ -f "$URCHINCONF" ]; then
      mv "$URCHINCONF" "$URCHINCONF.sav$NOW"
   fi
   if [ -f "$HTTPDCONF" ]; then
      mv "$HTTPDCONF" "$HTTPDCONF.sav$NOW"
   fi
   if [ -f "$URCHINWEBDCONF" ]; then
      mv "$URCHINWEBDCONF" "$URCHINWEBDCONF.sav$NOW"
   fi
fi

# Uncompress and extract files into the installation directory
if [ $upgrade -eq 0 ]; then
   if [ $qflag -eq 0 ]; then
      echof "$ENTRY0058"
      echof ""
   fi
   "$GUNZIP" -c "$DIST" | (cd "$INSTALLDIR"; tar xf -)
else
   if [ $qflag -eq 0 ]; then
      echof "$ENTRY0062"
      echof ""
   fi
   if [ ! -d "$INSTALLERDIR/tmp.$NOW.$$" ]; then
      mkdir "$INSTALLERDIR/tmp.$NOW.$$"
      if [ $? -gt 0 ]; then
         echof "## $ENTRY0001: $ENTRY0024: $INSTALLERDIR/tmp.$NOW.$$"
         exit 1
      fi
   fi
   "$GUNZIP" -c "$DIST" | (cd "$INSTALLDIR"; tar xf - bin doc etc htdocs lib util)
   "$GUNZIP" -c "$DIST" | (cd "$INSTALLERDIR/tmp.$NOW.$$"; tar xf - data var)
   cd "$INSTALLERDIR/tmp.$NOW.$$/data"
   tar cf - admin cache conf geodata history logs reports session | (cd "$INSTALLERDIR"; cd "$INSTALLDATADIR"; tar xf -)
   cd "$INSTALLERDIR/tmp.$NOW.$$/var"
   tar cf - * | (cd "$INSTALLERDIR"; cd "$INSTALLVARDIR"; tar xf -)
   cd "$INSTALLERDIR"
   /bin/rm -rf "$INSTALLERDIR/tmp.$NOW.$$"
fi

# Create webserver configuration template and startup/shutdown script
if [ $qflag -eq 0 ]; then
   echof "$ENTRY0060"
   echof ""
fi
sed -e "s^XXXUSERXXX^${WUSER}^" -e "s^XXXGROUPXXX^${WGROUP}^" "$INSTALLVARDIR/urchinwebd_unix.conf.template" > "$INSTALLVARDIR/urchinwebd.conf.template"
rm -f "$INSTALLVARDIR/urchinwebd_unix.conf.template"
sed -e "s^XXXINSTALLDIRXXX^${INSTALLDIR}^" "$INSTALLDIR/util/urchin_daemons.template" > "$INSTALLDIR/util/urchin_daemons"

# Save distributed configuration files with .dist extension
if [ -f "$SESSIONCONF" ]; then
   cp "$SESSIONCONF" "$SESSIONCONF.dist"
fi
if [ -f "$URCHINCONF" ]; then
   cp "$URCHINCONF" "$URCHINCONF.dist"
fi
if [ -f "$URCHINWEBDCONF" ]; then
   cp "$URCHINWEBDCONF" "$URCHINWEBDCONF.dist"
fi

# Copy saved configuration files back into position
if [ $upgrade -eq 1 ]; then
   if [ -f "$SESSIONCONF.sav$NOW" ] && [ $OLDVERSION -ge "5000" ]; then
      cp "$SESSIONCONF.sav$NOW" "$SESSIONCONF"
   fi
   if [ -f "$URCHINCONF.sav$NOW" ]; then
      cp "$URCHINCONF.sav$NOW" "$URCHINCONF"
   fi
   if [ -f "$URCHINWEBDCONF.sav$NOW" ]; then
      sed -e "s/^User[ \t].*/User ${WUSER}/" -e "s/^Group[ \t].*/Group ${WGROUP}/" "$URCHINWEBDCONF.sav$NOW" > "$URCHINWEBDCONF"
   fi
fi

# Warn users if configuration files differ from distributed files
if [ $upgrade -eq 1 ]; then
   if [ -f "$SESSIONCONF" ] && [ -f "$SESSIONCONF.dist" ]; then
      `diff "$SESSIONCONF" "$SESSIONCONF.dist" > /dev/null 2>&1` 
      if [ $? -ne 0 ]; then
         echof "## $ENTRY0090: $ENTRY0057: $SESSIONCONF"
         echof ""
      fi
   fi
   if [ -f "$URCHINCONF" ] && [ -f "$URCHINCONF.dist" ]; then
      `diff "$URCHINCONF" "$URCHINCONF.dist" > /dev/null 2>&1` 
      if [ $? -ne 0 ]; then
         echof "## $ENTRY0090: $ENTRY0057: $URCHINCONF"
         echof ""
      fi
   fi
   if [ -f "$URCHINWEBDCONF" ] && [ -f "$URCHINWEBDCONF.dist" ]; then
      `diff "$URCHINWEBDCONF" "$URCHINWEBDCONF.dist" > /dev/null 2>&1` 
      if [ $? -ne 0 ]; then
         echof "## $ENTRY0090: $ENTRY0057: $URCHINWEBDCONF"
         echof ""
      fi
   fi
fi

# Move the domain databases into place if they don't exist
if [ ! -f "$INSTALLDATADIR/geodata/domain.unf" ] || [ ! -f "$INSTALLDATADIR/geodata/domain.unh" ] || [ ! -f "$INSTALLDATADIR/geodata/domain.uni" ] || [ ! -f "$INSTALLDATADIR/geodata/domain.uns" ]; then
   mv "$INSTALLDATADIR/geodata/.domain.unf" "$INSTALLDATADIR/geodata/domain.unf"
   mv "$INSTALLDATADIR/geodata/.domain.unh" "$INSTALLDATADIR/geodata/domain.unh"
   mv "$INSTALLDATADIR/geodata/.domain.uni" "$INSTALLDATADIR/geodata/domain.uni"
   mv "$INSTALLDATADIR/geodata/.domain.uns" "$INSTALLDATADIR/geodata/domain.uns"
else
   rm "$INSTALLDATADIR/geodata/.domain.unf"
   rm "$INSTALLDATADIR/geodata/.domain.unh"
   rm "$INSTALLDATADIR/geodata/.domain.uni"
   rm "$INSTALLDATADIR/geodata/.domain.uns"
fi
if [ ! -f "$INSTALLDATADIR/geodata/domain.local" ]; then
   mv "$INSTALLDATADIR/geodata/.domain.local" "$INSTALLDATADIR/geodata/domain.local"
else
   rm "$INSTALLDATADIR/geodata/.domain.local"
fi

# Remove outdated files (for upgrade only)
if [ $upgrade -eq 1 ]; then
   # For upgrade from 4.006 to 4.100+
   rm -f "$INSTALLDIR/bin/httpd"
   rm -f "$INSTALLDIR/bin/httpdctl.sh"
   rm -f "$INSTALLDIR/bin/urchindctl.sh"
   rm -f "$INSTALLDIR/bin/wrapper"
   rm -f "$INSTALLDIR/etc/httpd.conf"
   rm -f "$INSTALLDIR/etc/httpd.conf.template"
   rm -f "$INSTALLDIR/etc/httpd.conf.template_unix"
   # For upgrade from 4.002 to 4.003+
   rm -f "$INSTALLDIR/htdocs/ujs/calender.js"
   # For upgrade from 4.101 to 4.102+
   rm -f "$INSTALLDIR/util/setup_conf.sh"
   # For upgrade from 4.102+ to 5.000
   rm -rf "$INSTALLDIR/lib/languages"
   rm -rf "$INSTALLDIR/lib/templates"
   rm -rf "$INSTALLDIR/lib/ugroups"
   rm -rf "$INSTALLDIR/lib/views"
fi

# Initialize or update the configuration databases
if [ $upgrade -eq 0 ]; then
   if [ $qflag -eq 0 ]; then
      echof "$ENTRY0061"
      echof ""
      "$INSTALLDIR/util/uconf-import" -r -f "$INSTALLDIR/util/initialdb.config"
      echof ""
   else
      "$INSTALLDIR/util/uconf-import" -r -f "$INSTALLDIR/util/initialdb.config" > /dev/null 2>&1
   fi
else
   if [ $qflag -eq 0 ]; then
      echof "$ENTRY0063"
      echof ""
      "$INSTALLDIR/util/uconf-import" -f "$INSTALLDIR/util/initialdb.config"
      echof ""
   else
      "$INSTALLDIR/util/uconf-import" -f "$INSTALLDIR/util/initialdb.config" > /dev/null 2>&1
   fi
fi

# Update __domaindb task with day/time for download
SETDATE=`"$INSTALLDIR/util/uconf-driver" table=task name=__domaindb action=get_parameter parameter=ct_setdate`
if [ "x$SETDATE" != "x1" ]; then
   DAY=`date +%d`
   if [ $DAY -eq 1 ]; then
      DAY=28
   else
      DAY=`expr $DAY - 1`
   fi
   if [ $DAY -lt 1 ] || [ $DAY -gt 28 ]; then
      DAY=1
   fi
   HOUR=`date +%H`
   if [ $HOUR -lt 0 ] || [ $HOUR -gt 23 ]; then
      HOUR=0
   fi
   MIN=`date +%M`
   if [ $MIN -lt 0 ] || [ $MIN -gt 59 ]; then
      MIN=0
   fi
   "$INSTALLDIR/util/uconf-driver" action=set_parameter cs_dom=$DAY table=task name=__domaindb > /dev/null 2>&1
   "$INSTALLDIR/util/uconf-driver" action=set_parameter cs_hour=$HOUR table=task name=__domaindb > /dev/null 2>&1
   "$INSTALLDIR/util/uconf-driver" action=set_parameter cs_minute=$MIN table=task name=__domaindb > /dev/null 2>&1
   "$INSTALLDIR/util/uconf-driver" action=set_parameter ct_setdate=1 table=task name=__domaindb > /dev/null 2>&1
fi

# Set the user and group on the installed files.
# Only change owner if installer is run as root
if [ $qflag -eq 0 ]; then
   echof "$ENTRY0064"
   if [ $MYLOGIN = root ]; then
      chown -R $WUSER "$INSTALLDIR"
      chown -R $WUSER "$INSTALLDATADIR"
   fi
   chgrp -R $WGROUP "$INSTALLDIR"
   chgrp -R $WGROUP "$INSTALLDATADIR"
   # Use the installed inspector in repair mode to set the permissions of the files
   "$INSTALLDIR/util/inspector" -R
   if [ $? -ne 0 ]; then
      echof ""
      echof "## $ENTRY0001: $ENTRY0067"
   fi
   echof ""
else
   if [ $MYLOGIN = root ]; then
      chown -R $WUSER "$INSTALLDIR"
      chown -R $WUSER "$INSTALLDATADIR"
   fi
   chgrp -R $WGROUP "$INSTALLDIR"
   chgrp -R $WGROUP "$INSTALLDATADIR"
   # Use the installed inspector in repair mode to set the permissions of the files
   "$INSTALLDIR/util/inspector" -R > /dev/null 2>&1
   if [ $? -ne 0 ]; then
      echof "## $ENTRY0001: $ENTRY0067"
   fi
fi

# Start the Urchin webserver and scheduler daemon
if [ $startservers -eq 1 ]; then
   if [ $qflag -eq 0 ]; then
      echof "$ENTRY0065"
      "$INSTALLDIR/bin/urchinctl" -p $PORT start
      echof ""
   else
      "$INSTALLDIR/bin/urchinctl" -p $PORT start > /dev/null 2>&1
   fi
else
   "$INSTALLDIR/bin/urchinctl" -p $PORT status > /dev/null 2>&1
fi

# Administrative announcements
if [ $qflag -eq 0 ]; then
   echof "------------------------------------------------------------------------"
   echof "-- $ENTRY0066"
   echof "------------------------------------------------------------------------"
   echof ""
   if [ $startservers -eq 1 ]; then
      echof "$ENTRY0068"
   else
      echof "$ENTRY0069"
   fi
   echof ""
   echof "   http://${HOST}:${PORT}/"
   echof ""
   echof "$ENTRY0071"
   echof ""
   echof "$ENTRY0070"
fi
