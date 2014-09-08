use strict;
use Test::More 0.98;
use Test::Pretty;

use_ok $_ for qw(
    SOPx::Auth::V1_1
    SOPx::Auth::V1_1::Util
    SOPx::Auth::V1_1::Request::GET
    SOPx::Auth::V1_1::Request::POST
    SOPx::Auth::V1_1::Request::POST_JSON
);

done_testing;

