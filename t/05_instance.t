use strict;
use warnings;
use Test::Exception;
use Test::Mock::Guard;
use Test::More;
use Test::Pretty;
use SOPx::Auth::V1_1;

my $class = 'SOPx::Auth::V1_1';

subtest 'Test new w/o required params' => sub {
    throws_ok { $class->new } qr|Missing required parameter|;
    throws_ok { $class->new({ app_id => '1' }) } qr|Missing required parameter|;
    throws_ok { $class->new({ app_secret => 'hoge' }) } qr|Missing required parameter|;
};

subtest 'Test new w/ required params' => sub {
    my $auth = $class->new({
        app_id => '1234',
        app_secret => 'hogefuga',
        time => '12345',
    });

    is $auth->app_id, '1234';
    is $auth->app_secret, 'hogefuga';
    is $auth->time, '12345';
};

subtest 'Test new w/o time' => sub {
    my $auth = $class->new({
        app_id => '1234',
        app_secret => 'hogefuga',
    });

    like $auth->time, qr|^\d+$|, 'default time is used';
};

subtest 'Test create_request fail for unknown type' => sub {
    my $auth = $class->new({
        app_id => '1',
        app_secret => 'hogehoge',
        time => '1234',
    });

    throws_ok {
        my $req = $auth->create_request(
            GET_HOGE => '/' => { hoge => 'fuga' }
        );
    } qr|"create_request"|;
};

subtest 'Test create_request for GET' => sub {
    my $auth = $class->new({
        app_id => '1',
        app_secret => 'hogehoge',
        time => '1234',
    });

    my $req = $auth->create_request(
        GET => '/' => { hoge => 'fuga' },
    );

    isa_ok $req, 'HTTP::Request';
};

subtest 'Test create_request for POST' => sub {
    my $auth = $class->new({
        app_id => '1',
        app_secret => 'hogehoge',
        time => '1234',
    });

    my $req = $auth->create_request(
        POST => '/' => { hoge => 'fuga' },
    );

    isa_ok $req, 'HTTP::Request';
};

subtest 'Test create_request for POST_JSON' => sub {
    my $auth = $class->new({
        app_id => '1',
        app_secret => 'hogehoge',
        time => '1234',
    });

    my $req = $auth->create_request(
        POST_JSON => '/' => { hoge => 'fuga' },
    );

    isa_ok $req, 'HTTP::Request';
};

subtest 'Test verify_request' => sub {
    my $auth = $class->new({
        app_id => '1',
        app_secret => 'hogehoge',
        time => '1234',
    });

    subtest 'Verify JSON' => sub {
        my $req = $auth->create_request(
            POST_JSON => '/' => { hoge => 'fuga' },
        );

        my $sig = $req->headers->header('x-sop-sig');
        my $json = $req->content;

        ok $auth->verify_signature($sig, $json);
        ok ! $auth->verify_signature('hoge', $json);
    };

    subtest 'Verify hashref' => sub {
        my $req = $auth->create_request(
            GET => '/' => { hoge => 'fuga' },
        );

        my %q = $req->uri->query_form;
        my $sig = delete $q{sig};

        ok $auth->verify_signature($sig, \%q);
        ok ! $auth->verify_signature($sig. 'hoge', \%q);
    };
};

done_testing;
