#!/usr/bin/perl

use LWP::Simple;                # From CPAN
use JSON qw( decode_json );     # From CPAN
use Data::Dumper;               # Perl core module
use strict;                     # Good practice
use warnings;                   # Good practice

my $url = "https://www.coinotron.com/coinotron/AccountServlet?action=api&api_key=<API KEY>";

my $json = get( $url );
die "Could not get $url!" unless defined $json;

my $decoded_json = decode_json( $json );

#print Dumper $decoded_json;

# Access the shares like this:
#print "Hashrate: ",
print $decoded_json->{'workers'}{'<worker name>'}{'hashrate'};
