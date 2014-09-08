package SOPx::Auth::V1_1::Util;
use strict;
use warnings;
use HTTP::Request::Common qw(GET POST);
use JSON::XS qw(encode_json);

sub create_get_request {
    my ($class, $uri, $params) = @_;
    $params ||= +{ };
    $uri->query_form($params);
    GET $uri;
}

sub create_post_request {
    my ($class, $uri, $params) = @_;
    $params ||= +{ };
    POST $uri => $params;
}

sub create_post_json_request {
    my ($class, $uri, $params) = @_;
    $params ||= +{ };
    my $sig = delete $params->{sig};
    my $req = POST $uri, Content => encode_json($params);
    $req->headers->header('content-type' => 'application/json');
    $req->headers->header('x-sop-sig' => $sig);
    $req;
}

1;
