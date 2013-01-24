#!/usr/bin/perl
use strict;
use utf8;
use open qw(:std :utf8);
use Getopt::Long;
use Pod::Usage;

my $version = "2013-01-24.1";

my $man = 0;
my $help = 0;
my $nrepeats = 1;
my $headfile = "label_head.tex";
my $linefile = "label_line.tex";
my $tailfile = "label_tail.tex";
my $namefile = "names_raw.txt";
my $dummy = 1;
my $template = 0;
my $overwrite = 0;
my $showversion = 0;

Getopt::Long::Configure("bundling");
if (!GetOptions("help|?" => \$help,
		"man" => \$man,
                "template" => \$template,
		"n=i" => \$nrepeats,
		"headfile=s" => \$headfile,
		"linefile=s" => \$linefile,
		"tailfile=s" => \$tailfile,
		"namefile=s" => \$namefile,
                "dummy!" => \$dummy,
                "overwrite" => \$overwrite,
		"version" => \$showversion)) {
    pod2usage(2);
}
if ($help) {
    pod2usage(1);
}
if ($man) {
    pod2usage(-exitstatus => 0, -verbose => 2);
}
if ($showversion) {
    print $version, "\n";
    exit;
}
if ($template) {
    # A file to dump (destination STDOUT):
    # The LaTeX document where the output of format_labels will be embedded
    print <<'EOF';
\documentclass[a4paper]{article}
\usepackage[utf8]{inputenx}
\input{ix-utf8enc.dfu}
\usepackage[newdimens]{labels}
\usepackage{graphicx}
\usepackage{palatino}
\usepackage[official]{eurosym}
\usepackage{multirow}
\usepackage[usenames]{xcolor}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\usepackage{setspace}
\LabelInfotrue

%\LabelGridtrue

% "Durable Badgemaker 54x90 mm": 2,5,15,15,12,15,0,0,9,0,4,0
%\LabelCols=2%             Number of columns of labels per page
%\LabelRows=5%             Number of rows of labels per page
%\LeftPageMargin=15mm%     These four parameters give the
%\RightPageMargin=15mm%      page gutter sizes.  The outer edges of
%\TopPageMargin=12mm%        the outer labels are the specified
%\BottomPageMargin=15mm%     distances from the edge of the paper.
%\InterLabelColumn=0mm%    Gap between columns of labels
%\InterLabelRow=0mm%       Gap between rows of labels
%\LeftLabelBorder=9mm%     These four parameters give the extra
%\RightLabelBorder=0mm%      space used around the text on each
%\TopLabelBorder=2.6mm%      actual label.
%\BottomLabelBorder=0mm%
\LabelCols=2%             Number of columns of labels per page
\LabelRows=4%             Number of rows of labels per page
\LeftPageMargin=0mm%      These four parameters give the
\RightPageMargin=0mm%       page gutter sizes.  The outer edges of
\TopPageMargin=0mm%         the outer labels are the specified
\BottomPageMargin=0mm%      distances from the edge of the paper.
\InterLabelColumn=0mm%    Gap between columns of labels
\InterLabelRow=0mm%       Gap between rows of labels
\LeftLabelBorder=6mm%     These four parameters give the extra
\RightLabelBorder=5mm%      space used around the text on each
\TopLabelBorder=3mm%        actual label.
\BottomLabelBorder=0mm%
% Aalto colors
\definecolor{aaltoYellow}{cmyk}{0,0.06,1,0}
\definecolor{aaltoRed}{cmyk}{0,0.8,0.7,0}
\definecolor{aaltoBlue}{cmyk}{1,0.3,0,0}
\definecolor{aaltoLime}{cmyk}{0.5,0,0.8,0}
\definecolor{aaltoGreen}{cmyk}{0.82,0,0.92,0}
\definecolor{aaltoCyan}{cmyk}{0.95,0,0.25,0}
\definecolor{aaltoPurpleBlue}{cmyk}{0.53,0.65,0,0}
\definecolor{aaltoPurpleRed}{cmyk}{0.22,0.72,0,0}
\definecolor{aaltoOrange}{cmyk}{0,0.54,0.82,0}
\definecolor{aaltoGrey}{cmyk}{0.1,0.11,0.13,0.36}
% Style guideline: Use non-adjacent colors (circular numbering)
\colorlet{aalto1}{aaltoYellow}
\colorlet{aalto2}{aaltoLime}
\colorlet{aalto3}{aaltoGreen}
\colorlet{aalto4}{aaltoCyan}
\colorlet{aalto5}{aaltoBlue}
\colorlet{aalto6}{aaltoPurpleBlue}
\colorlet{aalto7}{aaltoPurpleRed}
\colorlet{aalto8}{aaltoRed}
\colorlet{aalto9}{aaltoOrange}
\begin{document}%        End of preamble
\labelfile{names.dat}
\end{document}
EOF
    if (!$overwrite && -e $headfile) {
	warn "file $headfile exists";
    } elsif (!open HEADFILE, ">", $headfile) {
	warn "cannot open > $headfile: $!";
    } else {
	# A file to dump:
	# Formatting to be inserted before each label
	print HEADFILE <<'EOF';
\begin{center}\vspace{-5mm}
\mbox{
\parbox[l]{30mm}{\centering
\Huge \textsf{\textbf{\textcolor{aalto3}{I}\textcolor{aalto6}{D}\textcolor{aalto9}{A} 2012}}}
\parbox[r]{60mm}{\centering
\Large 25--27 October 2012\\Helsinki, Finland}
}\vspace{8mm}\onehalfspacing
EOF
        close HEADFILE;
    }
    if (!$overwrite && -e $linefile) {
	warn "file $linefile exists";
    } elsif (!open LINEFILE, ">", $linefile) {
	warn "cannot open > $linefile: $!";
    } else {
	# A file to dump:
	# Formatting to be used for the text lines of each label
	print LINEFILE <<'EOF';
\huge% formatting starting from 1st line,
\Large% starting from 2nd line, ...
EOF
        close LINEFILE;
    }
    if (!$overwrite && -e $tailfile) {
	warn "file $tailfile exists";
    } elsif (!open TAILFILE, ">", $tailfile) {
	warn "cannot open > $tailfile: $!";
    } else {
	# A file to dump:
	# Formatting to be inserted after each label
	print TAILFILE <<'EOF';
\end{center}
EOF
        close TAILFILE;
    }
    if (!$overwrite && -e $namefile) {
	warn "file $namefile exists";
    } elsif (!open NAMEFILE, ">", $namefile) {
	warn "cannot open > $namefile: $!";
    } else {
	# A file to dump:
	# Formatting to be inserted after each label
	print NAMEFILE <<'EOF';
Firstname1 Lastname1
Institute1
Country1
 
Firstname2 Lastname2
Institute2
Country2
EOF
        close NAMEFILE;
    }
    exit;
}

