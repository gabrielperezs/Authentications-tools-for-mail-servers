Authentications tools for mail servers
======================================

Perl scripts to test Authentications systems for mail servers. SMTP, IMAP, and POP3. SSL too.

How to use
==========

Create a configuration file with all the datas you whant to test, like:

```
# File name: example.conf
# Account to test
username=test@mydomain.com
password=the_account_password
server=mail.mydomain.com
#auth=auto
auth=manual
authtype=PLAIN LOGIN CRAM-MD5 DIGEST-MD5
```

Then execute some of the scripts:

```
$ perl pop3-test.pl example.conf
```

Perl modules you will need
==========================

[Net::POP3](http://search.cpan.org/~shay/libnet-1.24/Net/POP3.pm)
[Net::POP3_auth](http://search.cpan.org/~apleiner/Net-POP3_auth-0.04/POP3_auth.pm)
[Net::POP3::SSLWrapper](http://search.cpan.org/~tokuhirom/Net-POP3-SSLWrapper-0.06/lib/Net/POP3/SSLWrapper.pm)
[Net::SMTP](http://search.cpan.org/~shay/libnet-1.24/Net/SMTP.pm)
[Net::SMTP_auth](http://search.cpan.org/~apleiner/Net-SMTP_auth-0.08/SMTP_auth.pm)
[Mail::IMAPClient](http://search.cpan.org/~plobbes/Mail-IMAPClient-3.35/lib/Mail/IMAPClient.pod)
[Config::File](http://search.cpan.org/~gwolf/Config-File-1.50/lib/Config/File.pm)


