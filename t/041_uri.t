use strict;
use Eixo::Rest::Uri;

use Test::More;

my %args = (

    name=>"foo",
    organization=>"university"
);

my $uri = Eixo::Rest::Uri->new(

    args=>\%args,

    uri_mask=>"/organizations/:organization/users/:name"

)->build;

is($uri, "/organizations/university/users/foo", "Uri correctly formed");



done_testing();
