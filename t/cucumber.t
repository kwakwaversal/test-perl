#!/usr/bin/env perl

# ABSTRACT: Testing features using BDD/Test::BDD::Cucumber

use strict;
use warnings;

# This harness prints out nicer TAP
use Test::BDD::Cucumber::Harness::TestBuilder;

# Simplify loading of Step Definition and feature files
use Test::BDD::Cucumber::Loader;

# Load a directory with Cucumber files in it. It will recursively execute any
# file matching .*_steps.pl as a Step file, and .*\.feature as a feature file.
# The features are returned in @features, and the executor is created with the
# step definitions loaded.
my ($executor, @features) = Test::BDD::Cucumber::Loader->load('t/cucumber/');

# Create a Harness to execute against. TestBuilder harness prints TAP
my $harness = Test::BDD::Cucumber::Harness::TestBuilder->new({});

# For each feature found, execute it, using the Harness to print results
$executor->execute($_, $harness) for @features;

# Shutdown gracefully
$harness->shutdown();
