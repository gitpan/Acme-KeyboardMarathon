package ACME::KeyboardMarathon;

use Carp;
use warnings;
use strict;

sub new {
  my @args = @_;
  my $class = shift @args;
  my $self = {};
  bless($self,$class);

  our $VERSION = '1.14';

  # all measures in cm

  my $DEPRESS_CONSTANT = '0.25';
  my $SHIFT_DISTANCE = '2';

  my %basic_distances = ( # basic distance traveled horizontally for a key
       '0'   => q{AaSsDdFfJjKkLl;: },
       '2'   => q{QqWwGgHhEeRrTtYyUuIiOoPpZzXxCcVvNnMm,<>./?'"},
       '4'   => q{]123478905Ii-_!@#$%&*()} . '}' . "\n",
       '4.5' => q{=+},
       '2.3' => '[' . '{'. "\t",
       '3.5' => 'Bb',
       '5'   => '6^`~',
       '5.5' => '\\|',
  );

  my %shifted; # lookup hash to see if a key is shifted
  for my $key ( split '', '!@#$%^&*()_+<>?:"{}|~\'' . join('','A'..'Z') ) {
    $shifted{$key}++;
  }

  for my $hdist ( keys %basic_distances ) {
    for my $key ( split '', $basic_distances{$hdist} ) {
      $self->{k}->{$key} = $hdist + $DEPRESS_CONSTANT + ( $shifted{$key} ? $SHIFT_DISTANCE : 0 );
    }
  }

  return $self;
}

sub distance {
  my @args = @_;
  my $self = shift @args;
  my $distance = 0;
  while ( my $chunk = shift @args ) {
    croak "FAR OUT! A REFERENCE: $chunk" if ref $chunk;
    for my $char ( split '', $chunk ) {
      carp "WHOAH! I DON'T KNOW WHAT THIS IS: [$char]\n" and next unless defined $self->{k}->{$char};
      $distance += $self->{k}->{$char};
    }
  }
  return $distance;
}

1;
__END__

=head1 NAME

ACME::KeyboardMarathon - How far have your fingers ran?

=head1 SYNOPSIS

  use ACME::KeyboardMarathon;    

  my $akm = new ACME::KeyboardMarathon;

  my $distance_in_cm = $akm->distance($bigtext);

NB: Included in this distribution is an example script (marathon.pl) that can
be used to calculate distance from files provided as arguments:

  $> ./marathon.pl foo.txt bar.txt baz.txt
  114.05 m

=head1 DESCRIPTION

ACME::KeyboardMarathon will calculate the approximate distance traveled by
your fingers to type a given string of text.

This is useful to see just how many meter/miles/marathons your fingers have
ran for you to type your latest piece of code or writing.

=head1 METHODOLOGY

In proper typing, for all but the "home row" letters, our fingers must travel
a short horizontal distance to reach the key. For all keys, there is also a
short distance to press the key downward. 

Measurements were take on a standard-layout IBM type-M keyboard to the nearest 
1/3rd of a centimeter for both horizontal and vertical (key depth) travel
by the finger.

Additionally, use of the shift key was tracked and its distance was included
for each calculation.

This produces an index of "distance traveled" for each possible key-press, 
which is then used to calculate the "total distance traveled" for a given
piece of text.

=head1 BUGS AND LIMITATIONS

* This module calculates the linear distance traversed by adding vertical 
and horizontal motion of the finger. The motion traversed is actually an 
arc, and while that calculation would be more accurate, this is an 
ACME module, after all. Send me a patch with the right math if you're bored.

* A QWERTY keyboard is assumed. DVORAK people are thus left out in the cold. 
As they should be. The freaks.

* I assume there are no gaps between your keys. This means all those stylish 
Mac keyboard folks are actually doing more work than they're credited for. 
But I'm ok with that.

* I assume you actually use standard home row position. Just like Mavis Beacon 
told you to.

* I assume you return to home row after each stroke and don't take shortcuts to
the next key. Lazy typists!

* I assume that you never make mistakes and never use backspaces while typing.
We're all perfect, yes?

* I assume that you do not type via the use of copy and paste. Especially not
using copy and paste from Google. Right? RIGHT?!?!??

* I'VE NEVER HEARD OF CAPS LOCK. YOU PRESSED THAT SHIFT KEY AND RETURNED TO 
HOME ROW FOR EVERY CAPITAL LETTER!!!!!!!

* I am a horrible American barbarian and have only bothered with the keys that
show up on my American barbarian keyboard. I'll add the LATIN-1 things with 
diacritics later, so I can feel better while still ignoring UTF's existence.

=head1 AUTHOR

Efrain Klein <efrain.klein@gmail.com> & Phillip Pollard <bennie@cpan.org>

As much as I wish I could be fully blamed for this, I must admit that
Mr. Efrain Klein came up with the awesome idea, took the time to make the
measurements, and wrote the original code in Python. I just made sure it 
was less readable, in Perl.

Additional patches from Mark A. Smith. <jprogrammer082@gmail.com>

=head1 VERSION

  ACME::KeyboardMarathon v1.14 2013/04/29
  
=head1 LICENSE AND COPYRIGHT
  
  (c) 2012-2013, Efrain Klein <efrain.klein@gmail.com> & Phillip Pollard <bennie@cpan.org>
  Released under the Perl Artistic License


