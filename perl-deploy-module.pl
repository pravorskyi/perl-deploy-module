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
				   "config" => \$configfile,
				   "hostname" => "localhost",
				   "port"	=> 8080 );

	GetOptions( \%config,
				"action=s",
				"application=s",
				"config=s",
				"port=i" )
		or die "Error in command line arguments.\n";

	if($configfile)
	{
		Config::Simple->import_from($configfile, \%config)
			or die Config::Simple->error();
	}

	my $server = AbstractServer->create("Tomcat8", \%config);

	switch( $action )
	{
		case "deploy"          { $server->deploy() }
		case "undeploy"        { $server->undeploy () }
		case "start"           { $server->start() }
		case "stop"            { $server->stop() }
		case "check-alive"     { $server->check_alive() }
		case "check-available" { $server->check_available() }
		else { die "Invalid option \"action\"." }
	}
}

main();
