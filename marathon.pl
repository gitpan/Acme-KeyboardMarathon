#!/usr/bin/perl -Ilib

=head2 marathon.pl

Example usage of the Acme::KeyboardMarathon module. Just give it filename(s) on 
the command line as arguments and it returns the total distance.

  $> ./marathon.pl foo.txt bar.txt baz.txt

=cut

use Acme::KeyboardMarathon;
use strict;
use warnings;

my $akm = new Acme::KeyboardMarathon;

our @ARGV;
my $total = 0;

for my $file ( @ARGV ) {
  print STDERR "Skipping [$file] as it is not a file\n" unless -f $file;
  open INFILE, '<', $file;
  while ( my $line = <INFILE> ) {
    $total += $akm->distance($line);
  }
  close INFILE;
}

if ( $total > 100000 ) {
  $total /= 100000;
  print sprintf('%0.2f',$total) . " km\n";
} elsif ( $total > 100 ) {
  $total /= 100;
  print sprintf('%0.2f',$total) . " m\n";
} else {
  print $total . " cm\n";
}