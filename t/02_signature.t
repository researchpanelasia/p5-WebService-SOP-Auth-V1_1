use strict;
use warnings;
use Test::Exception;
use Test::More;
use Test::Pretty;
use SOPx::Auth::V1_1;

my $class = 'SOPx::Auth::V1_1';
my $auth = $class->new({
    app_id => '1234',
    app_secret => 'hogefuga',
});

subtest 'Test generate_signature w/o time' => sub {
    throws_ok {
        $auth->generate_signature({
            app_id => '1234',
            hoge => 'hoge',
            fuga => 'fuga',
        })
    } qr|Missing required parameter: time|;
};

subtest 'Test generate_signature w/ time' => sub {
    my $res = $auth->generate_signature({
        app_id => '1234',
        hoge => 'hoge',
        fuga => 'fuga',
        time => 123456,
    });

    is $res, 'c4a23f5cb57d0bfe16a7ad4fc58ba0cccd92122efb144b0abf43315ff171a746';
};

subtest 'Test sign_query w/o time' => sub {
    my $res = $auth->sign_query({
        app_id => '1234',
        hoge => 'hoge',
        fuga => 'fuga',
    });

    ok defined $res->{time};
    is length $res->{sig}, 64;
};

subtest 'Test sign_query w/ time' => sub {
    my $res = $auth->sign_query({
        app_id => '1234',
        hoge => 'hoge',
        fuga => 'fuga',
        time => 123456,
    });

    is_deeply $res, {
        app_id => '1234',
        hoge => 'hoge',
        fuga => 'fuga',
        time => 123456,
        sig => 'c4a23f5cb57d0bfe16a7ad4fc58ba0cccd92122efb144b0abf43315ff171a746',
    };
};

subtest 'Test verify_query w/o required parameter' => sub {
    ok !$auth->verify_query({
        app_id => '1234',
        hoge => 'hoge',
        fuga => 'fuga',
        time => 123456,
    });

    ok !$auth->verify_query({
        app_id => '1234',
        hoge => 'hoge',
        fuga => 'fuga',
        sig => 'c4a23f5cb57d0bfe16a7ad4fc58ba0cccd92122efb144b0abf43315ff171a746',
    });
};

subtest 'Test verify_query w/ required parameters' => sub {
    ok $auth->verify_query({
        app_id => '1234',
        hoge => 'hoge',
        fuga => 'fuga',
        sig => 'c4a23f5cb57d0bfe16a7ad4fc58ba0cccd92122efb144b0abf43315ff171a746',
        time => 123456,
    });

    ok !$auth->verify_query({
        app_id => '1234',
        hoge => 'hogehoge',
        fuga => 'fugafuga',
        sig => 'c4a23f5cb57d0bfe16a7ad4fc58ba0cccd92122efb144b0abf43315ff171a746',
        time => 123456,
    });
};

done_testing;
