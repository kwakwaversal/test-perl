requires 'Moo', '1.006000';  # for `coerce => 1`
requires 'Type::Tiny';

on test => sub {
    requires 'Test2::V0';
    requires 'Test::BDD::Cucumber';
};
