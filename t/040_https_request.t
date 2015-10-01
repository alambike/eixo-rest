use t::test_base;

use_ok(Eixo::Rest::Client);
use_ok(Eixo::Rest::Api);
use strict;
use warnings;
use IO::Socket::SSL;
use File::Spec;

my @parts = File::Spec->splitpath(__FILE__);

my $basedir = $parts[1];

my $port = 20000+int(rand(10000));
my ($public_cert,$private_cert) = (
    "$basedir/certs/server-cert.pem", 
    "$basedir/certs/server-key.pem"
);

my $ca_file = "$basedir/certs/ca.pem";

&start_server($port, $public_cert, $private_cert, $ca_file);
<STDIN>;

my $a =  Eixo::Rest::Api->new(
    "https://localhost:$port",

    ssl_opts => {
        #SSL_use_cert => 1,
        #SSL_ca_file => $ca_file,
        SSL_cert_file => "$basedir/certs/cert.pem",
        SSL_key_file => "$basedir/certs/key.pem",
        SSL_fingerprint => 'sha1:0B:90:80:66:16:8C:A5:BA:BF:C6:95:F0:BD:A8:0B:F8:E7:C4:AE:93',
    }
);

print Dumper($a->getSearch(
    args => {
        __format => 'RAW',
        __implicit_format => 1
    }
));


done_testing();



sub start_server {
    my ($port, $public_cert, $private_cert, $ca_file) = @_;

    if(my $pid = fork){
        print "Open socket in 127.0.0.1:$port\n";
        # simple server
        my $srv = IO::Socket::SSL->new(
            LocalAddr => "localhost:$port",
            Listen => 10,
            SSL_cert_file => $public_cert,
            SSL_key_file => $private_cert,
            SSL_client_ca_file => $ca_file,
            SSL_ca_file => $ca_file,
            SSL_ca_path => \undef,
        );

        $srv->accept;

        $srv->syswrite("HTTP/1.1 200 OK\r\nHola\r\n\r\n");

        exit(0);
    }
    else{
        sleep(1);
    }

}
