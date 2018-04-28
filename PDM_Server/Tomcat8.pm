package PDM_Server::Tomcat8;

use strict;
use warnings;

our $Config = ();

sub new
{
	my $type = shift;
	our $Config = shift;
	my $self = bless( {}, $type );
	return $self;
}

sub deploy
{
	our $Config;
	print "Deploying \"".$Config->{"application"}."\"...\n";
}

sub undeploy
{
	our $Config;
	print "Undeploying \"".$Config->{"application"}."\"...\n";
}

1;
