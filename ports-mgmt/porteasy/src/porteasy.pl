#!/usr/bin/perl -w
#-
# Copyright (c) 2000 Dag-Erling Co�dan Sm�rgrav
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer
#    in this position and unchanged.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#      $FreeBSD$
#

use strict;
use Fcntl;
use Getopt::Long;

my $VERSION	= "2.2";
my $COPYRIGHT	= "Copyright (c) 2000 Dag-Erling Sm�rgrav. All rights reserved.";

# Constants
sub ANONCVS_ROOT	{ ":pserver:anoncvs\@anoncvs.FreeBSD.org:/home/ncvs" }
sub REQ_EXPLICIT	{ 1 }
sub REQ_IMPLICIT	{ 2 }
sub REQ_MASTER		{ 4 }

sub PATH_CVS		{ "/usr/bin/cvs" }
sub PATH_LDCONFIG	{ "/sbin/ldconfig" }
sub PATH_MAKE		{ "/usr/bin/make" }

# Global parameters
my $dbdir     = "/var/db/pkg";	# Package database directory
my $index     = undef;		# Index file
my $portsdir  = "/usr/ports";	# Ports directory
my $tag	      = undef;		# cvs tag to use
my $date      = undef;		# cvs date to use

# Global flags
my $anoncvs   = 0;		# Use anoncvs.FreeBSD.org
my $clean     = 0;		# Clean ports
my $cvsroot   = 0;		# CVS root directory
my $exclude   = 0;		# Do not list installed ports
my $fetch     = 0;		# Fetch ports
my $force     = 0;		# Force package registration
my $info      = 0;		# Show port info
my $dontclean = 0;		# Don't clean after build
my $packages  = 0;		# Build packages
my $list      = 0;		# List ports
my $plist     = 0;		# Print packing list
my $build     = 0;		# Build ports
my $update    = 0;		# Update ports tree from CVS
my $verbose   = 0;		# Verbose mode

# Global variables
my %ports;			# Maps ports to their directory.
my %pkgname;			# Inverse of the above map
my %masterport;			# Maps ports to their master ports
my %reqd;			# Ports that need to be installed
my %installed;			# Ports that are already installed
my $suppressed;			# Suppress output

#
# Shortcut for 'print STDERR'
#
sub stderr(@) {
    print(STDERR @_);
}

#
# Similar to err(3)
#
sub bsd::err($$@) {
    my $code = shift;		# Return code
    my $fmt = shift;		# Format string
    my @args = @_;		# Arguments

    my $msg;			# Error message

    $msg = sprintf($fmt, @args);
    stderr("$msg: $!\n");
    exit($code);
}

#
# Similar to errx(3)
#
sub bsd::errx($$@) {
    my $code = shift;		# Return code
    my $fmt = shift;		# Format string
    my @args = @_;		# Arguments

    my $msg;			# Error message

    $msg = sprintf($fmt, @args);
    stderr("$msg\n");
    exit($code);
}

#
# Similar to warn(3)
#
sub bsd::warn($@) {
    my $fmt = shift;		# Format string
    my @args = @_;		# Arguments

    my $msg;			# Error message

    $msg = sprintf($fmt, @args);
    stderr("$msg: $!\n");
}

#
# Similar to warnx(3)
#
sub bsd::warnx($@) {
    my $fmt = shift;		# Format string
    my @args = @_;		# Arguments

    my $msg;			# Error message

    $msg = sprintf($fmt, @args);
    stderr("$msg\n");
}

#
# Call the specified sub with output suppressed
#
sub suppress($@) {
    my $subr = shift;		# Subroutine to call
    my @args = @_;		# Arguments

    my $oldsuppressed;		# Old suppress flag
    my $rtn;			# Return value

    if (!$verbose) {
	$oldsuppressed = $suppressed;
	$suppressed = 1;
    }
    $rtn = &{$subr}(@args);
    if (!$verbose) {
	$suppressed = $oldsuppressed;
    }
    return $rtn;
}
    

