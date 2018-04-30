package PDM_Server::Tomcat8;

use strict;
use warnings;
use File::Slurp;
use HTTP::Headers;
use LWP::UserAgent;

our $Config = ();	# hash ref with config options
our $server = "";	# server url

sub new
{
	my $type = shift;
	our $Config = shift;
	# Check params
	die "Missing hostname or port" unless $Config->{"hostname"} and $Config->{"port"};

	our $server = "http://".$Config->{"hostname"}.":".$Config->{"port"};

	my $self = bless( {}, $type );
	return $self;
}

# Deploy application via Apache Tomcat Manager
# https://tomcat.apache.org/tomcat-8.0-doc/manager-howto.html#Deploy_A_New_Application_Archive_(WAR)_Remotely
sub deploy
{
	our $Config;
	our $server;
	print "Deploying \"".$Config->{"application"}."\"...\n";

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new( 'PUT' );
	$req->url( $server."/manager/text/deploy?path=/".$Config->{"path"} );
	$req->header( Content_Type => "form-data" );

	# Large files should be read by chunks.
	my $data_file = read_file( $Config->{"application"}, { binmode => ':raw' } );
	$req->content( $data_file );

	$req->authorization_basic( $Config->{"user"} , $Config->{"password"} );
	#print $req->dump();

	my $resp = $ua->request( $req );
	if ( $resp->is_success ){
		print $resp->content() . "\n";
		die unless ($resp->content() !~ /^FAIL/);
	}
	else{
		die $resp->status_line;
	}
}

# Undeploy application via Apache Tomcat Manager
# https://tomcat.apache.org/tomcat-8.0-doc/manager-howto.html#Undeploy_an_Existing_Application
sub undeploy
{
	our $Config;
	our $server;
	print "Undeploying \"".$Config->{"path"}."\"...\n";

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new;
	$req->method( 'GET' );
	$req->url( $server."/manager/text/undeploy?path=/".$Config->{"path"} );
	$req->authorization_basic( $Config->{"user"} , $Config->{"password"} );

	my $resp = $ua->request( $req );
	if ( $resp->is_success ){
		print $resp->content() . "\n";
		die unless ($resp->content() !~ /^FAIL/);
	}
	else{
		die $resp->status_line;
	}
}

# Start application via Apache Tomcat Manager
# https://tomcat.apache.org/tomcat-8.0-doc/manager-howto.html#Start_an_Existing_Application
sub start
{
	our $Config;
	our $server;
	print "Starting \"".$Config->{"path"}."\"...\n";

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new;
	$req->method( 'GET' );
	$req->url( $server."/manager/text/start?path=/".$Config->{"path"} );
	$req->authorization_basic( $Config->{"user"} , $Config->{"password"} );

	my $resp = $ua->request( $req );
	if ( $resp->is_success ){
		print $resp->content() . "\n";
	}
	else{
		die $resp->status_line;
	}
}

# Stop application via Apache Tomcat Manager
# https://tomcat.apache.org/tomcat-8.0-doc/manager-howto.html#Stop_an_Existing_Application
sub stop
{
	our $Config;
	our $server;
	print "Stopping \"".$Config->{"path"}."\"...\n";

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new;
	$req->method( 'GET' );
	$req->url( $server."/manager/text/stop?path=/".$Config->{"path"} );
	$req->authorization_basic( $Config->{"user"} , $Config->{"password"} );

	my $resp = $ua->request( $req );
	if ( $resp->is_success ){
		print $resp->content() . "\n";
	}
	else{
		die $resp->status_line;
	}
}

# Check if application is alive via downloading application's root '<application>/'
sub check_alive
{
	our $Config;
	our $server;
	print "Check if application \"".$Config->{"path"}."\" is alive...\n";

	my $ua = LWP::UserAgent->new;
	my $resp = $ua->get( $server."/".$Config->{"path"}."/" );
	if ( $resp->is_success ){
		print "OK. Response code: ".$resp->code."\n";
	}
	else{
		die $resp->status_line;
	}
}

# Check if application is available via Apache Tomcat Manager
# https://tomcat.apache.org/tomcat-8.0-doc/manager-howto.html#List_Currently_Deployed_Applications
# Check if application in list
sub check_available
{
	our $Config;
	our $server;
	print "Check if application \"".$Config->{"path"}."\" is available...\n";

	my $ua = LWP::UserAgent->new;
	my $req = HTTP::Request->new;
	$req->method( 'GET' );
	$req->url( $server."/manager/text/list" );
	$req->authorization_basic( $Config->{"user"} , $Config->{"password"} );

	my $resp = $ua->request( $req );
	if ( $resp->is_success ){
		my $path = $Config->{"path"};
		my @lines = split( "\n", $resp->content() );
		my @matches = grep /^\/$path/, @lines;
		if( @matches )
		{
			print "OK. Application is available\n";
			# print @matches, "\n";
		} else {
			print "OK. Application is NOT available\n";
		}
	}
	else{
		die $resp->status_line;
	}
}

1;
