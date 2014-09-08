[![Build Status](https://travis-ci.org/researchpanelasia/p5-SOPx-Auth-V1_1.svg?branch=master)](https://travis-ci.org/researchpanelasia/p5-SOPx-Auth-V1_1)

# NAME

SOPx::Auth::V1\_1 - SOP v1.1 authentication module

# SYNOPSIS

    use SOPx::Auth::V1_1;

    my $req = SOPx::Auth::V1_1->create_request(
        GET => 'http://host/v1_1/api/endpoint' => {
            hoge => 'hoge',
            fuga => 'fuga',
        },
    );
    #=> A HTTP::Request object

In your HTML,

    <script type="text/javascript" src="<: $req.uri.as_string :>"></script>

# DESCRIPTION

SOPx::Auth::V1\_1 is a module to support:

+ making a valid request to SOP
+ verifying a request from SOP
