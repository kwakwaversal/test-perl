#!/usr/bin/env perl

use v5.10;
use strict;
use warnings;
use Test2::V0;

# ABSTRACT: Testing p3rl.org/Type::Tiny

subtest type_checking    => \&test_type_checking;
subtest type_coercions   => \&test_type_coercions;
subtest param_validation => \&test_param_validation;

done_testing;

BEGIN {
    package My::Types;

    # ABSTRACT: Create custom type library for tests

    use strict;
    use warnings;
    use Type::Library
        -base,
        -declare => qw(MyClassType MyStr MyStrBar MyStrCsv);
    use Type::Utils -all;
    use Types::Standard qw(ArrayRef HashRef Str);

    # has myclass => (is => 'ro', isa => MyClassType, coerce => 1);
    class_type MyClassType, { class => 'My::Class' };
    coerce MyClassType,
        from HashRef, via { My::Class->new(@_) },
        from Str, via { My::Class->new() };

    declare MyStr, as Str;
    declare MyStrBar, as Str->where(sub { $_ eq 'bar' });

    declare MyStrCsv, as Str;
    coerce MyStrCsv, from ArrayRef, via {
        join ', ', @$_;
    };

    1;
}

BEGIN {
    package My::Class;

    # ABSTRACT: Create custom class for param validation

    use Moo;
    use Types::Standard qw(Object Str);
    use Type::Params 'compile';

    my $BarStr = Str->where(sub { $_ eq 'bar' });

    sub is_bar {
        state $check = compile(Object, $BarStr);
        my ($self, $str) = &$check;
        return $self;
    }
}

sub test_type_checking {
    ok lives {
        My::Types::MyClassType->coerce({})->is_bar('bar');
        My::Types::MyClassType->coerce('')->is_bar('bar');
    };
    is My::Types::MyStr->check('foo')    => 1,     'is a str';
    is My::Types::MyStrBar->check('foo') => undef, 'is not bar';
    is My::Types::MyStrBar->check('bar') => 1,     'is bar';
}

sub test_type_coercions {
    is My::Types::MyStrCsv->coerce('ha') => 'ha', 'is ha';
    is My::Types::MyStrCsv->coerce([qw(ha ha)]) => 'ha, ha', 'is ha, ha';
}

sub test_param_validation {
    my $class = My::Class->new;
    like dies { $class->is_bar('foo') }, qr/did not pass type constraint/;
    ok lives { $class->is_bar('bar') };
}

__END__

=encoding utf8

=head1 SEE ALSO

L<http://blogs.perl.org/users/toby_inkster/2018/08/exploring-typetiny-part-2-using-typetiny-with-moose.html>.

=cut
