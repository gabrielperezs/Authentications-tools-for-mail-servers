#!/usr/bin/perl

use Data::Dumper;
use Net::POP3;
use Net::POP3_auth;
use Net::POP3::SSLWrapper;
use Config::File qw(read_config_file);

my $config = read_config_file($ARGV[0]);

my $pop;
my @auth;

if ($config->{auth} =~ /auto/i) {
    $pop = Net::POP3_auth->new($config->{server});
    @auth = $pop->auth_types;
}
else {
    @auth = split(/\s+/,$config->{authtype});
}

foreach my $type (@auth) {

    print $type. ' -> '.$config->{server}.' ('.$config->{username}.'): ';

    if ($type =~/plain/i) {
        $pop = Net::POP3->new($config->{server});
        if( $pop->login($config->{username}, $config->{password}) > 0) {
            print "OK - ";
        }
        else {
            print "ERROR - ";
        }
        $pop->quit;

        pop3s {
            $pop = Net::POP3->new($config->{server}, Port => 995);
            if( $pop->login($config->{username}, $config->{password}) > 0) {
                print "SSL OK\n";
            }
            else {
                print "SSL ERROR\n";
            }
            $pop->quit;
        }
    }
    else {
        $pop = Net::POP3_auth->new($config->{server});

        if( $pop->auth($type, $config->{username}, $config->{password}) > 0) {
            print "OK - ";
        }
        else {
            print "ERROR - ";
        }

        $pop->quit;
        pop3s {
            $pop = Net::POP3_auth->new($config->{server}, Port => 995);
            
            if( $pop->auth($type, $config->{username}, $config->{password}) > 0) {
                print "SSL OK\n";
            }
            else {
                print "SSL ERROR\n";
            }
            
            $pop->quit;
        }
    }
}

exit;
