#! /usr/bin/perl
use strict;
use warnings;
use Benchmark qw/cmpthese/;

cmpthese(200000, {
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
               Rate       P::V       S::A S::A_fast2  S::A_fast
P::V        50125/s         --       -66%       -79%       -80%
S::A       147059/s       193%         --       -39%       -43%
S::A_fast2 240964/s       381%        64%         --        -6%
S::A_fast  256410/s       412%        74%         6%         --
