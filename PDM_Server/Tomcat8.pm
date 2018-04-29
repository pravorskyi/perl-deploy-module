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
	our $server = "http://".$Config->{"hostname"}.":".$Config->{"port"};
	print $server;
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
	}
	else{
		die $resp->status_line;
	}
}

1;
