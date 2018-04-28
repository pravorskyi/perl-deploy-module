#!/usr/bin/env perl
use strict;
use warnings;

sub deploy($)
{
	my $path = shift;
	print "Deploying \"".$path."\"...";
}

sub undeploy($)
{
	my $path = shift;
	print "Undeployin \"".$path."\"...";
}

sub main
{
	deploy("/usr/share/tomcat8-docs/docs/appdev/sample/sample.war");
	return 0;
}

main();