#
# Print an info message
#
sub info(@) {

    my $msg;			# Message

    if ($verbose) {
	$msg = join(' ', @_);
	chomp($msg);
	stderr("$msg\n");
    }
}

#
# Print an info message about a subprocess
#
sub cmdinfo(@) {
    info(">>>", @_);
}

#
# Change working directory
#
sub cd($) {
    my $dir = shift;		# Directory to change to

    cmdinfo("cd $dir");
    chdir($dir)
	or bsd::err(1, "unable to chdir to %s", $dir);
}

#
# Run a command and return its output
#
sub cmd($@) {
    my $cmd = shift;		# Command to run
    my @args = @_;		# Arguments

    my $pid;			# Child pid
    local *PIPE;		# Pipe
    my $output;			# Output

    cmdinfo(join(" ", $cmd, @args));
    if (!defined($pid = open(PIPE, "-|"))) {
	bsd::err(1, "open()");
    } elsif ($pid == 0) {
	exec($cmd, @args);
	die("child: exec(): $!\n");
    }
    $output = "";
    while (<PIPE>) {
	$output .= $_;
	if (!$suppressed) {
	    stderr($_);
	}
    }
    if (!close(PIPE)) {
	if ($? & 0xff) {
	    bsd::warnx("%s caught signal %d", $cmd, $? & 0x7f);
	} elsif ($? >> 8) {
	    bsd::warnx("%s returned exit code %d", $cmd, $? >> 8);
	} else {
	    bsd::warn("close()");
	}
	return undef;
    }
    return $output || "\n";
}

#
# Run CVS
#
sub cvs($;@) {
    my $cmd = shift;		# CVS command

    my @args;			# Arguments to CVS

    if (!$update) {
	return "\n";
    }
    if (!$verbose) {
	push(@args, "-q");
    }
    push(@args, "-f", "-z3", "-R", "-d$cvsroot", $cmd, "-A");
    if ($cmd eq "checkout") {
	push(@args, "-P");
    } elsif ($cmd eq "update") {
	push(@args, "-P", "-d");
    }
    if ($tag) {
	push(@args, "-r$tag");
    }
    if ($date) {
	push(@args, "-D$date");
    }
    push(@args, @_);
    return cmd(&PATH_CVS, @args);
}

#
# Run make
#
sub make($@) {
    my $port = shift;		# Port category/name
    my @args = @_;
    
    push(@args, "PORTSDIR=$portsdir")
	unless ($portsdir eq "/usr/ports");
    cd("$portsdir/$port");
    return cmd(&PATH_MAKE, @args);
}

#
# The undocumented command.
#
sub ecks() {

    local *FILE;		# File handle

    sysopen(FILE, "/var/db/port.mkversion", O_RDWR|O_CREAT|O_TRUNC, 0644)
	or bsd::err(1, "open()");
    print(FILE "20380119\n");
    close(FILE);
}

