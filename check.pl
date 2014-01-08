#!/usr/bin/perl

use strict;                     # Good practice
use warnings;                   # Good practice

my $HSCRIPT="/home/jars99/mine/hashrate.pl";
my $HSTORE="/home/jars99/hashrate.txt";
my $WAIT="/home/jars99/wait.txt";
my $WARN="/home/jars99/warn.txt";
my $LOG="/var/log/hash_check.log";
my $SENDEMAIL="/home/jars99/mine/send_email.sh";
my $QUIT="/home/jars99/mine/quit";

#Get the current date
my $date = `date`;
chomp($date);
print "Date: $date\n";

#Get the current wait status
my $wait = `cat $WAIT`;
chomp($wait);
print "Wait: $wait\n";

my $warn = `cat $WARN`;
chomp($warn);
print "Warn: $warn\n";

#Run the hashrate check script. 
print "Getting Hashrate\n";
my $rate = `$HSCRIPT`;
print "Rate: $rate\n";

#Update the hashrate log
`echo "$rate, $date" >> $HSTORE`;

#Check to see if we're waiting for a reboot to finish - 0 for no, 1 for yes
if ( $wait ){
  #We'll know the reboot finished once we're hasing again.  
  if ($rate > 0){
    #We're hashing, so reset the wait flag
    print "Hashing again, reseting Wait Flag\n";
    `echo "$date Hashing started again.  Wait Flag cleared, hashing at $rate" >> $LOG`;
    `echo "0" > $WAIT`;
    #Send notification Email
    `$SENDEMAIL '<miner name>' 'Hashing at $rate' >> $LOG`;
  } else {
    #Still waiting for the reboot to finish
    print "Waiting for reboot\n";
    `echo "$date Waiting for reboot to finish" >> $LOG`;
 }
} else { #We're not waiting for a reboot - Check the hashrate, and see if we're hashing
  if ( $rate == 0 ) {
    #We've stopping hashing! Check to see if we're in warning mode
    if ( $warn ) {
      print "Rate 0, Warn 1.  Rebooting\n";
      `echo "$date 2nd sequential 0 Hashrate: Hashing stopped.  Rebooting" >> $LOG`;
      `echo "1" > $WAIT`;
      `$SENDEMAIL '<miner name>' 'Miner Down' >> $LOG`;
      `$QUIT`;
      #wait 5 sec to give the miner a chance to quit
      `sleep 5 >> $LOG`;
      `/sbin/reboot 2>&1 >> $LOG`;
    } else {
      #Set the warning flag;
      print "Warning: One instance of 0 hashes detected.\n";
      `echo "$date 1st 0 Hashrate detected.  Setting Warning Flag." >> $LOG`;
      `echo "1" > $WARN`;
    }
  } else {
    #Happily hashing along.  Don't touch anything!
    `echo "$date Hashing at $rate" >> $LOG`;
    print "Hashing at $rate\n";
    #Still hashing - If necessary, reset warning state
    if ( $wait ) {
      `echo "0" > $WAIT`;
    }
    if ( $warn ) {
      `echo "0" > $WARN`;
    }
  }
}
	
