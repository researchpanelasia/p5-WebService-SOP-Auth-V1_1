requires 'perl', '5.008001';

requires 'Carp';
requires 'Digest::SHA';
requires 'URI';

on 'test' => sub {
    requires 'Test::Exception';
    requires 'Test::More', '0.98';
    requires 'Test::Pretty';
};

