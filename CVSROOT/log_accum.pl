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

use Sys::Hostname;	# get hostname() function

############################################################
#
# Configurable options
#
############################################################
#
# Where do you want the RCS ID and delta info?
# 0 = none,
# 1 = in mail only,
# 2 = rcsids in both mail and logs.
#
$RCSIDINFO = 2;

# Debug level, 0 = off
$DEBUG = 0;

# The command used to mail the log messages.  Usually something
# like '/usr/sbin/sendmail'.  
$MAILCMD = "/usr/local/bin/mailsend -H";


# Email addresses of recipients of commit mail.
$MAILADDRS = 'cvs-committers@FreeBSD.org cvs-all@FreeBSD.org';


# Extra banner to add to top of commit messages.
# i.e. $MAILBANNER = "Project X CVS Repository";
$MAILBANNER = "";


#-------------------------------------------------------
# FreeBSD site localisation
# Remember to comment out if using for other purposes.
#-------------------------------------------------------
if (hostname() =~ /^(freefall|internat)\.freebsd\.org$/i) {
    if ($1 =~ /freefall/i) {
	$meister = 'peter@FreeBSD.org';
    } else {
	$meister = 'markm@FreeBSD.org';
	$MAILBANNER = "FreeBSD International Crypto Repository";
    }
    $MAILADDRS = $meister if $DEBUG;
}


############################################################
#
# Constants
#
############################################################
$STATE_NONE    = 0;
$STATE_CHANGED = 1;
$STATE_ADDED   = 2;
$STATE_REMOVED = 3;
$STATE_LOG     = 4;

$FILE_PREFIX   = "#cvs.files";
$LAST_FILE     = "/tmp/#cvs.files.lastdir";
$CHANGED_FILE  = "/tmp/#cvs.files.changed";
$ADDED_FILE    = "/tmp/#cvs.files.added";
$REMOVED_FILE  = "/tmp/#cvs.files.removed";
$LOG_FILE      = "/tmp/#cvs.files.log";
$SUMMARY_FILE  = "/tmp/#cvs.files.summary";
$MAIL_FILE     = "/tmp/#cvs.files.mail";
$SUBJ_FILE     = "/tmp/#cvs.files.subj";
$TAGS_FILE     = "/tmp/#cvs.files.tags";

$X_BRANCH_HDR  = "X-FreeBSD-CVS-Branch:";

$CVSROOT       = $ENV{'CVSROOT'} || "/home/ncvs";

############################################################
#
# Subroutines
#
############################################################

sub cleanup_tmpfiles {
    local($wd, @files);

    $wd = `pwd`;
    chdir("/tmp");
    opendir(DIR, ".");
    push(@files, grep(/^$FILE_PREFIX\..*$id$/, readdir(DIR)));
    closedir(DIR);
    foreach (@files) {
	unlink $_;
    }
    chdir($wd);
}

sub append_to_logfile {
    local($filename, @files) = @_;

    open(FILE, ">>$filename") || die ("Cannot open for append file $filename.\n");
    print(FILE join("\n", @lines), "\n");
    close(FILE);
}

sub append_line {
    local($filename, $line) = @_;
    open(FILE, ">>$filename") || die("Cannot open for append file $filename.\n");
    print(FILE $line, "\n");
    close(FILE);
}

sub read_line {
    local($line);
    local($filename) = @_;
    open(FILE, "<$filename") || die("Cannot open for read file $filename.\n");
    $line = <FILE>;
    close(FILE);
    chop($line);
    $line;
}

sub read_logfile {
    local(@text) = ();
    local($filename, $leader) = @_;
    open(FILE, "<$filename") and do {
	while (<FILE>) {
	    chop;
	    push(@text, $leader.$_);
	}
	close(FILE);
    };
    @text;
}

sub write_logfile {
    local($filename, @lines) = @_;

    open(FILE, ">$filename") || die("Cannot open for write log file $filename.\n");
    print FILE join("\n", @lines), "\n";
    close(FILE);
}

