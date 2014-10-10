package SOPx::Auth::V1_1::Util;
use strict;
use warnings;
use Carp ();
use Digest::SHA qw(hmac_sha256_hex);
use Exporter qw(import);

our @EXPORT_OK = qw( create_signature is_signature_valid );

our $SIG_VALID_FOR_SEC = 10 * 60; # Valid for 10 min by default

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
        } sort { $a cmp $b } grep { !m/^sop_/ } keys %$params
    );
}

sub is_signature_valid {
    my ($sig, $params, $app_secret, $time) = @_;
    $time ||= time;

    return if not defined $params->{time};
    return if $params->{time} < ($time - $SIG_VALID_FOR_SEC)
           or $params->{time} > ($time + $SIG_VALID_FOR_SEC);

    $sig eq create_signature($params, $app_secret);
}

1;

__END__

=encoding utf-8

=head1 NAME

SOPx::Auth::V1_1::Util - SOP version 1.1 authentication utility

=head1 SYNOPSIS

    use SOPx::Auth::V1_1 qw(create_signature is_signature_valid);

When creating a signature:

    my $sig = create_signature($params, $app_secret);
    #=> HMAC SHA256 hash signature

    my $is_valid = is_signature_valid($sig, $params, $app_secret);
    #=> Validation result

=head1 METHODS

=head2 create_signature( $params, $app_secret )

Creates a HMAC SHA256 hash signature.

=head2 create_string_from_hashref( $params )

Creates a string from parameters in type hashref.

=head2 is_signature_valid( $sig, $params, $app_secret, $time )

Validates if a signature is valid for given parameters.
C<$time> is optional where C<time()> is used by default.
