#!/usr/local/bin/perl
#===============================================================================
=head1 NAME

day3_solution-part2.pl

=cut

use Modern::Perl;
use List::Util qw(uniq);
use Data::Dumper;

my $filename = "input.txt";

my $file = IO::File->new($filename) or die "cannot open $filename: $!";

my $priority = 1;
my %priorities = map { $_ => $priority++ } ('a' .. 'z', 'A' .. 'Z');

my $total_priority = 0;

my @rucksacks = <$file>;
chomp @rucksacks;

my @groups;
my $group = [];

foreach my $rucksack (@rucksacks) {
  if ( @$group == 3 ) {
    push @groups, $group;
    $group = [],
  }
    push @$group, $rucksack;
}
push @groups, $group if @$group;

my $group_cnt = 0;
foreach my $group (@groups) {
  $group_cnt++;
  my %item_frequency;

  my $rucksack1 = $group->[0];
  my $rucksack2 = $group->[1];
  my $rucksack3 = $group->[2];

  my %elf1_items;
  my %elf2_items;
  my %elf3_items;

  $elf1_items{$_}++ foreach split //, $rucksack1;
  $elf2_items{$_}++ foreach split //, $rucksack2;
  $elf3_items{$_}++ foreach split //, $rucksack3;

  my %all_items = map { $_ => 1 } keys %elf1_items, keys %elf2_items, keys %elf3_items;

  foreach my $item ( keys %all_items ) {
    if ( exists $elf1_items{$item} && exists $elf2_items{$item} && exists $elf3_items{$item} ) {
      say "group[$group_cnt] has badge $item";
      $total_priority += $priorities{$item};
    }
  }
}

say "Total priority = $total_priority";


#===============================================================================
__END__
#===============================================================================