#
# Update the index file
#
sub update_index() {
    
    my $parent;		# Parent directory

    $parent = $portsdir;
    $parent =~ s/\/*ports\/*$//;
    cd($parent);
    if (-f "ports/INDEX" || (-d "ports" && -d "ports/CVS")) {
	cvs("update", "ports/INDEX")
	    or bsd::errx(1, "error updating the index file");
    } else {
	cvs("checkout", "-l", "ports")
	    or bsd::errx(1, "error checking out the index file");
    }
    cvs("update", "-l", "ports/Mk")
	or bsd::errx(1, "error updating the Makefiles");
}

#
# Read the ports index
#
sub read_index() {

    local *INDEX;		# File handle
    my $line;			# Line from file

    info("Reading index file");
    sysopen(INDEX, $index, O_RDONLY)
	or bsd::err(1, "can't open $index");
    while ($line = <INDEX>) {
	my @port;		# Port info

	@port = split(/\|/, $line, 3);
	$port[1] =~ s|^/usr/ports/*||;
	$ports{$port[0]} = $port[1];
	$pkgname{$port[1]} = $port[0];
    }
    close(INDEX);
    info(keys(%ports) . " ports in index");
}

#
# Find a port by a portion of it's package name
#
sub find_port($) {
    my $port = shift;		# Port to find

    my @suggest;		# Suggestions
    
    stderr("Can't find required port '$port'");
    @suggest = grep(/^$port/i, keys(%ports));
    if (@suggest == 1 && $suggest[0] =~ m/^$port[0-9.-]/) {
	$port = $ports{$suggest[0]};
	stderr(", assuming you mean $pkgname{$port}.\n");
	return $port;
    } elsif (@suggest) {
	stderr(", maybe you mean:\n  " . (join("\n  ", @suggest)));
    }
    stderr("\n");
    return undef;
}

#
# Add a port to the list of required ports
#
sub add_port($$) {
    my $port = shift;		# Port to add
    my $req = shift;		# Requirement (explicit or implicit)

    my $realport;		# Real port name
    
    if ($port =~ m|^([^/]+/[^/]+)$|) {
	$realport = $1;
    } else {
	if (exists($ports{$port})) {
	    $realport = $ports{$port};
	} else {
	    $realport = find_port($port);
	}
    }
    if (!$realport) {
	return 1;
    }
    if (!exists($reqd{$realport})) {
	$reqd{$realport} = 0;
    }
    $reqd{$realport} |= $req;
    return 0;
}

#
# Find master directory for a port
#
sub find_master($) {
    my $port = shift;		# Port

    local *FILE;		# File handle
    my $master;			# Master directory

    if ($masterport{$port}) {
	return $masterport{$port};
    }
    
    # Look for MASTERDIR in the Makefile. We can't use 'make -V'
    # because the Makefile might try to include the master port's
    # Makefile, which might not be checked out yet.
    open(FILE, "$portsdir/$port/Makefile")
	or bsd::err(1, "unable to read Makefile for $port");
    while (<FILE>) {
	if (/^MASTERDIR\s*=\s*(\S+)\s*$/) {
	    $master = $1;
	} elsif (/^\.?include \"([^\"]+)\/Makefile\"\s*$/) {
	    $master = $1;
	}
	if (defined($master)) {
	    $master =~ s/^\$\{.CURDIR\}//;
	    $master = "/$port/$master";
	    $master =~ s|/+|/|g;
	    1 while ($master =~ s|/[^\./]*/\.\./|/|);
	    $master =~ s|^/||;
	    if ($master !~ m|^[^/]+/[^/]+$|) {
	        bsd::warn("invalid master for %s: %s", $port, $master);
		next;
	    }
	    close(FILE);
	    info("$master is master for $port\n");
	    return $masterport{$port} = $master;
	}
    }
    close(FILE);
    return undef;
}

#
# Find a dynamic library
#
sub find_library($) {
    my $library = shift;	# Library to find

    my $ldconfig;		# Output from ldconfig(8)

    $ldconfig = suppress(\&cmd, (&PATH_LDCONFIG, "-r"))
	or errx(1, "unable to run ldconfig");
    if ($ldconfig =~ m/^\s*\d+:-l$library => (.*)$/m) {
	info("The $library library is installed as $1");
	return 1;
    }
    return 0;
}

#
# Find a binary
#
sub find_binary($) {
    my $binary = shift;		# Binary to find

    my $dir;			# Directory

    if ($binary =~ m|^/|) {
	info("$binary is installed as $binary");
	return (-x $binary);
    }
    foreach $dir (split(/:/, $ENV{'PATH'})) {
	if (-x "$dir/$binary") {
	    info("$binary is installed as $dir/$binary");
	    return 1;
	}
    }
    return 0;
}

