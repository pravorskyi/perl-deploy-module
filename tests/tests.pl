#!/usr/bin/env perl
use strict;
use warnings;
use Test::Mock::LWP;
use Test::More;
use Test::Exception;

use AbstractServer;

sub Test_deploy_success
{
	our %config;
	my $server = AbstractServer->create("Tomcat8", \%config);

	$Mock_response->mock( content => sub { 'OK - Deployed application at context path /...' } );
	$Mock_response->mock( code => sub { 200 } );
	$Mock_response->mock( is_success => sub { 1 } );
	$Mock_response->mock( status_line => sub { "200 OK" } );

	$server->deploy();
}

sub Test_deploy_failed
{
	our %config;
	my $server = AbstractServer->create("Tomcat8", \%config);

	$Mock_response->mock( content => sub { 'FAIL - Application already exists at path /...' } );
	$Mock_response->mock( code => sub { 404 } );
	$Mock_response->mock( is_success => sub { 0 } );
	$Mock_response->mock( status_line => sub { "404 Not found" } );

	$server->deploy();
}

our %config = ( application => "/usr/share/doc/tomcat8-docs/docs/appdev/sample/sample.war",
			   hostname => "localhost",
			   path => "testapp",
			   port => 777 );

ok Test_deploy_success, "Deploy success";
print "\n";
dies_ok sub { Test_deploy_failed }, "Deploy failed";

done_testing();
