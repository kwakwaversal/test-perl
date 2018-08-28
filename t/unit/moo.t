#!/usr/bin/env perl

use strict;
use warnings;
use Test2::V0;

# ABSTRACT: Testing p3rl.org/Moo

subtest default => \&test_default;
subtest lazy    => \&test_lazy;

done_testing;

BEGIN {
    package Moo::Default;

    use Moo;
    use Types::Standard 'Str';

    # ABSTRACT: testing default attributes

    has foo => (
        is      => 'ro',
        default => sub { 'bar' },
    );

    has overwrite => (
        is      => 'ro',
        default => sub { 'hmm' },
    );

    has lazyfoo => (
        is      => 'lazy',
        default => sub { 'bar' },
    );
}

sub test_default {
    my $default = Moo::Default->new(overwrite => 'oh');
    is $default->foo       => 'bar', 'sub returns default';
    is $default->overwrite => 'oh',  'overwrite default on instantiation';
    is $default->lazyfoo   => 'bar', 'lazy default works';
}

BEGIN {
    package Moo::Lazy;

    use Moo;
    use Types::Standard 'Str';

    # ABSTRACT: test lazy builder priority (instantiation and extending)

    has foo => (
        is      => 'lazy',
        isa     => Str,
        builder => sub { 'bar' }
    );

    # Foo's builder attr inserts the CODE ref as the method below
    # sub _build_foo { 'foo' }

    package Moo::Lazy::Extended;

    use Moo;
    extends 'Moo::Lazy';

    sub _build_foo { 'extended' }
}

sub test_lazy {
    my $lazy = Moo::Lazy->new();
    is $lazy->foo => 'bar', 'builder acts *like* a default';

    my $attr = Moo::Lazy->new(foo => 'instantiated');
    is $attr->foo => 'instantiated', 'but setting attr on instantation has no affect';

    my $extended = Moo::Lazy::Extended->new();
    is $extended->foo => 'extended', 'the extended method _build_foo has priority';
}
