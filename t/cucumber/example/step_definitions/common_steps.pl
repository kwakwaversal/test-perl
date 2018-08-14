#!/usr/bin/env perl

# ABSTRACT: Common feature steps available to all feature files in parent dir

use strict;
use warnings;
use Test::BDD::Cucumber::StepFile;
use Test::More;

# the before hook is called before every scenario (think Test::Class::Moose setup)
Before sub {
    my $c = shift;

    # Reset the number to 0 before every scenario
    $c->stash->{scenario}{number} = 0;
};

# the after hook is called after every scenario (think Test::Class::Moose teardown)
After sub {
    my $c = shift;

    # Delete any scenario stash elements (not useful, an example of using `After`)
    delete $c->stash->{scenario}{$_} for qw/number result/;
};