sub format_names {
    local($dir, @files) = @_;
    local(@lines, $indent);

    $indent = length($dir);
    if ($indent < 20) {
      $indent = 20;
    }

    $format = "    %-" . sprintf("%d", $indent) . "s ";

    $lines[0] = sprintf($format, $dir);

    if ($DEBUG) {
	print STDERR "format_names(): dir = ", $dir, "; tag = ", $tag, "; files = ", join(":", @files), ".\n";
    }
    foreach $file (@files) {
	if (length($lines[$#lines]) + length($file) > 66) {
	    $lines[++$#lines] = sprintf($format, "", "");
	}
	$lines[$#lines] .= $file . " ";
    }

    @lines;
}

sub format_lists {
    local($header, @lines) = @_;
    local(@text, @files, $lastdir, $lastsep, $tag);

    if ($DEBUG) {
	print STDERR "format_lists(): ", join(":", @lines), "\n";
    }
    @text = ();
    @files = ();

    $lastdir = '';
    $lastsep = '';
    foreach $line (@lines) {
	if ($line =~ /.*\/$/) {
	    if ($lastdir ne '') {
	        push(@text, &format_names($lastdir, @files));
	    }
	    $lastdir = $line;
	    $lastdir =~ s,/$,,;
	    $tag = "";	# next thing is a tag
	    @files = ();
	} elsif ($tag eq '') {
	    $tag = $line;
	    next if ($header . $tag eq $lastsep);
	    $lastsep = $header . $tag;
	    if ($tag eq 'HEAD') {
		push(@text, "  $header files:");
	    } else {
		push(@text, sprintf("  %-22s (Branch: %s)", "$header files:",
			$tag));
	    }
	} else {
	    push(@files, $line);
	}
    }
    push(@text, &format_names($lastdir, @files));

    @text;
}

sub append_names_to_file {
    local($filename, $dir, $tag, @files) = @_;

    if (@files) {
	open(FILE, ">>$filename") || die("Cannot open for append file $filename.\n");
	print FILE $dir, "\n";
	print FILE $tag, "\n";
	print FILE join("\n", @files), "\n";
	close(FILE);
    }
}

#
# do an 'cvs -Qn status' on each file in the arguments, and extract info.
#

sub change_summary_changed {
    local($out, $tag, @filenames) = @_;
    local(@revline);
    local($file, $rev, $rcsfile, $line);

    while (@filenames) {
	$file = shift @filenames;

	if ("$file" eq "") {
	    next;
	}

	open(RCS, "-|") || exec 'cvs', '-Qn', 'status', $file;

	$rev = "";
	$delta = "";
	$rcsfile = "";


	while (<RCS>) {
	    if (/^[ \t]*Repository revision/) {
		chop;
		@revline = split(' ', $_);
		$rev = $revline[2];
		$rcsfile = $revline[3];
		$rcsfile =~ s,^$CVSROOT[/]+,,;
		$rcsfile =~ s/,v$//;
		last;
	    }
	}
	close(RCS);

	if ($rev ne '' && $rcsfile ne '') {
	    open(RCS, "-|") || exec 'cvs', '-Qn', 'log', "-r$rev", $file;
	    while (<RCS>) {
		if (/^date:.*lines:\s(.*)$/) {
		    $delta = $1;
		    last;
		}
	    }
	    close(RCS);
	}

	&append_line($out, "$rev,$delta,$rcsfile");
    }
}

# Write these one day.
sub change_summary_added {
}
sub change_summary_removed {
}

sub build_header {
    local($header, $datestr);
    delete $ENV{'TZ'};

    $datestr = `/bin/date +"%Y/%m/%d %H:%M:%S %Z"`;
    chop($datestr);
    $header = sprintf("%-8s    %s", $login, $datestr);

    my @text;
    push @text, $header;
    push @text, "";
    push @text, "$MAILBANNER\n" if $MAILBANNER;

    return @text;
}

# !!! Mailing-list and commitlog history file mappings here !!!
sub mlist_map {
    local($dir) = @_;		# perl warns about this....
   
    return 'cvs-CVSROOT'      if($dir =~ /^CVSROOT\//);
    return 'cvs-ports'        if($dir =~ /^ports\//);
    return 'cvs-www'          if($dir =~ /^www\//);
    return 'cvs-doc'          if($dir =~ /^doc\//);
    return 'cvs-distrib'      if($dir =~ /^distrib\//);

    return 'cvs-other'        unless($dir =~ /^src\//);

    $dir =~ s,^src/,,;

    return 'cvs-bin'          if($dir =~ /^bin\//);
    return 'cvs-contrib'      if($dir =~ /^contrib\//);
    return 'cvs-eBones'       if($dir =~ /^eBones\//);
    return 'cvs-etc'          if($dir =~ /^etc\//);
    return 'cvs-games'        if($dir =~ /^games\//);
    return 'cvs-gnu'          if($dir =~ /^gnu\//);
    return 'cvs-include'      if($dir =~ /^include\//);
    return 'cvs-kerberosIV'   if($dir =~ /^kerberosIV\//);
    return 'cvs-lib'          if($dir =~ /^lib\//);
    return 'cvs-libexec'      if($dir =~ /^libexec\//);
    return 'cvs-lkm'          if($dir =~ /^lkm\//);
    return 'cvs-release'      if($dir =~ /^release\//);
    return 'cvs-sbin'         if($dir =~ /^sbin\//);
    return 'cvs-share'        if($dir =~ /^share\//);
    return 'cvs-sys'          if($dir =~ /^sys\//);
    return 'cvs-tools'        if($dir =~ /^tools\//);
    return 'cvs-usrbin'       if($dir =~ /^usr\.bin\//);
    return 'cvs-usrsbin'      if($dir =~ /^usr\.sbin\//);

    return 'cvs-user';

}    

sub do_changes_file {
    local($changes,$category,@mailaddrs);
    local(@text) = @_;
    local(%unique);

    %unique = ();
    @mailaddrs = &read_logfile("$MAIL_FILE.$id", "");
    foreach $category (@mailaddrs) {
	next if ($unique{$category});
	$unique{$category} = 1;
	if ($category =~ /^cvs-/) {
	    # convert mailing list name back to category
	    $category =~ s,\n,,;
	    $category =~ s/^cvs-//;
	    $changes = "$CVSROOT/CVSROOT/commitlogs/$category";

	    open(CHANGES, ">>$changes") || die("Cannot open $changes.\n");
	    print(CHANGES join("\n", @text), "\n\n");
	    close(CHANGES);
	}
    }
}

sub mail_notification {
    local(@text) = @_;
    local($line, $word, $subjlines, $subjwords, @mailaddrs);
#   local(%unique);

#   %unique = ();

    print "Mailing the commit message...\n";

    @mailaddrs = &read_logfile("$MAIL_FILE.$id", "");
    open MAIL, "| $MAILCMD $MAILADDRS" or die 'Please check $MAILCMD.';


# This is turned off since the To: lines go overboard.
# - but keep it for the time being in case we do something like cvs-stable
#    print(MAIL 'To: cvs-committers' . $dom . ", cvs-all" . $dom);
#    foreach $line (@mailaddrs) {
#	next if ($unique{$line});
#	$unique{$line} = 1;
#	next if /^cvs-/;
#	print(MAIL ", " . $line . $dom);
#    }
#    print(MAIL "\n");

    $subject = 'Subject: cvs commit:';
    @subj = &read_logfile("$SUBJ_FILE.$id", "");
    $subjlines = 0;
    $subjwords = 0;	# minimum of two "words" per line
    LINE: foreach $line (@subj) {
	foreach $word (split(/ /, $line)) {
	    if ($subjwords > 2 && length($subject . " " . $word) > 75) {
		if ($subjlines > 2) {
		    $subject .= " ...";
		}
		print(MAIL $subject, "\n");
		if ($subjlines > 2) {
		    $subject = "";
		    last LINE;
		}
		$subject = "        ";		# rfc822 continuation line
		$subjwords = 0;
		$subjlines++;
	    }
	    $subject .= " " . $word;
	    $subjwords++;
	}
    }
    if ($subject ne "") {
	print(MAIL $subject, "\n");
    }

    # Add a header to the mail msg showing which branches
    # were modified during the commit.
    %tags = map { $_ => 1 } &read_logfile("$TAGS_FILE.$id", "");
    print (MAIL "$X_BRANCH_HDR ", join(",", sort keys %tags), "\n");

    print (MAIL "\n");

    print(MAIL join("\n", @text));
    close(MAIL);
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

    # Format the output
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
$id = getpgrp();
$state = $STATE_NONE;
$tag = '';
$login = $ENV{'USER'} || getlogin || (getpwuid($<))[0] || sprintf("uid#%d",$<);
@files = split(' ', $ARGV[0]);
@path = split('/', $files[0]);
if ($#path == 0) {
    $dir = ".";
} else {
    $dir = join('/', @path[1..$#path]);
}
$dir = $dir . "/";

if ($DEBUG) {
  print("ARGV  - ", join(":", @ARGV), "\n");
  print("files - ", join(":", @files), "\n");
  print("path  - ", join(":", @path), "\n");
  print("dir   - ", $dir, "\n");
  print("id    - ", $id, "\n");
}

# Was used for To: lines, still used for commitlogs naming.
&append_line("$MAIL_FILE.$id", &mlist_map($files[0] . "/"));
&append_line("$SUBJ_FILE.$id", $ARGV[0]);

#
# Check for a new directory first.  This will always appear as a
# single item in the argument list, and an empty log message.
#
if ($ARGV[0] =~ /New directory/) {
    @text = &build_header();

    push(@text, "  ".$ARGV[0]);
    &do_changes_file(@text);
    #&mail_notification(@text);
    &cleanup_tmpfiles();
    exit 0;
}

#
# Check for an import command.  This will always appear as a
# single item in the argument list, and a log message.
#
if ($ARGV[0] =~ /Imported sources/) {
    @text = &build_header();

    push(@text, "  ".$ARGV[0]);
    &do_changes_file(@text);

    while (<STDIN>) {
	chop;                   # Drop the newline
	push(@text, "  ".$_);
    }

    &mail_notification(@text);
    &cleanup_tmpfiles();
    exit 0;
}    

#
# Iterate over the body of the message collecting information.
#
$tag = "HEAD";
while (<STDIN>) {
    s/[ \t\n]+$//;		# delete trailing space
    if (/^Revision\/Branch:/) {
	s,^Revision/Branch:,,;
	$tag = $_;
	next;
    }
    if (/^[ \t]+Tag:/) {
	s,^[ \t]+Tag: ,,;
	$tag = $_;
	next;
    }
    if (/^[ \t]+No tag$/) {
	$tag = "HEAD";
	next;
    }
    if (/^Modified Files/) { $state = $STATE_CHANGED; next; }
    if (/^Added Files/)    { $state = $STATE_ADDED;   next; }
    if (/^Removed Files/)  { $state = $STATE_REMOVED; next; }
    if (/^Log Message/)    { $state = $STATE_LOG;     next; }
    
    push (@{ $changed_files{$tag} }, split) if ($state == $STATE_CHANGED);
    push (@{ $added_files{$tag} },   split) if ($state == $STATE_ADDED);
    push (@{ $removed_files{$tag} }, split) if ($state == $STATE_REMOVED);
    if ($state == $STATE_LOG) {
	if (/^PR:$/i ||
	    /^Reviewed by:$/i ||
	    /^Submitted by:$/i ||
	    /^Obtained from:$/i ||
	    /^Approved by:$/i) {
	    next;
	}
	push (@log_lines,     $_);
    }
}
&append_line("$TAGS_FILE.$id", $tag);

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
for ($l = $#log_lines; $l > 0; $l--) {
    if (($log_lines[$l - 1] eq "") && ($log_lines[$l] eq "")) {
	splice(@log_lines, $l, 1);
    }
}

#
# Find the log file that matches this log message
#
for ($i = 0; ; $i++) {
    last if (! -e "$LOG_FILE.$i.$id");
    @text = &read_logfile("$LOG_FILE.$i.$id", "");
    last if ($#text == -1);
    last if (join(" ", @log_lines) eq join(" ", @text));
}

#
# Spit out the information gathered in this pass.
#
foreach $tag ( keys %added_files ) {
    &append_names_to_file("$ADDED_FILE.$i.$id",   $dir, $tag,
	@{ $added_files{$tag} });
}
foreach $tag ( keys %changed_files ) {
    &append_names_to_file("$CHANGED_FILE.$i.$id", $dir, $tag,
	@{ $changed_files{$tag} });
}
foreach $tag ( keys %removed_files ) {
    &append_names_to_file("$REMOVED_FILE.$i.$id", $dir, $tag,
	@{ $removed_files{$tag} });
}
&write_logfile("$LOG_FILE.$i.$id", @log_lines);

if ($RCSIDINFO) {
    foreach $tag ( keys %added_files ) {
	&change_summary_added("$SUMMARY_FILE.$i.$id", $tag,
	    @{ $added_files{$tag} });
    }
    foreach $tag ( keys %changed_files ) {
	&change_summary_changed("$SUMMARY_FILE.$i.$id", $tag,
	    @{ $changed_files{$tag} });
    }
    foreach $tag ( keys %removed_files ) {
	&change_summary_removed("$SUMMARY_FILE.$i.$id", $tag,
	    @{ $removed_files{$tag} });
    }
}

#
# Check whether this is the last directory.  If not, quit.
#
if (-e "$LAST_FILE.$id") {
   $_ = &read_line("$LAST_FILE.$id");
   $tmpfiles=$files[0];
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
push @text, &build_header();
for ($i = 0; ; $i++) {
    last if (! -e "$LOG_FILE.$i.$id");
    @lines = &read_logfile("$CHANGED_FILE.$i.$id", "");
    if ($#lines >= 0) {
	push(@text, &format_lists("Modified", @lines));
    }
    @lines = &read_logfile("$ADDED_FILE.$i.$id", "");
    if ($#lines >= 0) {
	push(@text, &format_lists("Added", @lines));
    }
    @lines = &read_logfile("$REMOVED_FILE.$i.$id", "");
    if ($#lines >= 0) {
	push(@text, &format_lists("Removed", @lines));
    }

    @lines = &read_logfile("$LOG_FILE.$i.$id", "  ");
    if ($#lines >= 0) {
        push(@text, "  Log:");
	push(@text, @lines);
    }
    if ($RCSIDINFO == 2) {
	if (-e "$SUMMARY_FILE.$i.$id") {
	    push(@text, "  ");
	    push @text, map {"  $_"} format_summaries("$SUMMARY_FILE.$i.$id");
	}
    }
    push(@text, "", "");
}
#
# Put the log message at the beginning of the Changes file
#
&do_changes_file(@text);

#
# Now generate the extra info for the mail message..
#
if ($RCSIDINFO == 1) {
    my @summary_files;
    for ($i = 0; ; $i++) {
	last unless -e "$LOG_FILE.$i.$id";
	push @summary_files, "$SUMMARY_FILE.$i.$id";
    }
    push @text, format_summaries(@summary_files);
    push @text, "";
}

#
# Mail out the notification.
#
&mail_notification(@text);
&cleanup_tmpfiles();
exit 0;
# EOF
