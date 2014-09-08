use strict;
use warnings;
use Data::Dumper;
use JSON::XS qw(decode_json);
use SOPx::Auth::V1_1::Util;
use Test::More;
use Test::Pretty;
use URI;

subtest 'Test GET reqeust' => sub {
    my $uri = URI->new('http://hoge/get');
    my $params = {
        hoge => 'hoge',
        sig => 'sig',
        time => '1234',
    };

    my $req = SOPx::Auth::V1_1::Util->create_get_request(
        $uri => $params,
    );

    isa_ok $req, 'HTTP::Request';
    isa_ok $req->uri, 'URI';
    is $req->uri->host, 'hoge';
    is $req->uri->path, '/get';

    {
        my %params = $req->uri->query_form;

        is_deeply \%params, {
            hoge => 'hoge',
            sig => 'sig',
            time => '1234',
        };
    };
};

subtest 'Test POST request' => sub {
    my $uri = URI->new('http://hoge/post');
    my $params = {
        hoge => 'hoge',
        sig => 'sig',
        time => '1234',
    };

    my $req = SOPx::Auth::V1_1::Util->create_post_request(
        $uri => $params,
    );

    isa_ok $req, 'HTTP::Request';
    isa_ok $req->uri, 'URI';
    is $req->uri->as_string, 'http://hoge/post';

    {
        my $uri = URI->new('/?'. $req->content);
        my %q = $uri->query_form;

        is_deeply \%q, {
            hoge => 'hoge',
            sig => 'sig',
            time => '1234',
        };
    };
};

subtest 'Test POST JSON request' => sub {
    my $uri = URI->new('http://hoge/post_json');
    my $params = {
        hoge => 'hoge',
        sig => 'sig',
        time => '1234',
    };

    my $req = SOPx::Auth::V1_1::Util->create_post_json_request(
        $uri => $params,
    );

    isa_ok $req, 'HTTP::Request';
    isa_ok $req->uri, 'URI';
    is $req->uri->as_string, 'http://hoge/post_json';
    is $req->headers->header('content-type'), 'application/json';
    is $req->headers->header('x-sop-sig'), 'sig';

    {
        my $data = decode_json($req->content);

        is_deeply $data, {
            hoge => 'hoge',
            time => '1234',
        };
    };
};

done_testing;
