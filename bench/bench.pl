#! /usr/bin/perl
use strict;
use warnings;
use Benchmark qw/cmpthese/;

cmpthese(100000, {
    'SM::A'      => sub {Mock::SMA->call({name => 'nekokak'})},
    'P::V'       => sub {Mock::PV->call(name => 'nekokak')},
    'S::A'       => sub {Mock::SA->call({name => 'nekokak'})},
    'S::A_fast'  => sub {Mock::SA->call_fast({name => 'nekokak'})},
});

package Mock::SMA;
use Smart::Args;

sub call {
    args my $self, my $name;
}

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

sub call_fast {
    shift;
    my $args = args({name => 1}, @_);
}

__END__
              Rate      P::V     SM::A      S::A S::A_fast
P::V       46729/s        --      -55%      -61%      -78%
SM::A     103093/s      121%        --      -13%      -52%
S::A      119048/s      155%       15%        --      -44%
S::A_fast 212766/s      355%      106%       79%        --
