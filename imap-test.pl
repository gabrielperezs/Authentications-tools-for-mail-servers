#!/usr/bin/perl


use Data::Dumper;
use Mail::IMAPClient;
use Config::File qw(read_config_file);

use strict;

my $config = read_config_file($ARGV[0]);
my $imap;
my @authlist;

if ($config->{auth} =~ /auto/i) {
    $imap = Mail::IMAPClient->new( Server => $config->{server} );
    my @authauto =  $imap->capability;
    foreach my $auth (@authlist) {
        if ($auth =~/^AUTH=(.*)/ig) {
            push @authlist, $1;
        }
    }
}
else {
    @authlist = split(/\s+/,$config->{authtype});
}

foreach my $authmech (@authlist) {
    print $authmech. ' -> '.$config->{server}.' ('.$config->{username}.'): ';

    eval {
        my $imap = Mail::IMAPClient->new(
            Server   => $config->{server},
            User     => $config->{username},
            Password => $config->{password},
            Authmechanism  => $authmech,
            debug => 0
        );

        if ($imap eq undef) {
            print "ERROR - ";
        }
        else {
            print "OK - ";
            $imap->disconnect;
        }
    };

    if ($@) {
        print "ERROR\n";
    }

    eval {
        my $imap = Mail::IMAPClient->new(
            Server   => $config->{server},
            User     => $config->{username},
            Password => $config->{password},
            Authmechanism  => $authmech,
            Ssl => 1,
            debug => 0
        );

        if ($imap eq undef) {
            print "SSL ERROR\n";
        }
        else {
            print "SSL OK\n";
            $imap->disconnect;
        }
    };

    if ($@) {
        print "ERROR\n";
    }
}

exit;
