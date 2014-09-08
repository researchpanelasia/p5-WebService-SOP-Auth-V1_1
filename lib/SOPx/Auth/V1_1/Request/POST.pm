package SOPx::Auth::V1_1::Request::POST;
use strict;
use warnings;
use Carp ();
use HTTP::Request::Common qw(POST);
use SOPx::Auth::V1_1::Util qw(create_signature);

sub create_request {
    my ($class, $uri, $params, $app_secret) = @_;

    Carp::croak('Missing required parameter: time')
            if not $params->{time};
    Carp::croak('Missing app_secret') if not $app_secret;

    POST $uri => {
        %$params,
        sig => create_signature($params, $app_secret),
    };
}

1;
