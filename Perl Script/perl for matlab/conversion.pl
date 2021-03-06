#!/usr/bin/perl
use strict;
$|=1;
$input = $ARGV[0];

# Read the output of SwisTrack
print 'Waiting for the first blob ...', "\n";
while (my $line=<$input>) {
	if ($line =~ /\$STEP_START/) {
		# This is the beginning of a frame
		print 'We\'ve got a new frame ...', "\n";
	} elsif ($line =~ /\$FRAMENUMBER,([\d-]*)/) {
		# This is the frame number (first result of regular expression)
		print '  Framenumber =', $1, "\n";
	} elsif ($line =~ /\$PARTICLE,([\d-]*),([\d\.-]*),([\d\.-]*),([\d\.-]*)/) {
		# This is a particle
		print '  Particle: ID = ', $1, ', X = ', $2, ', Y = ', $3, ', alpha = ', $4, "\n";

	}
}
