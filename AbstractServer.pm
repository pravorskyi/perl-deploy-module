package AbstractServer;

use strict;
use warnings;

sub create
{
	my $class = shift;
	my $requested_type = shift;

	my $location = "PDM_Server/$requested_type.pm";
	$class = "PDM_Server::$requested_type";

	require $location;
	return $class->new(@_);
}

1;
