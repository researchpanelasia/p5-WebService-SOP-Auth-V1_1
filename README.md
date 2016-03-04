[![Build Status](https://travis-ci.org/researchpanelasia/p5-WebService-SOP-Auth-V1_1.svg?branch=master)](https://travis-ci.org/researchpanelasia/p5-WebService-SOP-Auth-V1_1)
# NAME

WebService::SOP::Auth::V1\_1 - SOP version 1.1 authentication module

# SYNOPSIS

    use WebService::SOP::Auth::V1_1;

To create an instance:

    my $auth = WebService::SOP::Auth::V1_1->new({
        app_id => '1',
        app_secret => 'hogehoge',
    });

When making a GET request to API:

    my $req = $auth->create_request(
        GET => 'https://<API_HOST>/path/to/endpoint' => {
            hoge => 'hoge',
            fuga => 'fuga',
        },
    );

    my $res = LWP::UserAgent->new->request($req);

When making a POST request with JSON data to API:

    my $req = $auth->create_request(
        POST_JSON => 'http://<API_HOST>/path/to/endpoint' => {
            hoge => 'hoge',
            fuga => 'fuga',
        },
    );

    my $res = LWP::UserAgent->new->request($req);

When embedding JavaScript URL in page:

    <script src="<: $req.uri.as_string :>"></script>

# DESCRIPTION

WebService::SOP::Auth::V1\_1 is an authentication module
for [SOP](http://console.partners.surveyon.com/) version 1.1
by [Research Panel Asia, Inc](http://www.researchpanelasia.com/).

# METHODS

## new( \\%options )

Creates a new instance.

Possible options:

- `app_id`

    (Required) Your `app_id`.

- `app_secret`

    (Required) Your `app_secret`.

- `time`

    (Optional) POSIX time.

## app\_id

Gets `app_id` configured to instance.

## app\_secret

Gets `app_secret` configured to instance.

## time

Gets `time` configured to instance.

## create\_request( $type, $uri, $params )

Creates a new [HTTP::Request](https://metacpan.org/pod/HTTP::Request) object for API request.

_$type_ can be one of followings:

- `GET`

    For HTTP GET request to SOP endpoint with signature in query string as parameter
    **sig**.

- `POST`

    For HTTP POST request to SOP endpoint with signature in query string as
    parameter **sig** of request content type `application/x-www-form-urlencoded`.

- `POST_JSON`

    For HTTP POST request to SOP endpoint with signature as request header
    `X-Sop-Sig` of request content type `application/json`.

## verify\_signature( $sig, $params )

Verifies if request signature is valid.

# SEE ALSO

[WebService::SOP::Auth::V1\_1::Request::GET](https://metacpan.org/pod/WebService::SOP::Auth::V1_1::Request::GET),
[WebService::SOP::Auth::V1\_1::Request::POST](https://metacpan.org/pod/WebService::SOP::Auth::V1_1::Request::POST),
[WebService::SOP::Auth::V1\_1::Request::POST\_JSON](https://metacpan.org/pod/WebService::SOP::Auth::V1_1::Request::POST_JSON),
[WebService::SOP::Auth::V1\_1::Util](https://metacpan.org/pod/WebService::SOP::Auth::V1_1::Util)

Research Panel Asia, Inc. website [http://www.researchpanelasia.com/](http://www.researchpanelasia.com/)

# LICENSE

Copyright (C) dataSpring, Inc.
Copyright (C) Research Panel Asia, Inc.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

yowcow &lt;yoko.oyama \[ at \] d8aspring.com>
