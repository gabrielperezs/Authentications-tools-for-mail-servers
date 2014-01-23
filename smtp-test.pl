#!/usr/bin/perl


use Data::Dumper;
use Net::SMTP;
use Net::SMTP_auth;
use Config::File qw(read_config_file);

my $config = read_config_file($ARGV[0]);

my $smtp;
my @auth;

if ($config->{auth} =~ /auto/i) {
    $smtp = Net::SMTP_auth->new( $config->{server} );
    @auth = $smtp->auth_types;
}               
else {                  
    @auth = split(/\s+/,$config->{authtype});                   
}

foreach my $type (@auth) {

    print $type. ' -> '.$config->{server}.' ('.$config->{username}.'): ';

    if ($type =~ /plain/i) {
        $smtp = Net::SMTP->new( $config->{server} );

        if( $smtp->auth($config->{username}, $config->{password}) > 0) {
            print "OK\n";
        }
        else {
            print "ERROR\n";
        }

        $smtp->quit;

    }
    else {

        $smtp = Net::SMTP_auth->new( $config->{server} );

        if( $smtp->auth($type, $config->{username}, $config->{password}) > 0) {
            print "OK\n";
        }
        else {
            print "ERROR\n";
        }

        $smtp->quit;
    }
}

exit;
