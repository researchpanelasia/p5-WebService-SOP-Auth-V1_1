package SOPx::Auth::V1_1::Request::POST_JSON;
use strict;
use warnings;
use Carp ();
use JSON::XS qw(encode_json);
use HTTP::Request::Common qw(POST);
use SOPx::Auth::V1_1::Util qw(create_signature);

sub create_request {
    my ($class, $uri, $params, $app_secret) = @_;

    Carp::croak('Missing required parameter: time')
            if not $params->{time};
    Carp::croak('Missing app_secret') if not $app_secret;

    my $content = encode_json($params);
    my $sig = create_signature($content, $app_secret);

    my $req = POST $uri, Content => $content;
    $req->headers->header('content-type' => 'application/json');
    $req->headers->header('x-sop-sig' => $sig);
    $req;
}

1;
