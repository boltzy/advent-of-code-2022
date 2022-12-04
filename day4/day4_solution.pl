#!/usr/local/bin/perl
#===============================================================================
=head1 NAME

day4_solution.pl

=cut

use Modern::Perl;
use Data::Dumper;

my $filename = "input.txt";

my $file = IO::File->new($filename) or die "cannot open $filename: $!";

my @elf_pairs = <$file>;
chomp @elf_pairs;

my $subsets    = 0;
my $intersects = 0;
my $pair_count = 0;

foreach my $elf_pair (@elf_pairs) {
  $pair_count++;
  my @elf_ranges = split /,/, $elf_pair;
  my @elf1_range = split /-/, $elf_ranges[0];
  my @elf2_range = split /-/, $elf_ranges[1];

  if ( ( $elf1_range[0] >= $elf2_range[0] && $elf1_range[1] <= $elf2_range[1] )
    || ( $elf2_range[0] >= $elf1_range[0] && $elf2_range[1] <= $elf1_range[1] ) )
  {
    say "Subset found in[$pair_count]: $elf_pair";
    $subsets++;
  }
  if ( ( $elf1_range[0] >= $elf2_range[0] && $elf1_range[1] <= $elf2_range[1] )
    || ( $elf2_range[0] >= $elf1_range[0] && $elf2_range[1] <= $elf1_range[1] )
    || ( $elf1_range[0] <= $elf2_range[1] && $elf1_range[1] >= $elf2_range[0] )
    || ( $elf2_range[0] <= $elf1_range[1] && $elf2_range[1] >= $elf1_range[0] ) )
  {
    say "Intersectionfound in[$pair_count]: $elf_pair";
    $intersects++;
  }
}

say "Total enclosed ranges = $subsets";
say "Total overlapping ranges = $intersects";


#===============================================================================
__END__
#===============================================================================
