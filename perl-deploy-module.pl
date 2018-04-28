#!/usr/bin/env perl
use strict;
use warnings;
use Config::Simple;
use Getopt::Long;
use Switch;

use AbstractServer;

sub main
{
	my $action = "";
	my $configfile = "";
	my %config = ( "action" => \$action,
				   "config" => \$configfile );

	GetOptions( \%config,
				"action=s",
				"application=s",
				"config=s",
				"port=i" )
		or die "Error in command line arguments.\n";

	Config::Simple->import_from($configfile, \%config)
		or die Config::Simple->error();

	my $server = AbstractServer->create("Tomcat8", \%config);

	switch( $action )
	{
		case "deploy" { $server->deploy() }
		case "undeploy" { $server->undeploy () }
		else { die "Invalid option \"action\"." }
	}
}

main();
