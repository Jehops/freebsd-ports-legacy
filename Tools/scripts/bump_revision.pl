#!/usr/bin/env perl -wT

# $FreeBSD$

#
# This Perl script helps with bumping the PORTREVISION of all ports
# that depend on a set of ports, for instance, when in the latter set
# one of the port bumped the .so library version.
#
# It is best executed with the working directory set to the base of a
# ports tree, usually /usr/ports.
#
# You must use either the -l (shaLlow, avoid grandparent dependencies,
# slower) or -g option (include grandparend dependencies) option.
#
# MAINTAINER=	gerald@FreeBSD.org
#

use strict;
use Getopt::Std;
use Carp 'verbose';
use Cwd;
use Data::Dumper;
use File::Basename;

use vars qw/$opt_c $opt_n $opt_i $opt_u $opt_l $opt_g/;

$ENV{'PATH'} = '/bin:/usr/bin:/usr/local/bin';

sub usage {
	print <<EOF;
Usage: $0 [options] [<category>/]<portname>

Mandatory flags:
    -l              - shaLlow, only bump ports with direct dependencies.
    -g              - Grandchildren, also bump for indirect dependencies.

Optional flags:
    -c              - Check only (dry-run), do not change Makefiles.
    -n              - No tmpdir, just use the directory where INDEX resides.
    -i <filename>   - Use this for INDEX name. Defaults to /usr/ports/INDEX-n,
                      where n is the major version of the OS, or /usr/ports/INDEX if missing.

Improvements, suggestions,questions -> gerald\@FreeBSD.org
EOF
	exit 1;
}

$| = 1;

sub bumpMakefile {

    my ($p) = @_; 

    my $makefile = "$p/Makefile";
    my $fin;
	unless(open($fin, $makefile)) {
	    print "-- Cannot open Makefile of $p, ignored.\n";
	    next;
	}
	my @lines = <$fin>;
	if ($!) { die "Error while reading $makefile: $!. Aborting"; }
	close($fin) or die "Can't close $makefile b/c $!";
	chomp(@lines);

	my $revision = 1;

	foreach my $line (@lines) {
	    last if ($line =~ /^MAINTAINER/);
	    $revision += $1 if ($line =~ /PORTREVISION\??=[ \t]*(\d+)$/);
	}

	my $printedrev = 0;
	open(my $fout, '>', "$makefile.bumped");
	foreach my $line (@lines) {
	    if (!$printedrev) {
		if ($line =~ /^CATEGORIES??=/ || $line =~ /^PORTEPOCH??=/) {
		    print $fout "PORTREVISION=	$revision\n";
		    $printedrev = 1;
		    # Fall through!
		}
		if ($line =~ /^PORTREVISION\?=/) {
		    print $fout "PORTREVISION?=	$revision\n";
		    $printedrev = 1;
		    next;
		}
		if ($line =~ /^PORTREVISION=/) {
		    print $fout "PORTREVISION=	$revision\n";
		    $printedrev = 1;
		    next;
		}
	    }
	    print $fout "$line\n";
	}
	close($fout) or die "Can't close $makefile b/c $!";
	rename "$makefile.bumped", $makefile or die "Can't rename $makefile.bumped to $makefile: $!";
}

my $osversion = `uname -r`;
chomp $osversion;
$osversion =~ s/\..*//;

my $INDEX = "/usr/ports/INDEX-$osversion";
if (!-f $INDEX) { $INDEX = "/usr/ports/INDEX"; }

my $shallow = 0;
{
    $opt_i = "";
    $opt_u = "";
    getopts("cgi:lnu:");
    $INDEX = $opt_i if ($opt_i);
    $shallow = $opt_l if $opt_l;
    if (not $opt_l and not $opt_g) {
	die "Neither -g nor -l given. Aborting";
    }

    die "$INDEX doesn't seem to exist. Please check the value supplied with -i, or use -i /path/to/INDEX." unless(-f $INDEX);
}
usage() unless(@ARGV);

my $TMPDIR = File::Basename::dirname($INDEX);

#
# Sanity checking
#
if (-d "$TMPDIR/.svn" and not $opt_n and not $opt_c) {
    print "$TMPDIR/.svn exists, do you want to use the -n option? Press Ctrl-C to abort.\n";
    sleep 5;
}

