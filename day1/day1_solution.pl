#!/usr/local/bin/perl
#===============================================================================
=head1 NAME

day1_solution.pl

=cut

use Modern::Perl;

my $filename = "input1.txt";

my $file = IO::File->new($filename) or die "cannot open $filename: $!";

my @elves;
my $current_elf = 0;

foreach ( <$file> )  {
  chomp;
  if ( /^$/ ) {
    $current_elf++;
  }
  else {
    $elves[$current_elf] += $_;
  }
}
my @sorted_elves = sort { $b <=> $a } @elves;

say "part 1 answer = $sorted_elves[0]";
say "part 2 answer = " . ($sorted_elves[0] + $sorted_elves[1] + $sorted_elves[2]);

#===============================================================================
__END__
#===============================================================================
