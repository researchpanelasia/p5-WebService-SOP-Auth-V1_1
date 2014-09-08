package SOPx::Auth::V1_1::Util;
use strict;
use warnings;
use Carp ();
use Digest::SHA qw(hmac_sha256_hex);
use Exporter qw(import);

our @EXPORT_OK = qw( create_signature is_signature_valid );

sub create_signature {
    my ($params, $app_secret) = @_;
    my $data_string
            = ref($params) eq 'HASH'  ? create_string_from_hashref($params)
            : !ref($params)           ? $params
            : do { Carp::croak("create_signature does not handle type: ". ref($params)) };
    hmac_sha256_hex($data_string, $app_secret);
}

sub create_string_from_hashref {
    my $params = shift;
    join(
        '&',
        map {
            Carp::croak("Structured data not allowed") if ref $params->{$_};
            $_. '='. ($params->{$_} || '');
        } sort { $a cmp $b } keys %$params
    );
}

#sub create_string_from_arrayref {
#    my $params = shift;
#    join(
#        '&',
#        map {
#            Carp::croak("Structured data not allowed") if ref $_;
#            $_;
#        } @$params
#    );
#}

sub is_signature_valid {
    my ($sig, $params, $app_secret) = @_;
    $sig eq create_signature($params, $app_secret);
}

1;
