#!/usr/local/bin/perl
#===============================================================================
=head1 NAME

day6_solution.pl

=cut

use Modern::Perl;
use Data::Dumper;

my $filename = "input.txt";

my $file = IO::File->new($filename) or die "cannot open $filename: $!";

my @file_data = <$file>;
chomp @file_data;
my $stream = shift @file_data;
say $stream;

my %config = (
  part1_start_of_packet  => 4,
  part2_start_of_message => 14,
);


foreach my $part ( sort keys %config ) {
  my $char_count  = 0;
  my $chunk_count = 0;
  my $chunk_size  = $config{$part};
  my @chunk;

  foreach my $char ( split //, $stream ) {
    $char_count++;
    $chunk_count++;
    push @chunk, $char;
    next if $char_count < $chunk_size;

    my %check;
    $check{$_}++ foreach @chunk;
    #    say "Got: " . ( join '', @chunk ) . "  count=$char_count";

    if ( keys %check == $chunk_size ) {
      last;
    }
    else {
      $chunk_count = 0;
      shift @chunk;
    }
  }

  say "$part = $char_count";
}

#===============================================================================
__END__
#===============================================================================
