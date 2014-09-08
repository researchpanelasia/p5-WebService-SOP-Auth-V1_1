use strict;
use warnings;
use SOPx::Auth::V1_1::Util;
use Test::Exception;
use Test::More;
use Test::Pretty;

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

done_testing;