#
# Find a port's dependencies
#
sub find_dependencies($) {
    my $port = shift;		# Port

    my $dependvars;		# Dependency variables
    my $item;			# Iterator
    my %depends;		# Hash of dependencies
    my ($lhs, $rhs);		# Left, right hand side of dependency spec

    $dependvars = suppress(\&make, ($port,
				    "-VFETCH_DEPENDS",
				    "-VBUILD_DEPENDS",
				    "-VRUN_DEPENDS",
				    "-VLIB_DEPENDS",
				    "-VDEPENDS"))
	or bsd::errx(1, "failed to obtain dependency list");
    %depends = ();
    foreach $item (split(' ', $dependvars)) {
	if ($item !~ m|^([^:]+):$portsdir/([^/:]+/[^/:]+)/?(:[^:]+)?$|) {
	    bsd::warnx("invalid dependency: %s", $item);
	}
	($lhs, $rhs) = ($1, $2);
	if ($exclude) {
	    if ($installed{$rhs}) {
		next;
	    }
	    info("Verifying status of $rhs ($lhs)");
	    if (($lhs =~ m|^/| && -f $lhs) ||
		($lhs =~ m/\.\d+$/ && find_library($lhs)) ||
		find_binary($lhs)) {
		info("$rhs seems to be installed");
		$installed{$rhs} = 1;
		next;
	    }
	    $installed{$rhs} = -1;
	}
	info("Adding $rhs as a dependency for $port");
	$depends{$rhs} = 1;
    }
    return keys(%depends);
}

