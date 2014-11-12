package WebService::SOP::Auth::V1_1;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Carp ();
use URI;
use WebService::SOP::Auth::V1_1::Request::GET;
use WebService::SOP::Auth::V1_1::Request::POST;
use WebService::SOP::Auth::V1_1::Request::POST_JSON;
use WebService::SOP::Auth::V1_1::Util qw(is_signature_valid);

sub new {
    my ($class, $args) = @_;
    $args ||= +{ };

    do {
        Carp::croak("Missing required parameter: ${_}") if not $args->{$_};
    } for qw( app_id app_secret );

    $args->{time} = time if not $args->{time};

    bless $args, $class;
}

sub app_id     { $_[0]->{app_id} }
sub app_secret { $_[0]->{app_secret} }
sub time       { $_[0]->{time} }

sub create_request {
    my ($self, $type, $uri, $params) = @_;
    $uri = URI->new($uri) if not ref $uri;
    my $request_maker = "WebService::SOP::Auth::V1_1::Request::${type}";
    $request_maker->create_request(
        $uri,
        { %$params, time => $self->time },
        $self->app_secret,
    );
}

sub verify_signature {
    my ($self, $sig, $params) = @_;
    is_signature_valid($sig, $params, $self->app_secret, $self->time);
}

1;
__END__

=encoding utf-8

=head1 NAME

WebService::SOP::Auth::V1_1 - SOP version 1.1 authentication module

=head1 SYNOPSIS

    use WebService::SOP::Auth::V1_1;

When making a GET request to API:

    my $auth = WebService::SOP::Auth::V1_1->new({
        app_id => '1',
        app_secret => 'hogehoge',
    });

    my $req = $auth->create_request(
        GET => 'https://<API_HOST>/path/to/endpoint' => {
            hoge => 'hoge',
            fuga => 'fuga',
        },
    );
    #=> HTTP::Request object

    my $res = LWP::UserAgent->new->request($req);
    #=> HTTP::Response object

When embedding JavaScript URL in page:

    <script src="<: $req.uri.as_string :>"></script>

=head1 DESCRIPTION

WebService::SOP::Auth::V1_1 is an authentication module
for L<SOP|http://console.partners.surveyon.com/> version 1.1
by L<Research Panel Asia, Inc|http://www.researchpanelasia.com/>.

=head1 METHODS

=head2 new( \%options )

Creates a new instance.

Possible options:

=over 4

=item C<app_id>

(Required) Your C<app_id>.

=item C<app_secret>

(Required) Your C<app_secret>.

=item C<time>

(Optional) POSIX time.

=back

=head2 app_id

Gets C<app_id> configured to instance.

=head2 app_secret

Gets C<app_secret> configured to instance.

=head2 time

Gets C<time> configured to instance.

=head2 create_request( $type, $uri, $params )

Creates a new L<HTTP::Request> object for API request.

=head2 verify_signature( $sig, $params )

Verifies if request signature is valid.

=head1 SEE ALSO

L<WebService::SOP::Auth::V1_1::Util>

Research Panel Asia, Inc. website L<http://www.researchpanelasia.com/>

=head1 LICENSE

Copyright (C) Research Panel Asia, Inc.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

yowcowvg E<lt>yoko_ohyama [ at ] voyagegroup.comE<gt>

=cut

