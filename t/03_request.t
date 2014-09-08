use strict;
use warnings;
use Data::Dumper;
use Test::Exception;
use Test::More;
use Test::Pretty;
use SOPx::Auth::V1_1;

my $auth = SOPx::Auth::V1_1->new({
    app_id => '1234',
    app_secret => 'hogehoge',
});

subtest 'Test create_request for type GET' => sub {
    my $req = $auth->create_request(
        GET => '/' => {
            aaa => 'aaa',
            bbb => 'bbb',
            time => '1234',
        },
    );

    isa_ok $req, 'HTTP::Request';
    is $req->uri->path => '/';

    my %q = $req->uri->query_form;

    is_deeply \%q, {
        aaa => 'aaa',
        bbb => 'bbb',
        time => '1234',
        sig => '40499603a4a5e8d4139817e415f637a180a7c18c1a2ab03aa5b296d7756818f6',
    };
};

subtest 'Test create_request for type POST' => sub {
};

subtest 'Test create_request for type POST_JSON' => sub {
};

done_testing;
