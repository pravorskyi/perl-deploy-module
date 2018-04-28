#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use Switch;

sub deploy($)
{
	my $path = shift;
	print "Deploying \"".$path."\"...\n";
}

sub undeploy($)
{
	my $path = shift;
	print "Undeploying \"".$path."\"...\n";
}

sub main
{
	my $action = "";
	my $application = "";

	GetOptions( "action=s" => \$action,
				 "application=s" => \$application )
		or die "Error in command line arguments.\n";

	switch( $action )
	{
		case "deploy" { deploy( $application ) }
		case "undeploy" { undeploy ($application ) } 
		else { die "Invalid option \"action\"." }
	}

	return 0;
}

main();
