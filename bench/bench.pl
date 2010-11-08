#! /usr/bin/perl
use strict;
use warnings;
use Benchmark qw/cmpthese/;

cmpthese(100000, {
    'SM::A'      => sub {Mock::SMA->call({name => 'nekokak'})},
    'P::V'       => sub {Mock::PV->call(name => 'nekokak')},
    'S::A'       => sub {Mock::SA->call({name => 'nekokak'})},
    'S::A_fast'  => sub {Mock::SA->call_fast({name => 'nekokak'})},
    'S::A_fast2' => sub {Mock::SA->call_fast2({name => 'nekokak'})},
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
    my $args = args({name => 1}, @_);
}

sub call_fast2 {
    shift;
    my $args = args({name => 1}, @_);
}

__END__
               Rate       P::V      SM::A       S::A S::A_fast2  S::A_fast
P::V        24691/s         --       -56%       -63%       -76%       -76%
SM::A       56180/s       128%         --       -17%       -44%       -46%
S::A        67568/s       174%        20%         --       -33%       -35%
S::A_fast2 101010/s       309%        80%        49%         --        -3%
S::A_fast  104167/s       322%        85%        54%         3%         --

