package Sub::Args;
use strict;
use warnings;
use Exporter 'import';
our @EXPORT = qw( args );

our $VERSION = '0.01';

sub args {
    my $opts = shift;
    if (ref $opts ne 'HASH') {
        die 'args method require hashref.';
    }

    my $caller_args;
    if (scalar(@_) >= 2) {
        $caller_args = $_[1];
    } elsif (scalar(@_) ==1) {
        $caller_args = $_[0];
    } else {
        package DB;
        () = caller(1);
        $caller_args = $DB::args[1];
    }

    if (ref $caller_args ne 'HASH') {
        die 'It is only hashref to be able to treat args method.';
    }

    my $args;
    for my $key (keys %$opts) {
        if (exists $caller_args->{$key}) {
            $args->{$key} = $caller_args->{$key};
        }
        if ($opts->{$key} && not defined $args->{$key}) {
            die "$key required!";
        }
    }
    $args;
}

1;
__END__

=head1 NAME

Sub::Args - Simple check/get arguments.

=head1 SYNOPSIS

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
  
  # got +{name => nekokak}
  foo(
      {
          name => 'nekokak',
      }
  );
  
  # got +{name => 'nekokak', age => 32}
  foo(
      {
          name => 'nekokak',
          age  => 32,
      }
  );
  
  # got +{name => 'nekokak', age => 32}
  foo(
      {
          name => 'nekokak',
          age  => 32,
          nick => 'inukaku',
      }
  );
  
  # name arguments must required. for die.
  foo(
      {
          age => 32,
      }
  );

=head1 DESCRIPTION

This module makes your module more readable, and writable =p

=head1 AUTHOR

Atsushi Kobayashi E<lt>nekokak _at_ gmail _dot_ comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
