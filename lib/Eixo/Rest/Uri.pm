package Eixo::Rest::Uri;

use strict;
use Eixo::Base::Clase;

my $REG_PARAM = qr/\:(\w+)/;

has(

    args=>undef,

    uri_mask=>undef,

);

sub build{
    my ($self) = @_;

    my $mask = $self->uri_mask;

    while($mask =~ /$REG_PARAM/g){

        my ($param_name, $param_value) = (

            $1, 

            $self->args->{$1}

        );

        $mask =~ s/\:$param_name/$param_value/g;

    }

    return $mask;
}

1;
