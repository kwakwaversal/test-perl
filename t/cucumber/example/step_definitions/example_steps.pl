#!/usr/bin/env perl

# ABSTRACT: steps specific to example feature (still considered global)

use strict;
use warnings;
use Test::BDD::Cucumber::StepFile;
use Test::More;

Given 'a brain' => sub {
};

Given 'some food and water' => sub {
};

Given qr{^the number (?<number>\d+)} => sub {
    S->{number} = $+{number};
};

When qr{^you (?<operation>(add|subtract)) the number (?<value>\d+)} => sub {
    my ($operation, $value) = @+{qw/operation value/};

    if ($operation eq 'add') {
        S->{result} = S->{number} + $value;
    }
    elsif ($operation eq 'subtract') {
        S->{result} = S->{number} - $value;
    }
};

Then qr{^the value is (?<value>\d+)} => sub {
    # Confusingly every step that is run (without actually testing anything)
    # is considered a test.
    plan tests => 2;

    is S->{result} => $+{value}, 'correct value';
};
