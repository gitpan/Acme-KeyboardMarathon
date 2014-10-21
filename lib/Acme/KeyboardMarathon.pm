package Acme::KeyboardMarathon;
$Acme::KeyboardMarathon::VERSION = '1.21';

use Carp;
use Data::Dumper;
use Math::BigInt;

use integer;
use warnings;
use strict;

sub new {
  my @args = @_;
  my $class = shift @args;
  my $self = {};
  bless($self,$class);

  # all measures in 100ths of a cm

  my $depress_distance = 25;
  my $shift_distance = 200;

  my %basic_distances = ( # basic distance traveled horizontally for a key
       '0'   => q{AaSsDdFfJjKkLl;: },
       '200' => q{QqWwGgHhEeRrTtYyUuIiOoPpZzXxCcVvNnMm,<>./?'"},
       '400' => q{]123478905Ii-_!@#$%&*()} . '}' . "\n",
       '450' => q{=+},
       '230' => '[' . '{'. "\t",
       '350' => 'Bb',
       '500' => '6^`~',
       '550' => '\\|',
  );

  my %shifted; # lookup hash to see if a key is shifted
  for my $key ( split '', '!@#$%^&*()_+<>?:"{}|~\'' . join('','A'..'Z') ) {
    $shifted{$key}++;
  }

  for my $hdist ( keys %basic_distances ) {
    for my $key ( split '', $basic_distances{$hdist} ) {
      $self->{k}->{$key} = ( $hdist + $depress_distance + ( $shifted{$key} ? $shift_distance : 0 ) ) + 0;
    }
  }

  $self->{k}->{"\r"} = 0;
  return $self;
}

# split is 2m27.476s for 9.3megs of text (9754400 chars)
sub distance {
  my $self = shift @_;
  my $distance = Math::BigInt->bzero();
  for my $i (0 .. $#_) {
    croak "FAR OUT! A REFERENCE: $_[$i]" if ref $_[$i];
    for my $char ( split '', $_[$i] ) {
      unless ( defined $self->{k}->{$char} ) {
        carp "WHOAH! I DON'T KNOW WHAT THIS IS: [$char] assigning it a 2.5 cm distance\n";
        $self->{k}->{$char} = 250;
      }
      $distance += $self->{k}->{$char};
    }
  }
  $distance /= 100;
  return $distance->bstr();
}

# substr is 2m30.419s
#sub distance {
#  my $self = shift @_;
#  my $distance = Math::BigInt->bzero();
#  for my $i (0 .. $#_) {
#    croak "FAR OUT! A REFERENCE: $_[$i]" if ref $_[$i];
#    my $length = length($_[$i]) - 1;
#    for my $s ( 0 .. $length ) {
#      my $char = substr($_[$i],$s,1);
#      unless ( defined $self->{k}->{$char} ) {
#        carp "WHOAH! I DON'T KNOW WHAT THIS IS: [$char] at $s assigning it a 2.5 cm distance\n";
#        $self->{k}->{$char} = 250;
#      }
#      $distance += $self->{k}->{$char};
#    }
#  }
#  $distance /= 100;
#  return $distance->bstr();
#}

# Regex is 2m32.690s
#sub distance {
#  my $self = shift @_;
#  my $distance = Math::BigInt->bzero();
#  for my $i (0 .. $#_) {
#    croak "FAR OUT! A REFERENCE: $_[$i]" if ref $_[$i];
#    while ( $_[$i] =~ /(.)/gs ) {
#      my $char = $1;
#      unless ( defined $self->{k}->{$char} ) {
#        carp "WHOAH! I DON'T KNOW WHAT THIS IS: [$char] assigning it a 2.5 cm distance\n";
#        $self->{k}->{$char} = 250;
#      }
#      $distance += $self->{k}->{$char};
#    }
#  }
#  $distance /= 100;
#  return $distance->bstr();
#}


1;
__END__

=head1 NAME

Acme::KeyboardMarathon - How far have your fingers ran?

=head1 SYNOPSIS

  use Acme::KeyboardMarathon;    

  my $akm = new Acme::KeyboardMarathon;

  my $distance_in_cm = $akm->distance($bigtext);

NB: Included in this distribution is an example script (marathon.pl) that can
be used to calculate distance from files provided as arguments:

  $> ./marathon.pl foo.txt bar.txt baz.txt
  114.05 m

=head1 DESCRIPTION

Acme::KeyboardMarathon will calculate the approximate distance traveled by
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
Acme module, after all. Send me a patch with the right math if you're bored.

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

=head1 BUGS AND SOURCE

	Bug tracking for this module: https://rt.cpan.org/Dist/Display.html?Name=Acme-KeyboardMarathon

	Source hosting: http://www.github.com/bennie/perl-Acme-KeyboardMarathon

=head1 VERSION

	Acme::KeyboardMarathon v1.21 (2014/03/21)

=head1 COPYRIGHT

	(c) 2012-2014, Efrain Klein <efrain.klein@gmail.com> & Phillip Pollard <bennie@cpan.org>

=head1 LICENSE

This source code is released under the "Perl Artistic License 2.0," the text of
which is included in the LICENSE file of this distribution. It may also be
reviewed here: http://opensource.org/licenses/artistic-license-2.0

=head1 AUTHORSHIP

Efrain Klein <efrain.klein@gmail.com> & Phillip Pollard <bennie@cpan.org>

As much as I wish I could be fully blamed for this, I must admit that
Mr. Efrain Klein came up with the awesome idea, took the time to make the
measurements, and wrote the original code in Python. I just made sure it 
was less readable, in Perl.

Additional patches from Mark A. Smith. <jprogrammer082@gmail.com>
