#!/usr/local/bin/perl
#===============================================================================
=head1 NAME

day5_solution.pl

=cut

use Modern::Perl;
use Data::Dumper;

my $filename = "input.txt";

my $file = IO::File->new($filename) or die "cannot open $filename: $!";

my @input_file = <$file>;
chomp @input_file;

# Get crate data (not my finest work, but does the job - LOL)
my @crates_data;
my $got_crates;
while (@input_file) {

  my $line = shift @input_file;
  if ( $line =~ /^$/ ) {
    $got_crates = 1;
    last;
  }
  push @crates_data, $line;
}
foreach my $line ( @crates_data ) {
  $line =~ s/   /./g;
  $line =~ s/ //g;
  $line =~ s/\[//g;
  $line =~ s/\]//g;
  $line =~ s/\.\././g;
  $line =~ s/([0-9])./$1/g;
}

my $count = 0;
my %crates1;
my %crates2;
foreach my $line (reverse @crates_data) {
  if ( $count == 0 ) {
    foreach my $crate_num ( split //, $line ) {
      $crates1{$crate_num} = [];
      $crates2{$crate_num} = [];
    }
  } else {
    my $crate_num = 0;
    foreach my $item ( split //, $line ) {
      $crate_num++;
      next if $item eq '.';
      push @{$crates1{$crate_num}}, $item;
      push @{$crates2{$crate_num}}, $item;
    }
  }
  $count++;
}

# Get instructions and move stuff about
foreach my $instruction ( @input_file ) {
  if ( $instruction =~ /move (\d+) from (\d) to (\d)/ ) {
    my $item_count       = $1;
    my $crate_num_source = $2;
    my $crate_num_dest   = $3;

    my @items_to_move1;
    my @items_to_move2;
    foreach my $item ( 1 .. $item_count ) {
      push @items_to_move1, pop @{$crates1{$crate_num_source}};
      push @items_to_move2, pop @{$crates2{$crate_num_source}};
    }
    push @{$crates1{$crate_num_dest}}, @items_to_move1;
    push @{$crates2{$crate_num_dest}}, reverse @items_to_move2;
  }
}

#CFFHVVHNC

print "Part 1: ";
foreach ( 1 .. 9 ) {
  print $crates1{$_}->[-1];
}
print "\n";

print "Part 2: ";
foreach ( 1 .. 9 ) {
  print $crates2{$_}->[-1];
}
print "\n";





#===============================================================================
__END__
#===============================================================================
