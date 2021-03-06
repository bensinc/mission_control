#!/usr/bin/perl

use Ham::APRS::IS;
use Ham::APRS::FAP qw(parseaprs);
use DBI;

$dsn = "DBI:mysql:database=mission_control_development;host=localhost";

$dbh = DBI->connect($dsn, 'root', '');

# my $is = new Ham::APRS::IS('rotate.aprs.net:10152', 'KC0ZMX', 'appid' => 'BenAPRS 0.1', 'filter' => 'r/41.62217/-93.80767/100');
my $is = new Ham::APRS::IS('rotate.aprs.net:14580', 'KC0ZMX', 'passcode' => 17827, 'appid' => 'BenAPRS 0.1', 'filter' => 'b/KC0ZMX*');

$is->connect('retryuntil' => 3) || die "Failed to connect: $is->{error}";

while (1 == 1) {
	my $l = $is->getline_noncomment();
	next if (!defined $l);
	
	# print "\n--- new packet ---\n";
#	print "$l\n";
	
	my %packetdata;
	my $retval = parseaprs($l, \%packetdata);
	
	if ($retval == 1) {

		# Insert into database

		$path = join($packetdata{digipeaters}, '>');

		$size = @packetdata{digipeaters};

		# print "Digipeaters: ";
		
		# print "\n";
		# foreach $item (@packetdata{digipeaters}) {

		# 		print item{call};
		# 		print "\n";
			
		# }

		print $packetdata{srccallsign};
		print "\n";

		if ($packetdata{srccallsign} eq 'KC0ZMX-11') {
			print "Logging KC0ZMX-11\n";

			$dbh->do('INSERT INTO packets 
				(mission_id, `from`,`to`,`kind`,`raw`, `lat`, `lon`, altitude, course, speed, symbol, symbol_table, `comment`, `object_name`, path, created_at) VALUES 
				(1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())', undef, 
				$packetdata{srccallsign}, $packetdata{dstcallsign}, $packetdata{type}, $l,
				$packetdata{latitude}, $packetdata{longitude}, $packetdata{altitude}, $packetdata{course}, $packetdata{speed},
				$packetdata{symbolcode}, $packetdata{symboltable},
				$packetdata{comment},
				$packetdata{objectname},
				$path
			);

		}

		if ($packetdata{srccallsign} eq 'KC0ZMX-7') {
			print "Logging KC0ZMX-7\n";
			$dbh->do('INSERT INTO chases 
				(mission_id, `lat`, `lon`, created_at) VALUES 
				(1, ?, ?, NOW())', undef, 				
				$packetdata{latitude}, $packetdata{longitude}
			);

		}


		# print $packetdata{srccallsign};
		# print $packetdata{dstcallsign};
		# print $packetdata{type};
		# print $l;

		while (my ($key, $value) = each(%packetdata)) {
			# print "$key: $value\n";
		}
	} else {
		warn "Parsing failed: $packetdata{resultmsg} ($packetdata{resultcode})\n";
	}
}

$is->disconnect() || die "Failed to disconnect: $is->{error}";



# +--------------+--------------+------+-----+---------+----------------+
# | Field        | Type         | Null | Key | Default | Extra          |
# +--------------+--------------+------+-----+---------+----------------+
# | id           | int(11)      | NO   | PRI | NULL    | auto_increment |
# | date         | datetime     | YES  |     | NULL    |                |
# | from         | varchar(255) | YES  |     | NULL    |                |
# | to           | varchar(255) | YES  |     | NULL    |                |
# | kind         | varchar(255) | YES  |     | NULL    |                |
# | raw          | varchar(255) | YES  |     | NULL    |                |
# | lat          | double       | YES  |     | NULL    |                |
# | lon          | double       | YES  |     | NULL    |                |
# | destination  | varchar(255) | YES  |     | NULL    |                |
# | comment      | varchar(255) | YES  |     | NULL    |                |
# | symbol_table | varchar(255) | YES  |     | NULL    |                |
# | symbil       | varchar(255) | YES  |     | NULL    |                |
# | power        | varchar(255) | YES  |     | NULL    |                |
# | height       | varchar(255) | YES  |     | NULL    |                |
# | gain         | varchar(255) | YES  |     | NULL    |                |
# | temperature  | varchar(255) | YES  |     | NULL    |                |
# | wind_dir     | varchar(255) | YES  |     | NULL    |                |
# | wind_speed   | varchar(255) | YES  |     | NULL    |                |
# | humidity     | varchar(255) | YES  |     | NULL    |                |
# | rain_1hr     | varchar(255) | YES  |     | NULL    |                |
# | rain_12hr    | varchar(255) | YES  |     | NULL    |                |
# | path         | varchar(255) | YES  |     | NULL    |                |
# | telemetry    | varchar(255) | YES  |     | NULL    |                |
# | created_at   | datetime     | NO   |     | NULL    |                |
# | updated_at   | datetime     | NO   |     | NULL    |                |
# +--------------+--------------+------+-----+---------+----------------+
