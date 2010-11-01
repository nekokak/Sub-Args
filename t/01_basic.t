use strict;
use warnings;
use Test::More;

is_deeply Mock->foo({name => 'nekokak'}), +{name => 'nekokak'};
is_deeply Mock->foo({name => 'nekokak', age => 32}), +{name => 'nekokak', age => 32};

eval {
    Mock->foo({name => 'nekokak', age => 32, nick => 'inukaku'});
};
like $@, qr/not listed in the following parameter: nick./;

eval {
    Mock->foo({age => 32});
};
like $@, qr/Mandatory parameter 'name' missing./;

eval {
    Mock->bar({age => 32});
};
like $@, qr/args method require hashref./;

eval {
    Mock->foo('aaa');
};
like $@, qr/It is only hashref to be able to treat args method./;

is_deeply Mock->baz({name => 'nekokak'}), +{name => 'nekokak'};
is_deeply Mock->hoge({name => 'nekokak'}), +{name => 'nekokak'};

done_testing;

package Mock;
use Sub::Args;

sub foo {
    my $args = args(
        {
            name => 1,
            age  => 0,
        }
    );
    $args;
}

sub bar {
    args('bbb');
}

sub baz {
    my $args = args(
        {
            name => 1,
            age  => 0,
        }, @_
    );
    $args;
}

sub hoge {
    my $self = shift;
    my $args = args(
        {
            name => 1,
            age  => 0,
        }, @_
    );
    $args;
}

1;


