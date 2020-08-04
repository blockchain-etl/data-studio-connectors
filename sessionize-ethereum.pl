#!/usr/bin/perl
=pod
--root level tx
SELECT from_address AS u
, ARRAY_AGG(DISTINCT(UNIX_SECONDS(block_timestamp))) AS ss_array
FROM `bigquery-public-data.crypto_ethereum.traces`
WHERE trace_address IS NULL
GROUP BY u
=cut
use strict;
use POSIX qw(strftime);
use JSON;
use constant TTL => 30 * 60; #Google Analytics uses 30 minutes
my $JJ = new JSON;
$JJ->canonical(1);
my $S = 1;
while ( my $line = <> ) {
  chomp $line;
  my $agg = $JJ->decode( $line );
  my $sessions = sessionize( $agg->{ ss_array } );
  foreach my $s ( @$sessions ) {
    foreach my $t ( @$s ) {
      print $JJ->encode({
        address => $agg->{u},
        block_timestamp => strftime("%Y-%m-%d %H:%M:%S UTC",localtime($t)),
        session_id => $S,
      }), "\n";
    }
    $S++;
  }
}

sub sessionize {
  my $agg = shift;
  my @t = sort { $a <=> $b } map { int $_ } @$agg;
  if ( scalar( @t ) == 1 ) {
    return ( 1 => [\@t] );
  }
  my $prev_t = $t[0];
  my $i = 0;
  my $sess = [[]];
  my $buf = [];
  foreach my $t ( @t ) {
    if ( $t > $prev_t + TTL ) {
      $sess->[$i++] = $buf;
      $buf = [$t];
    }
    else {
      push @$buf, $t;
    }
    $prev_t = $t;
  }
  if ( scalar( @$buf ) ) {
    $sess->[ $i ] = $buf;
  }
  return $sess;
}
