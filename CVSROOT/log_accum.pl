#!/usr/bin/perl -w
#
# $FreeBSD$
#
# Perl filter to handle the log messages from the checkin of files in
# a directory.  This script will group the lists of files by log
# message, and mail a single consolidated log message at the end of
# the commit.
#
# This file assumes a pre-commit checking program that leaves the
# names of the first and last commit directories in a temporary file.
#
# Originally by David Hampton <hampton@cisco.com>
#
# Extensively hacked for FreeBSD by Peter Wemm <peter@netplex.com.au>,
#  with parts stolen from Greg Woods <woods@most.wierd.com> version.
#
# Lightly hacked by Mark Murray to allow it to work unmodified
#  on both the master repository (freefall) and the international
#  crypto repository (internat).
#

require 5.003;		# might work with older perl5

use strict;
use lib $ENV{CVSROOT};
use CVSROOT::cfg;


############################################################
#
# Constants
#
############################################################
my $STATE_NONE    = 0;
my $STATE_CHANGED = 1;
my $STATE_ADDED   = 2;
my $STATE_REMOVED = 3;
my $STATE_LOG     = 4;

my $BASE_FN       = "$cfg::TMPDIR/$cfg::FILE_PREFIX";
my $LAST_FILE     = $cfg::LAST_FILE;
my $CHANGED_FILE  = "$BASE_FN.changed";
my $ADDED_FILE    = "$BASE_FN.added";
my $REMOVED_FILE  = "$BASE_FN.removed";
my $LOG_FILE      = "$BASE_FN.log";
my $SUMMARY_FILE  = "$BASE_FN.summary";
my $MAIL_FILE     = "$BASE_FN.mail";
my $SUBJ_FILE     = "$BASE_FN.subj";
my $TAGS_FILE     = "$BASE_FN.tags";

my $X_BRANCH_HDR  = "X-FreeBSD-CVS-Branch:";

my $CVSROOT       = $ENV{'CVSROOT'} || "/home/ncvs";

############################################################
#
# Subroutines
#
############################################################

# Remove the temporary files.
sub cleanup_tmpfiles {
	my @files;		# The list of temporary files.

	# Don't clean up afterwards if in debug mode.
	return if $cfg::DEBUG;

	opendir DIR, $cfg::TMPDIR or die "Cannot open directory: $cfg::TMPDIR!";
	push @files, grep /^$cfg::FILE_PREFIX\..*$/, readdir(DIR);
	closedir DIR;

	foreach (@files) {
		unlink "$cfg::TMPDIR/$_";
	}
}


# Append a line to a named file.
sub append_line {
	my $filename = shift;	# File to append to.
	my $line = shift;	# Line to append.

	open FILE, ">>$filename" or
	    die "Cannot open for append file $filename.\n";
	print FILE "$line\n";
	close FILE;
}


# Read the first line from a named file.
sub read_line {
	my $filename = shift;	# The file to read the line from.

	my $line;		# The line read from the file.

	open FILE, "<$filename" or die "Cannot read file $filename!";
	$line = <FILE>;
	close FILE;
	chomp $line;

	return $line;
}


# Return the contents of a file as a list of strings,
# with trailing line feeds removed.
# Return an empty list of the file couldn't be opened for some reason.
sub read_logfile {
	my $filename = shift;	# The file to read from.

	my @text = ();		# The contents of the file.

	if (open FILE, "<$filename") {
		while (<FILE>) {
			chomp;
			push @text, $_;
		}
		close FILE;
	}

	return @text;
}


# Write a list to a file.
sub write_logfile {
	my $filename = shift;	# File to write to.
	my @lines = @_;		# Contents to write to file.

	open FILE, ">$filename" or
	    die "Cannot open for write log file $filename.";
	print FILE join("\n", @lines), "\n";
	close FILE;
}


