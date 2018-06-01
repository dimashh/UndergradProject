#!/usr/bin/perl
use strict;
use IO::Socket;
$|=1;

# Connect to SwisTrack: replace "localhost" by the name or IP address of the computer SwisTrack is running on
my $swistrack = IO::Socket::INET->new(
	Proto    => 'tcp',
	PeerAddr => 'localhost',
	PeerPort => 3000,
	) or die 'Cannot connect to SwisTrack!';

# Set running = true
print 'Starting SwisTrack ...', "\n";
print $swistrack '$RUN,true', "\n";

# Read the output of SwisTrack
print 'Waiting for the first blob ...', "\n";
while (my $line=<$swistrack>) {
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
