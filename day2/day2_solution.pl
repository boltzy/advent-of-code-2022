#!/usr/local/bin/perl
#===============================================================================
=head1 NAME

day2_solution.pl

=cut

use Modern::Perl;

my $filename = "input.txt";

my $file = IO::File->new($filename) or die "cannot open $filename: $!";

my %points_for_item = (
  Rock     => 1,
  Paper    => 2,
  Scissors => 3,
);

my %points_for = ( win => 6, draw => 3, lose => 0 );

my %code_to_item = (
  A => "Rock",
  B => "Paper",
  C => "Scissors",
  X => "Rock",
  Y => "Paper",
  Z => "Scissors",
);

# Outcomes when opponent item LEFT, my item RIGHT
my %outcomes = (
  RockRock         => 'draw',
  PaperPaper       => 'draw',
  ScissorsScissors => 'draw',
  ScissorsRock     => 'win',
  RockPaper        => 'win',
  PaperScissors    => 'win',
  ScissorsPaper    => 'lose',
  RockScissors     => 'lose',
  PaperRock        => 'lose',
);

my $score;

foreach (<$file>) {
  chomp;
  my ( $oppenent_code, $my_code ) = split;
  my $items   = $code_to_item{$oppenent_code} . $code_to_item{$my_code};
  my $outcome = $outcomes{$items};

  my $points = $points_for{$outcome} + $points_for_item{ $code_to_item{$my_code} };
  say "$items = $outcome (I scored $points)";
  $score += $points;
}

say "Part 1, my total points = $score";



#===============================================================================
__END__
#===============================================================================
