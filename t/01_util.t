use strict;
use warnings;
use SOPx::Auth::V1_1::Util;
use Test::Exception;
use Test::More;
use Test::Pretty;

subtest 'Test create_string_from_hashref' => sub {
    is SOPx::Auth::V1_1::Util::create_string_from_hashref({
        zzz => 'zzz',
        yyy => 'yyy',
        xxx => 'xxx',
    }) => 'xxx=xxx&yyy=yyy&zzz=zzz';

    is SOPx::Auth::V1_1::Util::create_string_from_hashref({
        sop_xxx => 'sop_xxx',
        zzz => 'zzz',
        yyy => 'yyy',
        xxx => 'xxx',
    }) => 'xxx=xxx&yyy=yyy&zzz=zzz', 'prefix "sop_" is ignored for signature generation';

    throws_ok {
        SOPx::Auth::V1_1::Util::create_string_from_hashref({
            zzz => { aaa => 'aaa', },
        })
    } qr|not allowed|;
};

subtest 'Test create_signature' => sub {

    is SOPx::Auth::V1_1::Util::create_signature({
            ccc => 'ccc',
            bbb => 'bbb',
            aaa => 'aaa',
            }, 'hogehoge')
       => '2fbfe87e54cc53036463633ef29beeaa4d740e435af586798917826d9e525112';

    is SOPx::Auth::V1_1::Util::create_signature({
            ccc => 'ccc',
            bbb => 'bbb',
            aaa => 'aaa',
            sop_hoge => 'hoge', # to be excluded from sig generation
            }, 'hogehoge')
       => '2fbfe87e54cc53036463633ef29beeaa4d740e435af586798917826d9e525112';

    is SOPx::Auth::V1_1::Util::create_signature(
            '{"hoge":"fuga"}',
            'hogehoge')
       => 'dc76e675e2bcabc31182e33506f5b01ea7966a9c0640d335cc6cc551f0bb1bba';
};

subtest 'Test is_signature_valid' => sub {
    ok SOPx::Auth::V1_1::Util::is_signature_valid(
        '2fbfe87e54cc53036463633ef29beeaa4d740e435af586798917826d9e525112' => {
            ccc => 'ccc',
            bbb => 'bbb',
            aaa => 'aaa',
        },
        'hogehoge',
    );

    ok SOPx::Auth::V1_1::Util::is_signature_valid(
        'b85fb65238287bb3ac0db91140db581290ae9216d8737a2e06f8ea9407c79ae8' => '{"msg":"This is JSON data"}',
        'hogehoge'
    );

    ok ! SOPx::Auth::V1_1::Util::is_signature_valid(
        'b85fb65238287bb3ac0db91140db581290ae9216d8737a2e06f8ea9407c79ae8' => '{"msg":"This is JSON data"}',
        'hogehoge-hoge',
    );
};

done_testing;
