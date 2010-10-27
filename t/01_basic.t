use strict;
use warnings;
use Test::More;

my $args = Mock->foo(
    {
        name => 'nekokak',
    }
);

is_deeply Mock->foo({name => 'nekokak'}), +{name => 'nekokak'};
is_deeply Mock->foo({name => 'nekokak', age => 32}), +{name => 'nekokak', age => 32};
is_deeply Mock->foo({name => 'nekokak', age => 32, nick => 'inukaku'}), +{name => 'nekokak', age => 32};

eval {
    Mock->foo({age => 32});
};
like $@, qr/name required!/;

eval {
    Mock->bar({age => 32});
};
like $@, qr/args method require hashref./;

eval {
    Mock->foo('aaa');
};
like $@, qr/It is only hashref to be able to treat args method./;

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

1;


