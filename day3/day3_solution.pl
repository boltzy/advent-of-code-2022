#!/usr/local/bin/perl
#===============================================================================
=head1 NAME

day3_solution.pl

=cut

use Modern::Perl;

my $filename = "input.txt";

my $file = IO::File->new($filename) or die "cannot open $filename: $!";

my $priority = 1;
my %priorities = map { $_ => $priority++ } ('a' .. 'z', 'A' .. 'Z');

my $total_priority = 0;

my @rucksacks = <$file>;
chomp @rucksacks;

foreach (@rucksacks) {
  my @items = split //;

  my @comp1 = @items[0 .. ($#items / 2)];
  my @comp2 = @items[($#items / 2) + 1 .. $#items];

  my %item_frequency_comp1;
  my %item_frequency_comp2;
  $item_frequency_comp1{$_}++ foreach @comp1;
  $item_frequency_comp2{$_}++ foreach @comp2;

  my %items_in_both = map { $_ => 1 } grep { exists $item_frequency_comp1{$_} && exists $item_frequency_comp2{$_} } @items;

  my $priority_for_items = 0;

  foreach my $item (keys %items_in_both ) {
    $priority_for_items += $priorities{$item};
  };
  say "rucksack priority = $priority_for_items";

  $total_priority += $priority_for_items;
}

say "Total priority = $total_priority";


#===============================================================================
__END__
#===============================================================================
