use strict;
$|=1;
my $input = $ARGV[0];

# Read the output of SwisTrack
for ($input!=0) {
	if ($input =~ /\$PARTICLE,([\d-]*),([\d\.-]*),([\d\.-]*),([\d\.-]*)/) {
		# This is a particle
		print $3, "\n";
		last;
	}
}
