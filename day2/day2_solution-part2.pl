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
);

my %code_to_desired_outcome = (
  X => "lose",
  Y => "draw",
  Z => "win",
);

# Their item and my desired outcome
my %my_item_for_desired_outcome = (
  Rock_draw     => 'Rock',
  Paper_draw    => 'Paper',
  Scissors_draw => 'Scissors',
  Scissors_win  => 'Rock',
  Rock_win      => 'Paper',
  Paper_win     => 'Scissors',
  Scissors_lose => 'Paper',
  Rock_lose     => 'Scissors',
  Paper_lose    => 'Rock',
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
  my $oppenent_item            = $code_to_item{$oppenent_code};
  my $desired_outcome          = $code_to_desired_outcome{$my_code};
  my $item_for_desired_outcome = $my_item_for_desired_outcome{ $oppenent_item . '_' . $desired_outcome };
  my $items                    = $oppenent_item . $item_for_desired_outcome;
  my $outcome                  = $outcomes{$items};

  my $points = $points_for{$outcome} + $points_for_item{$item_for_desired_outcome};
  say "$items = $outcome (I needed $item_for_desired_outcome to $desired_outcome, I scored $points)";
  $score += $points;
}

say "My total points = $score";

#===============================================================================
__END__
#===============================================================================
