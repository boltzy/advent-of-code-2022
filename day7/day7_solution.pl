#!/usr/local/bin/perl
#===============================================================================
=head1 NAME

day7_solution.pl - by far my 'hackyist'

=cut

use Modern::Perl;
use Data::Dumper;

my $filename = "input.txt";

my $file = IO::File->new($filename) or die "cannot open $filename: $!";

my @data = <$file>;
chomp @data;

# Build directory tree from instructions
my %tree;
$tree{root} = {};
my $parent_node;
my $current_node = $tree{root};
my @pos          = ($current_node);

foreach my $line (@data) {
  if ( $line =~ /^(\d+) (\S+)$/ ) {
    my $size = $1;
    my $name = $2;
    $current_node->{$name} = $size;
#    say "adding file $name of $size";
  }
  elsif ( $line =~ /^dir (\S+)$/ ) {
    my $name = $1;
    $current_node->{$name} = {};
#    say "adding empty dir $name";
  }
  elsif ( $line =~ /^\$ cd \/$/ ) {
    $current_node = $tree{root};
#    say "changing dir to /";
  }
  elsif ( $line =~ /^\$ cd \.\.$/ ) {
    pop @pos;
    $current_node = $pos[-1];
    $parent_node  = $pos[-2];
#    say "changing dir to parent";
  }
  elsif ( $line =~ /^\$ cd (\S+)$/ ) {
    my $name = $1;
    $parent_node = $pos[-1];
    push @pos, $current_node->{$name};
    $current_node = $pos[-1];
#    say "changing dir to $name";
  }
}

# Naughty global vars
my $total_used        = 0;
my @dir_sizes;

# Calculate dir sizes
dir_size('root',\%tree);

say "";
say "Total used space (files under 100K) = $total_used";

my @sorted_dir_sizes = sort { $a->{size} <=> $b->{size} } @dir_sizes;

my ($disk_used)       = map { $_->{size} } grep { $_->{name} eq 'root' } @dir_sizes;
my $disk_total        = 70000000;
my $space_for_upgrade = 30000000;
my $disk_free         = $disk_total - $disk_used;
my $need_to_freeup    = $space_for_upgrade - $disk_free;

my $smallest_to_delete;
foreach ( sort { $a->{size} <=> $b->{size} } @dir_sizes ) {
  if ( $_->{size} >= $need_to_freeup ) {
    $smallest_to_delete = $_->{size};
    last;
  }
}

say "The smallest file we need to delete = $smallest_to_delete"
  . " (this will leave "
  . ( $disk_free + $smallest_to_delete )
  . " free space for upgrade)";


sub dir_size {
  my ($name, $dir) = @_;
  my $size = 0;

  foreach ( keys %{$dir} ) {
    if (ref($dir->{$_})) {                # recurse into directory
      $size += dir_size($_, $dir->{$_});
#      say "dir $_ = " . $size;
    } else 
    {
      $size += $dir->{$_};
    }
  }

  $total_used += $size if $size <= 100_000;

  push @dir_sizes, { name => $name, size => $size };

#  say "Total size of $name = $size";

  return $size;
}



#===============================================================================
__END__
#===============================================================================
