package WebService::SOP::Auth::V1_1::Request::DELETE;
use strict;
use warnings;
use Carp ();
use HTTP::Request::Common qw(DELETE);
use WebService::SOP::Auth::V1_1::Util qw(create_signature);

sub create_request {
    my ($class, $uri, $params, $app_secret) = @_;

    Carp::croak('Missing required parameter: time') if not $params->{time};
    Carp::croak('Missing app_secret') if not $app_secret;

    $uri->query_form({
        %$params,
        sig => create_signature($params, $app_secret),
    });
    DELETE $uri;
}

1;