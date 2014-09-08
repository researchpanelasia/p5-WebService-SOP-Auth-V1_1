package SOPx::Auth::V1_1::Util;
use strict;
use warnings;
use Carp ();
use Digest::SHA qw(hmac_sha256_hex);
use HTTP::Request::Common qw(GET POST);
use JSON::XS qw(encode_json);

sub create_signature {
    my ($params, $app_secret) = @_;
    my $data_string
            = ref($params) eq 'HASH'  ? create_string_from_hashref($params)
            : ref($params) eq 'ARRAY' ? create_string_from_arrayref($params)
            : !ref($params)           ? $params
            : do { Carp::croak("create_signature does not handle type: ". ref($params)) };
    hmac_sha256_hex($data_string, $app_secret);
}

sub create_string_from_hashref {
    my $params = shift;
    join(
        '&',
        map {
            Carp::croak("Structured data not allowed") if ref $params->{$_};
            $_. '='. ($params->{$_} || '');
        } sort { $a cmp $b } keys %$params
    );
}

sub create_string_from_arrayref {
    my $params = shift;
    join(
        '&',
        map {
            Carp::croak("Structured data not allowed") if ref $_;
            $_;
        } @$params
    );
}

sub create_get_request {
    my ($uri, $params, $app_secret) = @_;

    Carp::croak('Missing required parameter: time')
            if not $params->{time};

    $uri->query_form({
        %$params,
        sig => create_signature($params, $app_secret),
    });
    GET $uri;
}

sub create_post_request {
    my ($uri, $params, $app_secret) = @_;

    Carp::croak('Missing required parameter: time')
            if not $params->{time};

    POST $uri => {
        %$params,
        sig => create_signature($params, $app_secret),
    };
}

sub create_post_json_request {
    my ($uri, $params, $app_secret) = @_;

    Carp::croak('Missing required parameter: time')
            if not $params->{time};

    my $content = encode_json($params);
    my $sig = create_signature($content, $app_secret);

    my $req = POST $uri, Content => $content;
    $req->headers->header('content-type' => 'application/json');
    $req->headers->header('x-sop-sig' => $sig);
    $req;
}

1;
