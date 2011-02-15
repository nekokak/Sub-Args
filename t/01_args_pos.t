use strict;
use warnings;
use Test::More;

{
    package Mock;
    use Sub::Args;
    sub foo {
        my @args = args_pos(1,1,0);
    }
}

{
    package MockObject;
    use Sub::Args;
    sub new{bless {},+shift}
    sub foo {
        my $self = shift;
        my @args = args_pos(1,1,0);
    }
}
#ジッサイノテストをかく
subtest 'ok case /object' => sub {
    is_deeply [MockObject->foo(1,2,3)], [qw/1 2 3/];
    is_deeply [MockObject->foo(1,2)], [1,2,undef];
};

subtest 'ok case / no object' => sub {
    is_deeply [Mock->foo(1,2,3)], [qw/1 2 3/];
    is_deeply [Mock->foo(1,2)], [1,2,undef];
};

subtest 'error case / no object' => sub {
    eval {
        Mock->foo(1,2,3,4,5);
    };
    like $@, qr/too much arguments. This function requires only 3 arguments./;

    eval {
        Mock->foo(1);
    };
    like $@, qr/missing mandatory parameter. pos: 1/;
};

done_testing;