sub format_names {
	my $dir = shift;
	my @files = @_;

	my $indent = length($dir);
	$indent = 20 if $indent < 20;

	my $format = "    %-" . sprintf("%d", $indent) . "s ";

	my @lines = (sprintf($format, $dir));

	if ($cfg::DEBUG) {
		print STDERR "format_names(): dir = ", $dir;
		#print STDERR "; tag = ", $tag;
		print STDERR "; files = ", join(":", @files), ".\n";
	}

	foreach my $file (@files) {
		if (length($lines[$#lines]) + length($file) > 66) {
			$lines[++$#lines] = sprintf($format, "", "");
		}
		$lines[$#lines] .= $file . " ";
	}

	return @lines;
}


sub format_lists {
	my $header = shift;
	my @lines = @_;

	print STDERR "format_lists(): ", join(":", @lines), "\n" if $cfg::DEBUG;

	my $lastdir = '';
	my $lastsep = '';
	my $tag = '';
	my @files = ();
	my @text = ();
	foreach my $line (@lines) {
		if ($line =~ /.*\/$/) {
			push @text, &format_names($lastdir, @files) if $lastdir;
			@files = ();

			$lastdir = $line;
			$lastdir =~ s,/$,,;

			$tag = "";	# next thing is a tag
		} elsif (!$tag) {
			$tag = $line;
			next if $header . $tag eq $lastsep;

			$lastsep = $header . $tag;
			if ($tag eq 'HEAD') {
				push @text, "  $header files:";
			} else {
				push @text, sprintf("  %-22s (Branch: %s)",
				    "$header files:", $tag);
			}
		} else {
			push @files, $line;
		}
	}
	push @text, &format_names($lastdir, @files);

	return @text;
}


sub append_names_to_file {
	my $filename = shift;
	my $dir = shift;
	my $tag = shift;
	my @files = @_;

	return unless @files;

	open FILE, ">>$filename" or die "Cannot append to file $filename.";

	print FILE $dir, "\n";
	print FILE $tag, "\n";
	print FILE join("\n", @files), "\n";
	close FILE;
}


#
# Summarise the file changes in the commit using 'cvs -Qn status'
# on each file to extract the info.
#
sub change_summary_changed {
	my $outfile = shift;		# File name of output file.
	my @filenames = @_;		# List of files to check.

	foreach my $file (@filenames) {
		next unless $file;

		my $rev = "";
		my $delta = "";
		my $rcsfile = "";

		open(RCS, "-|") || exec 'cvs', '-Qn', 'status', $file;
		while (<RCS>) {
			if (/^[ \t]*Repository revision/) {
				chomp;
				my @revline = split;
				$rev = $revline[2];
				$revline[3] =~ m|^$CVSROOT/+(.*),v$|;
				$rcsfile = $1;
				last;
			}
		}
		close RCS;

		if ($rev and $rcsfile) {
			open(RCS, "-|") || exec 'cvs', '-Qn', 'log', "-r$rev", $file;
			while (<RCS>) {
				if (/^date:.*lines:\s(.*)$/) {
					$delta = $1;
					last;
				}
			}
			close RCS;
		}

		&append_line($outfile, "$rev,$delta,$rcsfile");
	}
}

# Write these one day.
sub change_summary_added {
}
sub change_summary_removed {
}

sub build_header {
	delete $ENV{'TZ'};

	my $datestr = `/bin/date +"%Y/%m/%d %H:%M:%S %Z"`;
	chomp $datestr;

	my $login = $ENV{'USER'} || getlogin ||
	    (getpwuid($<))[0] || sprintf("uid#%d",$<);
	my $header = sprintf("%-8s    %s", $login, $datestr);

	my @text;
	push @text, $header;
	push @text, "";
	push @text, "$cfg::MAILBANNER\n" if $cfg::MAILBANNER;

	return @text;
}

# !!! Mailing-list and commitlog history file mappings here !!!
# This needs pulling out as a configuration block somewhere so
# that others can easily change it.
sub mlist_map {
	my $dir = shift;	# Directory name
   
	return 'cvs-CVSROOT'	if $dir =~ /^CVSROOT\//;
	return 'cvs-ports'	if $dir =~ /^ports\//;
	return 'cvs-www'	if $dir =~ /^www\//;
	return 'cvs-doc'	if $dir =~ /^doc\//;
	return 'cvs-distrib'	if $dir =~ /^distrib\//;

	return 'cvs-other'	unless $dir =~ /^src\//;

	$dir =~ s,^src/,,;

	return 'cvs-bin'	if $dir =~ /^bin\//;
	return 'cvs-contrib'	if $dir =~ /^contrib\//;
	return 'cvs-eBones'	if $dir =~ /^eBones\//;
	return 'cvs-etc'	if $dir =~ /^etc\//;
	return 'cvs-games'	if $dir =~ /^games\//;
	return 'cvs-gnu'	if $dir =~ /^gnu\//;
	return 'cvs-include'	if $dir =~ /^include\//;
	return 'cvs-kerberosIV'	if $dir =~ /^kerberosIV\//;
	return 'cvs-lib'	if $dir =~ /^lib\//;
	return 'cvs-libexec'	if $dir =~ /^libexec\//;
	return 'cvs-lkm'	if $dir =~ /^lkm\//;
	return 'cvs-release'	if $dir =~ /^release\//;
	return 'cvs-sbin'	if $dir =~ /^sbin\//;
	return 'cvs-share'	if $dir =~ /^share\//;
	return 'cvs-sys'	if $dir =~ /^sys\//;
	return 'cvs-tools'	if $dir =~ /^tools\//;
	return 'cvs-usrbin'	if $dir =~ /^usr\.bin\//;
	return 'cvs-usrsbin'	if $dir =~ /^usr\.sbin\//;

	return 'cvs-user';
}    

sub do_changes_file {
	my @text = @_;

	my %unique = ();
	my @mailaddrs = &read_logfile($MAIL_FILE);
	foreach my $category (@mailaddrs) {
		next if ($unique{$category});
		$unique{$category} = 1;
		if ($category =~ /^cvs-/) {
			# convert mailing list name back to category
			chomp $category;
			$category =~ s/^cvs-//;

			my $changes = "$CVSROOT/CVSROOT/commitlogs/$category";
			open CHANGES, ">>$changes"
				or die "Cannot open $changes.\n";
			print CHANGES join("\n", @text), "\n\n";
			close CHANGES;
		}
	}
}

sub mail_notification {
	my @text = @_;

	print "Mailing the commit message...\n";

	my @mailaddrs = &read_logfile($MAIL_FILE);
	open MAIL, "| $cfg::MAILCMD $cfg::MAILADDRS"
	    or die "Please check $cfg::MAILCMD.";

# This is turned off since the To: lines go overboard.
# Also it has bit-rotted since, and can't just be switched on again.
# - but keep it for the time being in case we do something like cvs-stable
#	print(MAIL 'To: cvs-committers' . $dom . ", cvs-all" . $dom);
#	foreach $line (@mailaddrs) {
#		next if ($unique{$line});
#		$unique{$line} = 1;
#		next if /^cvs-/;
#		print(MAIL ", " . $line . $dom);
#	}
#	print(MAIL "\n");

	my $subject = 'Subject: cvs commit:';
	my @subj = &read_logfile($SUBJ_FILE);
	my $subjlines = 0;
	my $subjwords = 0;	# minimum of two "words" per line
	LINE: foreach my $line (@subj) {
		foreach my $word (split(/ /, $line)) {
			if ($subjwords > 2 &&
			    length($subject . " " . $word) > 75) {
				if ($subjlines > 2) {
					$subject .= " ...";
				}
				print MAIL $subject, "\n";
				if ($subjlines > 2) {
					$subject = "";
					last LINE;
				}

				# rfc822 continuation line
				$subject = "        ";
				$subjwords = 0;
				$subjlines++;
			}
			$subject .= " " . $word;
			$subjwords++;
		}
	}
	print MAIL "$subject\n" if $subject;

	# If required add a header to the mail msg showing
	# which branches were modified during the commit.
	if ($X_BRANCH_HDR) {
		my %tags = map { $_ => 1 } &read_logfile($TAGS_FILE);
		print MAIL "$X_BRANCH_HDR ", join(",", sort keys %tags), "\n";
	}

	print MAIL "\n";
	print MAIL join("\n", @text);
	close MAIL;
}

# Return the length of the longest value in the list.
sub longest_value {
	my @values = @_;

	my @sorted = sort { $b <=> $a } map { length $_ } @values;
	return $sorted[0];
}

sub format_summaries {
	my @filenames = @_;

	my @revs;
	my @deltas;
	my @files;

	# Parse the summary file.
	foreach my $filename (@filenames) {
		open FILE, $filename or next;
		while (<FILE>) {
			chomp;
			my ($r, $d, $f) = split /,/, $_;
			push @revs, $r;
			push @deltas, $d;
			push @files, $f;
		}
		close FILE;
	}    

	# Format the output, extra spaces after "Changes"
	# to match historic formatting.
	my $r_max = longest_value("Revision", @revs) + 2;
	my $d_max = longest_value("Changes  ", @deltas) + 2;

	my @text;
	my $fmt = "%-" . $r_max . "s%-" . $d_max . "s%s";
	push @text, sprintf $fmt, "Revision", "Changes", "Path";
	foreach (0 .. $#revs) {
		push @text, sprintf $fmt, $revs[$_], $deltas[$_], $files[$_];
	}

	return @text;
}

#############################################################
#
# Main Body
#
############################################################

#
# Setup environment
#
umask (002);

#
# Initialize basic variables
#
my $input_params = $ARGV[0];
my ($directory, @filenames) = split " ", $input_params;
#@files = split(' ', $input_params);

my @path = split('/', $directory);
my $dir;
if ($#path == 0) {
	$dir = ".";
} else {
	$dir = join('/', @path[1..$#path]);
}
$dir = $dir . "/";

#
# Throw some values at the developer if in debug mode
#
if ($cfg::DEBUG) {
	print "ARGV      - ", join(":", @ARGV), "\n";
	print "directory - ", $directory, "\n";
	print "filenames - ", join(":", @filenames), "\n";
	print "path      - ", join(":", @path), "\n";
	print "dir       - ", $dir, "\n";
	print "pid       - ", $cfg::PID, "\n";
}

# Was used for To: lines, still used for commitlogs naming.
&append_line($MAIL_FILE, &mlist_map("$directory/"));
&append_line($SUBJ_FILE, $input_params);

#
# Check for a new directory first.  This will always appear as a
# single item in the argument list, and an empty log message.
#
if ($input_params =~ /New directory/) {
	my @text = &build_header();

	push @text, "  $input_params";
	&do_changes_file(@text);
	&mail_notification(@text) if $cfg::MAIL_ON_DIR_CREATION;
	&cleanup_tmpfiles();
	exit 0;
}

#
# Check for an import command.  This will always appear as a
# single item in the argument list, and a log message.
#
if ($input_params =~ /Imported sources/) {
	my @text = &build_header();

	push @text, "  $input_params";

	while (<STDIN>) {
		chomp;
		push @text, "  $_";
	}

	&do_changes_file(@text);
	&mail_notification(@text);
	&cleanup_tmpfiles();
	exit 0;
}    

#
# Iterate over the body of the message collecting information.
#
my %added_files;		# Hashes containing lists of files
my %changed_files;		# that have been changed, keyed
my %removed_files;		# by branch tag.

my @log_lines;			# The lines of the log message.

my $tag = "HEAD";		# Default branch is HEAD.
my $state = $STATE_NONE;	# Initially in no state.

while (<STDIN>) {
	s/[ \t\n]+$//;		# delete trailing space

	# parse the revision tag if it exists.
	if (/^Revision\/Branch:(.*)/)	{ $tag = $1;	 next; }
	if (/^[ \t]+Tag: (.*)/)		{ $tag = $1;	 next; }
	if (/^[ \t]+No tag$/)		{ $tag = "HEAD"; next; }

	# check for a state change, guarding against similar markers
	# in the log message itself.
	unless ($state == $STATE_LOG) {
		if (/^Modified Files/)	{ $state = $STATE_CHANGED; next; }
		if (/^Added Files/)	{ $state = $STATE_ADDED;   next; }
		if (/^Removed Files/)	{ $state = $STATE_REMOVED; next; }
		if (/^Log Message/)	{ $state = $STATE_LOG;	   next; }
	}

	# don't so anything if we're not in a state.
	next if $state == $STATE_NONE;

	# collect the log line (ignoring empty template entries)?
	if ($state == $STATE_LOG) {
		# XXX this stuff should come from the configuration file.
		unless (
		    /^PR:$/i ||
		    /^Reviewed by:$/i ||
		    /^Submitted by:$/i ||
		    /^Obtained from:$/i ||
		    /^MFC after:$/i ||
		    /^Approved by:$/i) {
			push @log_lines, $_;
		}
		next;
	}

	# otherwise collect information about which files changed.
	my @files = split;
	push @{ $changed_files{$tag} },	@files if $state == $STATE_CHANGED;
	push @{ $added_files{$tag} },	@files if $state == $STATE_ADDED;
	push @{ $removed_files{$tag} },	@files if $state == $STATE_REMOVED;
}
&append_line($TAGS_FILE, $tag);

#
# Strip leading and trailing blank lines from the log message.  Also
# compress multiple blank lines in the body of the message down to a
# single blank line.
# (Note, this only does the mail and changes log, not the rcs log).
#
while ($#log_lines > -1) {
	last if ($log_lines[0] ne "");
	shift(@log_lines);
}
while ($#log_lines > -1) {
	last if ($log_lines[$#log_lines] ne "");
	pop(@log_lines);
}
for (my $l = $#log_lines; $l > 0; $l--) {
	if (($log_lines[$l - 1] eq "") && ($log_lines[$l] eq "")) {
		splice(@log_lines, $l, 1);
	}
}

#
# Find the log file that matches this log message
#
my $message_index;		# The index of this log message
for ($message_index = 0; ; $message_index++) {
	last unless -e "$LOG_FILE.$message_index";

	my @text = &read_logfile("$LOG_FILE.$message_index");
	last if  $#text == -1;
	last if join(" ", @log_lines) eq join(" ", @text);
}

#
# Spit out the information gathered in this pass.
#
foreach my $tag ( keys %added_files ) {
	&append_names_to_file("$ADDED_FILE.$message_index",   $dir, $tag,
	    @{ $added_files{$tag} });
}
foreach my $tag ( keys %changed_files ) {
	&append_names_to_file("$CHANGED_FILE.$message_index", $dir, $tag,
	    @{ $changed_files{$tag} });
}
foreach my $tag ( keys %removed_files ) {
	&append_names_to_file("$REMOVED_FILE.$message_index", $dir, $tag,
	    @{ $removed_files{$tag} });
}
&write_logfile("$LOG_FILE.$message_index", @log_lines);

#
# Save the info for the commit summary.
#
foreach my $tag ( keys %added_files ) {
	&change_summary_added("$SUMMARY_FILE.$message_index",
	    @{ $added_files{$tag} });
}
foreach my $tag ( keys %changed_files ) {
	&change_summary_changed("$SUMMARY_FILE.$message_index",
	    @{ $changed_files{$tag} });
}
foreach my $tag ( keys %removed_files ) {
	&change_summary_removed("$SUMMARY_FILE.$message_index",
	    @{ $removed_files{$tag} });
}

#
# Check whether this is the last directory.  If not, quit.
# The last directory name was written by commit_prep.pl on
# the way in.
#
if (-e $LAST_FILE) {
	$_ = &read_line($LAST_FILE);
	my $tmpfiles = $directory;
	$tmpfiles =~ s,([^a-zA-Z0-9_/]),\\$1,g;
	if (! grep(/$tmpfiles$/, $_)) {
		print "More commits to come...\n";
		exit 0
	}
}

#
# This is it.  The commits are all finished.  Lump everything together
# into a single message, fire a copy off to the mailing list, and drop
# it on the end of the Changes file.
#

#
# Produce the final compilation of the log messages
#
my @log_msg = &build_header();
for (my $i = 0; ; $i++) {
	last unless -e "$LOG_FILE.$i";

	my @mod_lines = &read_logfile("$CHANGED_FILE.$i");
	push @log_msg, &format_lists("Modified", @mod_lines) if @mod_lines;

	my @add_lines = &read_logfile("$ADDED_FILE.$i");
	push @log_msg, &format_lists("Added", @add_lines) if @add_lines;

	my @rem_lines = &read_logfile("$REMOVED_FILE.$i");
	push @log_msg, &format_lists("Removed", @rem_lines) if @rem_lines;

	my @msg_lines = &read_logfile("$LOG_FILE.$i");
	push @log_msg, "  Log:", (map { "  $_" } @msg_lines) if @msg_lines;


	if (-e "$SUMMARY_FILE.$i") {
		push @log_msg, "  ", map {"  $_"}
		    format_summaries("$SUMMARY_FILE.$i");
	}

	push @log_msg, "", "";
}
#
# Put the log message at the beginning of the Changes file
#
&do_changes_file(@log_msg);

#
# Mail out the notification.
#
&mail_notification(@log_msg);
&cleanup_tmpfiles();
exit 0;
# EOF
