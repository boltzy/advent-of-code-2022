#!/usr/local/bin/perl
#===============================================================================
=head1 NAME

day8_solution.pl

=cut

use Modern::Perl;
use Data::Dumper;

my $filename = "input.txt";

my $file = IO::File->new($filename) or die "cannot open $filename: $!";

my @data = <$file>;
chomp @data;

# Build map of trees
my @trees;
my $row_num = 0;

foreach my $row ( @data ) {
  my @tree_row;
  my $column_num = 0;
  foreach my $tree_height ( split //, $row ) {
    push @tree_row, { height => $tree_height, row => $row_num, column => $column_num };
    $column_num++;
  }
  push @trees, \@tree_row;
  $row_num++;
}
#say Dumper \@trees;

my $total_visible = 0;
my @scenic_scores;

# Determine visibility and scenic score of each tree
foreach my $row ( 0 .. $#trees ) {
  foreach my $column ( 0 .. $#{ $trees[$row] } ) {
#    say "($row, $column)";
    my $tree   = $trees[$row][$column];
    my $height = $tree->{height};

    ($tree->{scenic_top},    $tree->{visible_from_top})    = visible_from_top( $height, $column, $row, 0 );
    ($tree->{scenic_bottom}, $tree->{visible_from_bottom}) = visible_from_bottom( $height, $column, $row, $row + 1 );
    ($tree->{scenic_left},   $tree->{visible_from_left})   = visible_from_left( $height, $column, $row, 0 );
    ($tree->{scenic_right},  $tree->{visible_from_right})  = visible_from_right( $height, $column, $row, $column + 1 );

    $tree->{scenic_score} = 1;
    foreach ( qw( scenic_top scenic_bottom scenic_left scenic_right) ) {
      $tree->{scenic_score} *= $tree->{$_}  if $tree->{$_};
    }
    push @scenic_scores, $tree->{scenic_score};

    $total_visible++
      if $tree->{visible_from_top}
      || $tree->{visible_from_bottom}
      || $tree->{visible_from_left}
      || $tree->{visible_from_right};
  }
}
#say Dumper \@trees;
#say Dumper \@scenic_scores;

my ($biggest_scenic_score) = sort { $b <=> $a } @scenic_scores;
say "Total visible trees = $total_visible";
say "Biggest scenic_score = $biggest_scenic_score";

# Yes these functions below should all probably be refactored into a single
# parameterised function, oh well...

#-------------------------------------------------------------------------------
sub visible_from_top {
  my ( $tree_height, $column, $row, $start_row ) = @_;

  my $scenic_score     = 0;
  my $got_scenic_score = 0;

  return (0, 1) if $row == 0;
  my $end_row = $row - 1;

  my @tree_heights;
  my $current_row = $end_row;
  while ( $current_row >= $start_row ) {
    my $current_tree_height = $trees[$current_row][$column]->{height};
    push @tree_heights, $current_tree_height;

    $current_row--;

    next if $got_scenic_score;
    $scenic_score++;
    $got_scenic_score = 1 if $current_tree_height >= $tree_height;
  }
  my ($tallest) = sort { $b <=> $a } @tree_heights;

  my $visible = $tallest < $tree_height ? 1 : 0;

  return ($scenic_score, $visible);
}

#-------------------------------------------------------------------------------
sub visible_from_bottom {
  my ( $tree_height, $column, $row, $start_row ) = @_;

  my $scenic_score     = 0;
  my $got_scenic_score = 0;

  return (0, 1) if $row == $#trees;
  my $end_row = $#trees;

  my @tree_heights;
  my $current_row = $start_row;
  while ( $current_row <= $end_row  ) {
    my $current_tree_height = $trees[$current_row][$column]->{height};
    push @tree_heights, $current_tree_height;
    $current_row++;

    next if $got_scenic_score;
    $scenic_score++;
    $got_scenic_score = 1 if $current_tree_height >= $tree_height;
  }
  my ($tallest) = sort { $b <=> $a } @tree_heights;

  my $visible = $tallest < $tree_height ? 1 : 0;

  return ($scenic_score, $visible);
}

#-------------------------------------------------------------------------------
sub visible_from_left {
  my ( $tree_height, $column, $row, $start_column ) = @_;

  my $scenic_score     = 0;
  my $got_scenic_score = 0;

  return (0, 1) if $column == 0;
  my $end_column = $column - 1;

  my @tree_heights;
  my $current_column = $end_column;
  while ( $current_column >= $start_column  ) {
    my $current_tree_height = $trees[$row][$current_column]->{height};
    push @tree_heights, $current_tree_height;
    $current_column--;

    next if $got_scenic_score;
    $scenic_score++;
    $got_scenic_score = 1 if $current_tree_height >= $tree_height;
  }
  my ($tallest) = sort { $b <=> $a } @tree_heights;

  my $visible = $tallest < $tree_height ? 1 : 0;

  return ($scenic_score, $visible);
}

#-------------------------------------------------------------------------------
sub visible_from_right {
  my ( $tree_height, $column, $row, $start_column ) = @_;

  my $scenic_score     = 0;
  my $got_scenic_score = 0;

  return (0, 1) if $column == $#{ $trees[0] };
  my $end_column = $#{ $trees[0] };

  my @tree_heights;
  my $current_column = $start_column;
  while ( $current_column <= $end_column  ) {
    my $current_tree_height = $trees[$row][$current_column]->{height};
    push @tree_heights, $current_tree_height;
    $current_column++;

    next if $got_scenic_score;
    $scenic_score++;
    $got_scenic_score = 1 if $current_tree_height >= $tree_height;
  }
  my ($tallest) = sort { $b <=> $a } @tree_heights;

  my $visible = $tallest < $tree_height ? 1 : 0;

  return ($scenic_score, $visible);
}

#
#===============================================================================
__END__
#===============================================================================
