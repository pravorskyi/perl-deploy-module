#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use Switch;

use AbstractServer;

sub main
{
	my $action = "";
	my $application = "";

	GetOptions( "action=s" => \$action,
				 "application=s" => \$application )
		or die "Error in command line arguments.\n";

	my $server = AbstractServer->create("Tomcat8");

	switch( $action )
	{
		case "deploy" { $server->deploy( $application ) }
		case "undeploy" { $server->undeploy ($application ) } 
		else { die "Invalid option \"action\"." }
	}

	return 0;
}

main();
