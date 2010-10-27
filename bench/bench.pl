#! /usr/bin/perl
use strict;
use warnings;
use Benchmark qw/cmpthese/;

cmpthese(100000, {
    'P::V' => sub {Mock::PV->call(name => 'nekokak')},
    'S::A' => sub {Mock::SA->call({name => 'nekokak'})},
});

package Mock::PV;
use Params::Validate qw(:all);

sub call {
    shift;
    my %args = validate( @_, { name => 1});
}

package Mock::SA;
use Sub::Args;

sub call {
    shift;
    my $args = args({name => 1});
}

__END__
         Rate P::V S::A
P::V  50000/s   -- -54%
S::A 109890/s 120%   --