open FMT_HEAD, $headfile
    or die "cannot open < $headfile: $!";
my @fmt_head = ( );
while (<FMT_HEAD>) {
    s/\s+$//;
    if (length($_) > 0) {
	push @fmt_head, $_ . "\n";
    }
}
open FMT_TAIL, $tailfile
    or die "cannot open < $tailfile: $!";
my @fmt_tail = ( );
while (<FMT_TAIL>) {
    s/\s+$//;
    if (length($_) > 0) {
	push @fmt_tail, $_ . "\n";
    }
}
open FMT_LINE, $linefile
    or die "cannot open < $linefile: $!";
my @fmt_line = ( );
while (<FMT_LINE>) {
    s/\s+$//;
    if (length($_) > 0) {
	push @fmt_line, $_ . "\n";
    }
}

my $line = "";

# http://www.mail-archive.com/templates@template-toolkit.org/msg07971.html
sub latex_escape {
  my $paragraph = shift;
  $paragraph =~ s/\\/\\textbackslash /g;
  $paragraph =~ s/([\$\#&%_{}])/\\$1/g;
  $paragraph =~ s/(\^)/\\$1\{\}/g;
  $paragraph =~ s/</\\textless /g;
  $paragraph =~ s/>/\\textgreater /g;
  $paragraph =~ s/\|/\\textbar /g;
  $paragraph =~ s/"/''/g;
  $paragraph =~ s/~/\\texttt\{\\~\{\}\}/g;
  $paragraph =~ s/€/\\euro /g;
  return $paragraph;
}

my $n_records = 0;
# Skip initial empty lines
while (defined($line) && length($line) == 0) {
    $line = <>;
    if (defined($line)) {
	$line =~ s/\s+$//;
    }
}
while (defined($line)) {
    my @lines = ( );
    # Store non-empty lines
    while (defined($line) && length($line) > 0) {
	push @lines, &latex_escape($line);
	$line = <>;
	if (defined($line)) {
	    $line =~ s/\s+$//;
	}
    }
    # Skip following empty lines
    while (defined($line) && length($line) == 0) {
	$line = <>;
	if (defined($line)) {
	    $line =~ s/\s+$//;
	}
    }
    for (my $counter = 1; $counter <= $nrepeats; $counter++) {

	if ($n_records++ > 0) {
	    print "\n";
	}
	my @this_fmt = @fmt_line;

	foreach (@fmt_head) {
	    print $_;
	}

	foreach (@lines) {
	    my $formatting = shift @this_fmt;
	    if(defined($formatting)) {
		print $formatting;
	    }
	    print $_, "\n";
	}
	foreach (@fmt_tail) {
	    print $_;
	}
    }
}

if ($n_records > 0) {
    if ($dummy) {
	print "\n\\phantom{Dummy}\n";
    }
} else {
    warn "no input given";
    pod2usage(2);
}

__END__

=head1 NAME

format_labels - Convert Plain Text to Formatted Name Tags

=head1 SYNOPSIS

format_labels.pl [options] [file ...]

Options:
  --help                 brief help message
  --man                  full documentation
  --template             produce template files
  -n <number of copies>
  --headfile <file>
  --linefile <file>
  --tailfile <file>
  --namefile <file>
  --no-dummy             disable dummy label
  --overwrite
  --version

=head1 DESCRIPTION

B<format_labels> will read the given input file(s) and / or standard
input and produce LaTeX code to the standard output stream.

Note that when multiple input sources are used, empty lines will have
to be used to separate the first record of each file from the last
record of the previous file.

=head2 Workflow

=over

=item 1. C<< format_labels.pl --template >>

=item 2. Edit name records, formatting code

=item 3. C<format_labels.pl>

=item 4. C<pdflatex>

=item 5. Ready PDF document

=back

=head2 Name Records

The input should consist of multi-line records separated by blank
lines.  Sample input:

    Firstname1 Lastname1
    Institute1
    Country1
 
    Firstname2 Lastname2
    Institute2
    Country2

=head2 Formatting

=head3 Page Layout

The layout of output pages is adjusted in the main LaTeX source file.
See the documentation of the L<labels
package|http://mirror.ctan.org/macros/latex/contrib/labels>.

=head3 Label Design

Three files affect the label design.  See the options B<--headfile>,
B<--linefile> and B<--tailfile>.

=head2 Output

The output of B<format_labels> is LaTeX code representing formatted
labels.

=head1 OPTIONS

=over

=item B<--help>

Prints a brief help message and exits.

=item B<--man>

Prints the complete manual page and exits.

=item B<--template>

Prints the main LaTeX document to standard output and writes a set of
template files, then exits. The names of the files produced can be
changed by using B<--headfile>, B<--linefile>, B<--tailfile> and
B<--namefile>.

=item B<-n> <number of copies>

Each label is repeated this many times.

=item B<--headfile> <file>

Contents of <file> will be copied verbatim to the beginning of each
label, before the actual contents. Default file is F<label_head.tex>.

=item B<--linefile> <file>

Contents of <file> will be used for formatting the text of the labels.
Default file is F<label_line.tex>.

=item B<--tailfile> <file>

Contents of <file> will be copied verbatim to the end of each label,
after the actual contents. Default file is F<label_tail.tex>.

=item B<--namefile> <file>

When B<--template> is used, this changes the filename of the name
record template to produce.  Default file is F<names_raw.txt>.

=item B<--no-dummy>

Disables the printing of a final empty label used to circumvent a
layout bug.

=item B<--overwrite>

If set, B<--template> will overwrite existing files.

=item B<--version>

Prints the version number and exits.

=back

=head1 DIAGNOSTICS

The following warnings or errors may be reported:

=over

=item file %s exists

The B<--template> option was used without B<--overwrite>, and file %s
already exists.  You may change the output filename with one of the
filename options, relocate the existing file or overwrite it.

=item cannot open > %s

It is not possible to write to file %s.  Try a different output
filename or change file or directory permissions.

=item cannot open < %s

It is not possible to read from file %s.  Try creating template files.

=item no input given

The program expects some non-empty lines as input.  See L</"Name
Records">.

=back

=head1 EXAMPLES

The example walks through the whole process.  Default filenames are
used.  The numbering is the same as in L</"Workflow">.

=over

=item 1. Create template files

When starting from scratch, create template files:
    format_labels.pl --template > nametags.tex

=item 2. Edit name records, label style files and LaTeX source

The filenames are F<names_raw.txt>, F<label_head.tex>,
F<label_line.tex>, F<label_tail> and F<nametags.tex>.

=item 3. Apply label style to name records

    format_labels.pl < names_raw.txt > names.dat

=item 4. Compile LaTeX document

    pdflatex nametags

=item 5. Print the labels

Open F<nametags.pdf> with a PDF viewer, then print.

=back

Tips:

=over

=item * It is probably best to print one test page to see that
everything is right.  The command C<\LabelGridtrue> in the main LaTeX
source file will print a grid that can be helpful for checking the
page layout.

=item * You can get folded two-sided labels by using B<-n> 2 with a
layout of 2 labels per row.

=back

=head1 FILES

=over

=item Main LaTeX source file (stdout when --template)

In addition to containing the layout details, any required packages
(colors, graphics, etc.) must also be included here.

=item Name record file (stdin or named files)

See L</"Name Records">.

=item File in --headfile

Can be used for including conference logos, locations, dates, etc.

=item File in --linefile

The first line of <file> will be inserted before the first input line
of each record, the second formatting line will take effect before the
second input line, etc.

=item File in --tailfile

Can be used for closing any environments that were left open in the
header of the label.

=back

=head1 AUTHOR

Mikko Korpela, mvkorpel@iki.fi

=head1 COPYRIGHT AND LICENSE

Copyright 2012, 2013 Mikko Korpela

This program is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<The labels package for
LaTeX|http://mirror.ctan.org/macros/latex/contrib/labels>

=cut