#
# Read the index, save some interesting keys
#
my %index = ();
{
    print "Reading $INDEX\n";
    open(my $fin, '<', "$INDEX") or die "Cannot open $INDEX for reading.";
    my @lines = <$fin>;
    if ($!) { die "Error while reading $INDEX: $! Aborting"; }
    chomp(@lines);
    close($fin);

    my @a;
    my @b;
    my $port;
    map {
	@a = split(/\|/, $_);
	@b = split(/\//, $a[1]);

	$port = $b[-2]."/".$b[-1];

	@{ $index{$port} }{'portname', 'portnameversion', 'portdir', 'comment', 'deps'}
	    = ($b[-1], $a[0], $a[1], $a[3], ());

	if ($a[8]) {
	    @b = split(" ", $a[8]);
	    @{ $index{$port}{deps} }{@b} = (1) x @b;
	}

    } @lines;
    print "- Processed ", scalar keys(%index), " entries.\n";
}

my %DEPPORTS = ();

foreach my $PORT (@ARGV) {
    #
    # See if the port does really exists.
    # If specified as category/portname, that should be enough.
    # If specified as portname, check all indexes for existence or duplicates.
    #
    unless (defined $index{$PORT}) {
	my @found = grep /\/$PORT$/, keys(%index);
	my $count = @found;

	if ($count == 0) {
	    die "Cannot find ${PORT} in ${INDEX}.";
	} elsif ($count == 1) {
	    $PORT = $found[0];
	} else {
	    my $n = join(" ", @found);
	    die "Found ${PORT} more than once in ${INDEX}: $n. Try category/$PORT.\nAborting";
	}
    }

    my $PORTNAMEVERSION = $index{$PORT}{portnameversion};
    print "Found $PORT as $PORTNAMEVERSION\n";

    #
    # Figure out all the ports depending on this one.
    #
    {
	print "Searching for ports depending on $PORT\n";

	foreach my $p (keys(%index)) {
	    if (defined $index{$p}{'deps'}{$PORTNAMEVERSION}) {
		$DEPPORTS{$p} = 1;
	    }
	}
	print "- Found ", scalar keys(%DEPPORTS), " ports depending on $PORT.\n";
    }
}

#
# In shallow mode, strip all those who don't have a direct dependency
#
sub direct_dependence($@) {
    my ($port, @requisites) = @_;
    open F, '-|', '/usr/bin/make', '-C', $port, qw/-V _RUN_DEPENDS -V _LIB_DEPENDS/ or die "cannot launch make: $!";
    my @lines = <F>;
    chomp @lines;
    my $deps = join(" ", @lines);
    my %deps = map { $_ =~ s[/usr/ports/][]; ($_ => 1) } split " ", $deps;
    if ($!) { die "cannot read depends from make: $!"; }
    close F or die "cannot read depends from make: $!";
    my $required = grep { $_ } map { defined $deps{$_} } @requisites;
    return $required;
}
if ($shallow) {
    my $n = keys %DEPPORTS;
    my $idx = 1;
    foreach my $p (keys %DEPPORTS) {
	print "- Checking requisites of port $idx/$n...\r";
	++$idx;
	unless (direct_dependence($p, @ARGV)) {
	    delete $DEPPORTS{$p};
	}
    }
    print "- Found ", scalar keys(%DEPPORTS), " ports depending directly on either of @ARGV.\n";
}

my $ports = join(" ", keys %DEPPORTS);

#
# Create a temp directory and cvs checkout the ports
# (don't do error checking, too complicated right now)
#
unless ($opt_n or $opt_c) {
  $TMPDIR = ".bump_rev_tmpdir.$$";
  print "svn checkout into $TMPDIR...\n";
  mkdir($TMPDIR, 0755);
  chdir($TMPDIR);
  system "svn checkout --depth=immediates svn+ssh://svn.freebsd.org/ports/head/ ports" and die "SVN checkout failed (wait value $?), aborting";
  chdir('ports');
  system "svn update --set-depth=infinity $ports" and die "SVN checkout failed (wait value $?), aborting";
}

#
# Bump portrevisions
#
{
    print "Updating Makefiles\n";
    foreach my $p (sort keys(%DEPPORTS)) {
	print "- Updating Makefile of $p\n";
    next if $opt_c;
	bumpMakefile "$p";
    }
}

#
# Commit the changes. Not automated.
#
unless ($opt_c) {
    print <<EOF;
All PORTREVISIONs have been updated.  You are nearly done, only one
thing remains:  Committing to the ports tree.  This program is not
going to do that for you, you have to do it manually.

\$ cd $TMPDIR
\$ svn commit
	
Then, remove the temp directory ($TMPDIR).
EOF
}