#
# Update all necessary files to build the specified ports
#
sub update_ports_tree(@) {
    my @ports = @_;		# Ports to update
    
    my $port;			# Port name
    my $category;		# Category name
    my %upd_cat;		# Hash of updated categories
    my %upd_port;		# Hash of updated ports
    my %processed;		# Hash of processed ports
    my @additional;		# Additional dependencies
    my $n;			# Pass count

    foreach $port (@ports) {
	push(@additional, $port);
    }
    for ($n = 0; ; ++$n) {
	my @update_now;		# Ports that need updating now
	my $item;		# Iterator
	my $master;		# Master port
	my $dependency;		# Dependency
	
	# Determine which ports need updating
	foreach $item (@additional) {
	    next if $processed{$item};
	    ($category, $port) = split(/\//, $item);
	    if (!exists($upd_port{$category})) {
		$upd_port{$category} = {};
	    }
	    if (!exists($upd_port{$category}->{$port})) {
		$upd_port{$category}->{$port} = 0;
	    }
	    push(@update_now, $item);
	}
	last unless @update_now;
	info("Pass $n:", @update_now);
	
	# Update the relevant sections of the ports tree
	foreach $category (keys(%upd_port)) {
	    my @ports;		# Ports to update
	    
	    if (!$upd_cat{$category}) {
		cd($portsdir);
		cvs("update", "-l", $category)
		    or bsd::errx(1, "error updating the '$category' category");
		$upd_cat{$category} = 1;
	    }
	    foreach $port (keys(%{$upd_port{$category}})) {
		next if ($upd_port{$category}->{$port});
		push(@ports, $port);
		$upd_port{$category}->{$port} = 1;
	    }
	    if (@ports) {
		cd("$portsdir/$category");
		cvs("update", @ports)
		    or bsd::errx(1, "error updating the '$category' category");
	    }
	}

	# Process all unprocessed ports we know of so far
	foreach $port (@update_now) {
	    # See if the port has an unprocessed master port
	    if (($master = find_master($port)) && !$processed{$master}) {
		add_port($master, &REQ_MASTER);
		info("Adding $master to head of line\n");
		unshift(@additional, $master);
		# Need to process master before we continue
		next;
	    }
	    
	    # Find the port's package name
	    if (!exists($pkgname{$port})) {
		if ($pkgname{$port} = suppress(\&make, ($port, "-VPKGNAME"))) {
		    chomp($pkgname{$port});
		} else {
		    warnx("failed to obtain package name for $port");
		}
	    }

	    # Find the port's dependencies
	    foreach $dependency (find_dependencies($port)) {
		next if ($processed{$dependency});
		if ($reqd{$port} == &REQ_MASTER) {
		    add_port($dependency, &REQ_MASTER);
		} else {
		    add_port($dependency, &REQ_IMPLICIT);
		}
		info("Adding $dependency to back of line\n");
		push(@additional, $dependency);
	    }

	    # Mark port as processed
	    $processed{$port} = 1;
	}
    }
}

#
# Show port info
#
sub show_port_info($) {
    my $port = shift;		# Port to show info for

    local *FILE;		# File handle
    my $info;			# Port info

    sysopen(FILE, "$portsdir/$port/pkg-descr", O_RDONLY)
	or bsd::err(1, "can't read description for $port");
    $info = join("| ", <FILE>);
    close(FILE);
    print("+--- Description for $port ($pkgname{$port}):\n| ${info}+---\n");
}

#
# Show port plist
#
sub show_port_plist($) {
    my $port = shift;		# Port to show plist for

    my $master;			# Master port
    local *FILE;		# File handle
    my $file;			# File name
    my %files;			# Files to list
    my $prefix;			# Prefix

    $prefix = suppress(\&make, ($port, "-VPREFIX"));
    chomp($prefix);
    $master = $port;
    while (!-f "$portsdir/$master/pkg-plist") {
	if (!($master = $masterport{$master})) {
	    bsd:errx(1, "$port has no packing list");
	}
    }
    sysopen(FILE, "$portsdir/$master/pkg-plist", O_RDONLY)
	or bsd::err(1, "can't read packing list for $port");
    while (<FILE>) {
	chomp();
	$file = undef;
	if (m/^[^\@]/) {
	    $file = $_;
	} elsif (m/^\@cwd\s+(\S+)\s*$/) {
	    $prefix = $1;
	} elsif (m/^\@dirrm\s+(\S+)\s*$/) {
	    $file = "$1/";
	} elsif (m/^\@comment\s+/) {
	    # ignore
	} else {
	    bsd::warnx("unrecognized plist directive: $_");
	}
	if (defined($file)) {
	    if ($file !~ m/^\//) {
		$file = "$prefix/$file";
	    }
	    $file =~ s|/+|/|g;
	    $files{$file} = 1;
	}
    }
    close(FILE);
    # XXX list man pages?
    print("+--- Packing list for $port ($pkgname{$port}):\n");
    foreach (sort(keys(%files))) {
	print("| $_\n");
    }
    print("+---\n");
}

#
# List installed ports
#
sub list_installed() {

    local *DIR;			# Directory handle
    my $port;			# Port name
    my $unknown;		# Unknown ports

    opendir(DIR, $dbdir)
	or bsd::err(1, "can't read database directory");
    print("Installed ports:\n");
    foreach $port (readdir(DIR)) {
	next if ($port eq "." || $port eq ".." || ! -d "$dbdir/$port");
	if (exists($ports{$port})) {
	    print("   $port\n");
	} else {
	    print(" ? $port\n");
	    ++$unknown;
	}
    }
    if ($unknown) {
	print("Recommend you run pkg_version(1).\n");
    }
}

#
# Clean a port
#
sub clean_port($) {
    my $port = shift;		# Port to clean

    make($port, "clean")
	or bsd::warnx("failed to clean %s", $port);
}

#
# Clean the tree
#
sub clean_tree() {

    my $port;			# Port name
    
    # We could just cd to $portsdir and 'make clean', but it'd
    # be extremely noisy due to only having a partial tree
    foreach $port (keys(%ports)) {
	if (-d "$portsdir/$port") {
	    make($port, "clean", "NO_DEPENDS=yes")
		or bsd::warnx("failed to clean %s", $port);
	}
    }
}

#
# Fetch a port
#
sub fetch_port($) {
    my $port = shift;		# Port to fetch

    make($port, "fetch")
	or bsd::errx(1, "failed to fetch %s", $port);
}

#
# Build a port
#
sub build_port($) {
    my $port = shift;		# Port to build

    my @makeargs;		# Arguments to make()

    if ($packages) {
	push(@makeargs, "package", "DEPENDS_TARGET=package");
    } else {
	push(@makeargs, "install");
    }
    if ($force) {
	push(@makeargs, "-DFORCE_PKG_REGISTER");
    }
    if (!$dontclean) {
	push(@makeargs, "clean");
    }
    make($port, @makeargs)
	or bsd::errx(1, "failed to %s %s", $packages ? "package" : "build", $port);
}

#
# Print usage message and exit
#
sub usage() {

    stderr("Usage: porteasy [-abCceFfhikluVv] [-d dir] [-D date]\n" .
	   "    [-p dir] [-r dir] [-t tag] [port ...]\n");
    exit(1);
}

#
# Print version
#
sub version() {

    stderr("This is porteasy $VERSION.
$COPYRIGHT
");
    exit(1);
}

#
# Print help text
#
sub help() {

    stderr("This is porteasy $VERSION.
$COPYRIGHT

Options:
  -a, --anoncvs            Use the FreeBSD project's anoncvs server
  -b, --build              Build required ports
  -c, --clean              Clean the specified ports
  -C, --dontclean          Don't clean after build
  -e, --exclude-installed  Exclude installed ports
  -f, --fetch              Fetch distfiles
  -h, --help               Show this information
  -i, --info               Show info about specified ports
  -k, --packages           Build packages for the specified ports
  -L, --plist	           Show the packing lists for the specified ports
  -l, --list               List required ports and their dependencies
  -u, --update             Update relevant portions of the ports tree
  -V, --version	           Show version number
  -v, --verbose            Verbose mode

Parameters:
  -D, --date=DATE          Specify CVS date
  -d, --dbdir=DIR          Specify package directory (default $dbdir)
  -p, --portsdir=DIR       Specify ports directory (default $portsdir)
  -r, --cvsroot=DIR        Specify CVS root
  -t, --tag=TAG            Specify CVS tag

Report bugs to <des\@freebsd.org>.
");
    exit(1);
}

MAIN:{
    my $port;			# Port name
    my $err = 0;		# Error count
    my $need_index;		# Need the index

    # Get option defaults
    if ($ENV{'PORTEASY_OPTIONS'}) {
	foreach (split(' ', $ENV{'PORTEASY_OPTIONS'})) {
	    unshift(@ARGV, $_);
	}
    }
    
    # Scan command line options
    Getopt::Long::Configure("auto_abbrev", "bundling");
    GetOptions(
	       "a|anoncvs"		=> \$anoncvs,
	       "b|build"		=> \$build,
	       "c|clean"		=> \$clean,
	       "C|dontclean"		=> \$dontclean,
	       "D|date=s"		=> \$date,
	       "d|dbdir=s"		=> \$dbdir,
	       "e|exclude-installed"	=> \$exclude,
	       "F|force-pkg-register"	=> \$force,
	       "f|fetch"		=> \$fetch,
	       "h|help"			=> \&help,
	       "i|info"			=> \$info,
	       "k|packages"		=> \$packages,
	       "L|plist"		=> \$plist,
	       "l|list"			=> \$list,
	       "p|portsdir=s"		=> \$portsdir,
	       "r|cvsroot=s"		=> \$cvsroot,
	       "t|tag=s"		=> \$tag,
	       "u|update"		=> \$update,
	       "V|version"		=> \&version,
	       "v|verbose"		=> \$verbose,
	       "x|ecks"			=> \&ecks,
	       )
	or usage();

    if (!($clean || $fetch || $info || $list || $packages || $plist)) {
	$build = 1;
    }
    
    if (!@ARGV && ($build || $fetch || $list || $packages || $plist)) {
	usage();
    }
        
    if ($portsdir !~ m/^\//) {
	$portsdir = `pwd` . $portsdir;
	$portsdir =~ s/\n/\//s;
    }

    if ($portsdir !~ m/\/ports\/?$/) {
	bsd::errx(1, "ports directory must be named 'ports'");
    }
    
    $index = "$portsdir/INDEX";

    # 'package' implies 'build'
    if ($packages) {
	$build = 1;
    }
    
    # Set and check CVS root
    if ($anoncvs && !$cvsroot) {
	$cvsroot = &ANONCVS_ROOT;
    }
    if (!$cvsroot) {
	$cvsroot = $ENV{'CVSROOT'};
    }
    if ($update && !$cvsroot) {
	bsd::errx(1, "No CVS root, please use the -r option or set \$CVSROOT");
    }

    # Check if we need the index
    if (!@ARGV && $info) {
	$need_index = 1;
    }
    foreach $port (@ARGV) {
	if ($port !~ m/\//) {
	    $need_index = 1;
	}
    }
    
    # Step 1: read the ports index
    if ($need_index) {
	update_index();
	read_index();
    }

    # Step 2: build list of explicitly required ports
    foreach $port (@ARGV) {
	$err += add_port($port, &REQ_EXPLICIT);
    }
    if ($err) {
	bsd::errx(1, "some required ports were not found.");
    }

    # Step 3: update port directories and discover dependencies
    if (!($build || $fetch || ($info && @ARGV) || $list)) {
	$update = 0;
    }
    update_ports_tree(keys(%reqd));

    # Step 4: deselect ports which are already installed
    if ($exclude) {
	foreach $port (keys(%reqd)) {
	    if ((exists($installed{$port}) && $installed{$port} > 0) ||
		-d "$dbdir/$pkgname{$port}") {
		info("$port is already installed");
		delete $reqd{$port};
	    }
	}
    }
    
    # Step 5: list selected ports
    if ($list) {
	foreach $port (sort(keys(%reqd))) {
	    next if ($reqd{$port} == &REQ_MASTER);
	    print((($reqd{$port} & &REQ_EXPLICIT) ? " * " : "   "),
		  "$port ($pkgname{$port})\n");
	}
    }

    # Step 6: show info (or list installed packages)
    if ($info) {
	if (!@ARGV) {
	    list_installed();
	} else {
	    foreach $port (keys(%reqd)) {
		if ($reqd{$port} & &REQ_EXPLICIT) {
		    show_port_info($port);
		}
	    }
	}
    }

    # Step 7: show packing list
    if ($plist) {
	foreach $port (keys(%reqd)) {
	    if ($reqd{$port} & &REQ_EXPLICIT) {
		show_port_plist($port);
	    }
	}
    }
    
    # Step 8: clean the ports directories (or the entire tree)
    if ($clean) {
	if (!@ARGV) {
	    clean_tree();
	} else {
	    foreach $port (keys(%reqd)) {
		if ($reqd{$port} & &REQ_EXPLICIT) {
		    clean_port($port);
		}
	    }
	}
    }
    
    # Step 9: fetch distfiles
    if ($fetch) {
	foreach $port (keys(%reqd)) {
	    if ($reqd{$port} != &REQ_MASTER) {
		fetch_port($port);
	    }
	}
    }

    # Step A: build ports - only the explicitly required ones, since
    # some dependencies (most commonly XFree86) may be bogus.
    if ($build || $packages) {
	foreach $port (keys(%reqd)) {
	    if ($reqd{$port} & &REQ_EXPLICIT) {
		build_port($port);
	    }
	}
    }

    # Done!
    exit(0);
}
