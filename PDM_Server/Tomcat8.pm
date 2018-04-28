package PDM_Server::Tomcat8;

use strict;
use warnings;

sub new
{
	my $type = shift;
	my $self = bless( {}, $type );
	return $self;
}

sub deploy($)
{
	my $type = shift;
	my $path = shift;
	print "Deploying \"".$path."\"...\n";
}

sub undeploy($)
{
	my $type = shift;
	my $path = shift;
	print "Undeploying \"".$path."\"...\n";
}

1;
