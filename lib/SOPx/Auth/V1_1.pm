package SOPx::Auth::V1_1;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Digest::SHA qw(hmac_sha256_hex);

sub new {
    my ($class, $args) = @_;
    $args ||= +{ };

    do {
        Carp::croak("Missing required parameter: ${_}") if not $args->{$_};
    } for qw( app_id app_secret );

    bless $args, $class;
}

sub app_id     { $_[0]->{app_id} }
sub app_secret { $_[0]->{app_secret} }

sub generate_signature {
    my ($self, $query) = @_;

    Carp::croak "Missing required parameter: time" if not $query->{time};

    my $query_string = join(
        '&',
        map { $_. '='. ($query->{$_} || '') }
        sort { $a cmp $b } keys %$query
    );
    hmac_sha256_hex($query_string, $self->app_secret);
}

sub sign_query {
    my ($self, $query) = @_;
    $query->{time} ||= time;
    +{
        %$query,
        sig => $self->generate_signature($query),
    };
}

sub verify_query {
    my ($self, $query) = @_;
    my $sig = delete $query->{sig}
            or Carp::croak("Missing required parameter: sig");
    $self->generate_signature($query) eq $sig;
}

1;
__END__

=encoding utf-8

=head1 NAME

SOPx::Auth::V1_1 - SOP version 1.1 authentication module

=head1 SYNOPSIS

    use SOPx::Auth::V1_1;

    my $auth = SOPx::Auth::V1_1->new({
        app_id => '1',
        app_secret => 'hogehoge',
    });


=head1 DESCRIPTION

SOPx::Auth::V1_1 is an authentication for SOP version 1.1.

=head1 LICENSE

Copyright (C) yowcowvg.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

yowcowvg E<lt>yoko_ohyama [ at ] voyagegroup.comE<gt>

=cut

