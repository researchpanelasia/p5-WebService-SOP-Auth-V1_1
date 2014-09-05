use strict;
use warnings;
use Test::Exception;
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
    });

    is $auth->app_id, '1234';
    is $auth->app_secret, 'hogefuga';
};

done_testing;
