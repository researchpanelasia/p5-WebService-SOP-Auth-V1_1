# NAME

SOPx::Auth::V1\_1 - SOP version 1.1 authentication module

# SYNOPSIS

    use SOPx::Auth::V1_1;

When making a GET request to API:

    my $auth = SOPx::Auth::V1_1->new({
        app_id => '1',
        app_secret => 'hogehoge',
    });

    my $req = $auth->create_request(
        GET => 'https://<API_HOST>/path/to/endpoint' => {
            hoge => 'hoge',
            fuga => 'fuga',
        },
    );
    #=> HTTP::Request object

    my $res = LWP::UserAgent->new->request($req);
    #=> HTTP::Response object

When embedding JavaScript URL in page:

    <script src="<: $req.uri.as_string :>"></script>

# DESCRIPTION

SOPx::Auth::V1\_1 is an authentication for SOP version 1.1.

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

## create\_request( $type, $uri, $params )

Creates a new [HTTP::Request](https://metacpan.org/pod/HTTP::Request) object for API request.

## verify\_signature( $sig, $params )

Verifies if request signature is valid.

# LICENSE

Copyright (C) yowcowvg.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

yowcowvg <yoko\_ohyama \[ at \] voyagegroup.com>
