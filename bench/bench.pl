#! /usr/bin/perl
use strict;
use warnings;
use Benchmark qw/cmpthese/;

cmpthese(100000, {
    'P::V'       => sub {Mock::PV->call(name => 'nekokak')},
    'S::A'       => sub {Mock::SA->call({name => 'nekokak'})},
    'S::A_fast'  => sub {Mock::SA->call_fast({name => 'nekokak'})},
    'S::A_fast2' => sub {Mock::SA->call_fast2({name => 'nekokak'})},
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

sub call_fast {
    my $args = args({name => 1}, @_);
}

sub call_fast2 {
    shift;
    my $args = args({name => 1}, @_);
}

__END__
              Rate      P::V      S::A S::A_fast
P::V       38610/s        --      -68%      -79%
S::A      120482/s      212%        --      -35%
S::A_fast 185185/s      380%       54%        --

