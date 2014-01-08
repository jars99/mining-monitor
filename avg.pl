#!/usr/bin/perl

use Data::Dumper;               # Perl core module
use strict;                     # Good practice
use warnings;                   # Good practice

my $HSTORE="/home/jars99/hashrate.txt";
my $LOG="/var/log/hash_check.log";

#Get the current date
my $date = `date`;
chomp($date);
my @lasthour = `tail -n 12 $HSTORE`;
my @lastsix = `tail -n 72 $HSTORE`;
my @lastday = `tail -n 240 $HSTORE`;
#print Dumper @lasthour;
my $hourtotal = &getTotal(@lasthour);
my $sixtotal = &getTotal(@lastsix);
my $daytotal = &getTotal(@lastday);
#print "Total = $total\n";
$hourtotal = int($hourtotal / 12);
$sixtotal = int($sixtotal / 72);
$daytotal = int($daytotal / 240);
print "Averages: for the last hour: $hourtotal, 6 hours: $sixtotal, day: $daytotal\n";

sub getTotal(){
  my (@array) = @_;
  my $total = 0;
  foreach my $hash (@array) {
    my @count =  split (/,/,$hash);
    $total += $count[0];
  }
  return $total;
}

