#!/usr/bin/perl

use strict;
use Data::Dumper;
use Ham::APRS::FAP;
use DBI;


my $dsn = "DBI:mysql:database=mission_control_development;host=localhost";

my $dbh = DBI->connect($dsn, 'root', '');

my $aprspacket = 'OH2RDP>BEACON,OH2RDG*,WIDE:!6028.51N/02505.68E#PHG7220/RELAY,WIDE, OH2AP Jarvenpaa';

open FILE, 'raw2.txt';
my $x = 0;



while(<FILE>) {
	$x++;
	my $line = $_;
	if ($x == $ARGV[0]) {
		print $line;
		print "\n";
		my %packetdata;
		my $retval = Ham::APRS::FAP::parseaprs($line, \%packetdata);

		if ($retval == 1) {
			# decoding ok, do something with the data
			print "Parsing succesful:\n";
			# Insert into database

			my $path = join($packetdata{digipeaters}, '>');

			my $size = @packetdata{digipeaters};

			# print "Digipeaters: ";
			
			# print "\n";
			# foreach $item (@packetdata{digipeaters}) {

			# 		print item{call};
			# 		print "\n";
				
			# }

			$dbh->do('INSERT INTO packets 
				(mission_id, `from`,`to`,`kind`,`raw`, `lat`, `lon`, altitude, course, speed, symbol, symbol_table, `comment`, `object_name`, path, created_at) VALUES 
				(1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())', undef, 
				$packetdata{srccallsign}, $packetdata{dstcallsign}, $packetdata{type}, $line,
				$packetdata{latitude}, $packetdata{longitude}, $packetdata{altitude}, $packetdata{course}, $packetdata{speed},
				$packetdata{symbolcode}, $packetdata{symboltable},
				$packetdata{comment},
				$packetdata{objectname},
				$path
			);

			while (my ($key, $value) = each(%packetdata)) {
				# print "$key: $value\n";
			}			

		} else {
			warn "Parsing failed: $packetdata{resultmsg} ($packetdata{resultcode})\n";
		}

		die "Finished"
	}


}




