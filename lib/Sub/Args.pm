package Sub::Args;
use strict;
use warnings;
use Exporter 'import';
our @EXPORT = qw( args );
use Carp ();

our $VERSION = '0.03';

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

    map {($opts->{$_} && not defined $caller_args->{$_}) ? Carp::confess "Mandatory parameter '$_' missing.": () } keys %$opts;

    map {(not defined $opts->{$_}) ? Carp::confess "not listed in the following parameter: $_.": () } keys %$caller_args;

    $caller_args;
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
  
  # nick parameter don't defined for args method.
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

=head1 CONTRIBUTORS

hirobanex : Hiroyuki Akabane

=head1 SEE ALSO

L<Params::Validate>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
