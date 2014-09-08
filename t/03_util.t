use strict;
use warnings;
use JSON::XS qw(decode_json);
use SOPx::Auth::V1_1::Util;
use Test::Exception;
use Test::Mock::Guard;
use Test::More;
use Test::Pretty;
use URI;

subtest 'Test create_string_from_hashref' => sub {
    is_deeply SOPx::Auth::V1_1::Util::create_string_from_hashref({
        zzz => 'zzz',
        yyy => 'yyy',
        xxx => 'xxx',
    }) => 'xxx=xxx&yyy=yyy&zzz=zzz';

    throws_ok {
        SOPx::Auth::V1_1::Util::create_string_from_hashref({
            zzz => { aaa => 'aaa', },
        })
    } qr|not allowed|;
};

subtest 'Test create_string_from_arrayref' => sub {
    is_deeply SOPx::Auth::V1_1::Util::create_string_from_arrayref([
        qw( zzz yyy xxx )
    ]) => 'zzz&yyy&xxx';

    throws_ok {
        SOPx::Auth::V1_1::Util::create_string_from_arrayref([
            { hoge => 'fuga' },
        ])
    } qr|not allowed|;
};

subtest 'Test create_signature' => sub {
    my $res = SOPx::Auth::V1_1::Util::create_signature({
        ccc => 'ccc',
        bbb => 'bbb',
        aaa => 'aaa',
    }, 'hogehoge');

    is $res, '2fbfe87e54cc53036463633ef29beeaa4d740e435af586798917826d9e525112';
};

subtest 'Test GET reqeust' => sub {
    my $uri = URI->new('http://hoge/get');
    my $params = {
        aaa => 'aaa',
        bbb => 'bbb',
        time => '1234',
    };

    my $req = SOPx::Auth::V1_1::Util::create_get_request(
        $uri => $params, 'hogehoge',
    );

    isa_ok $req, 'HTTP::Request';
    isa_ok $req->uri, 'URI';
    is $req->uri->host, 'hoge';
    is $req->uri->path, '/get';

    {
        my %params = $req->uri->query_form;

        is_deeply \%params, {
            aaa => 'aaa',
            bbb => 'bbb',
            sig => '40499603a4a5e8d4139817e415f637a180a7c18c1a2ab03aa5b296d7756818f6',
            time => '1234',
        };
    };
};

subtest 'Test POST request' => sub {
    my $uri = URI->new('http://hoge/post');
    my $params = {
        aaa => 'aaa',
        bbb => 'bbb',
        time => '1234',
    };

    my $req = SOPx::Auth::V1_1::Util::create_post_request(
        $uri => $params, 'hogehoge',
    );

    isa_ok $req, 'HTTP::Request';
    isa_ok $req->uri, 'URI';
    is $req->uri->as_string, 'http://hoge/post';

    {
        my $uri = URI->new('/?'. $req->content);
        my %q = $uri->query_form;

        is_deeply \%q, {
            aaa => 'aaa',
            bbb => 'bbb',
            sig => '40499603a4a5e8d4139817e415f637a180a7c18c1a2ab03aa5b296d7756818f6',
            time => '1234',
        };
    };
};

subtest 'Test POST JSON request' => sub {
    my $guard = mock_guard(
        'SOPx::Auth::V1_1::Util' => {
            create_signature => sub {
                my ($content, $app_secret) = @_;
                my $data = decode_json($content);

                is_deeply $data, {
                    aaa => 'aaa',
                    bbb => 'bbb',
                    time => '1234',
                };
                is $app_secret, 'hogehoge';

                'hoge-signature';
            },
        },
    );

    my $uri = URI->new('http://hoge/post_json');
    my $params = {
        aaa => 'aaa',
        bbb => 'bbb',
        time => '1234',
    };

    my $req = SOPx::Auth::V1_1::Util::create_post_json_request(
        $uri => $params, 'hogehoge',
    );

    isa_ok $req, 'HTTP::Request';
    isa_ok $req->uri, 'URI';
    is $req->uri->as_string, 'http://hoge/post_json';
    is $req->headers->header('content-type'), 'application/json';
    is $req->headers->header('x-sop-sig'), 'hoge-signature';

    {
        my $data = decode_json($req->content);

        is_deeply $data, {
            aaa => 'aaa',
            bbb => 'bbb',
            time => '1234',
        };
    };
};

done_testing;
