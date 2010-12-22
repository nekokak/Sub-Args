package Sub::Args;
use strict;
use warnings;
use 5.008001;
use Exporter 'import';
our @EXPORT = qw( args );
use Carp ();

our $VERSION = '0.06';

sub args {
    my $rule = shift;
    
    if (ref $rule ne 'HASH') {
        Carp::croak "args method require hashref's rule.";
    }
    
    my $invocant = caller(0);

    my $caller_args = ref($_[0]) eq 'HASH' ? $_[0] : {@_};
    unless (keys %$caller_args) {
        package DB;
        () = caller(1);
        my @args = @DB::args;

        shift @args if $invocant eq $args[0];

        if (ref($args[0]) eq 'HASH') {
            $caller_args = $args[0];
        } else {
            if (scalar(@args) % 2 == 1 ) {
                Carp::confess "arguments not allow excluding hash or hashref";
            }
            $caller_args = {@args};
        }
    }

    map {($rule->{$_} && not defined $caller_args->{$_}) ? Carp::confess "Mandatory parameter '$_' missing.": () } keys %$rule;

    map {(not defined $rule->{$_}) ? Carp::confess "not listed in the following parameter: $_.": () } keys %$caller_args;

    map {$caller_args->{$_} = undef unless exists $caller_args->{$_}} keys %$rule;

    Internals::SvREADONLY %$caller_args, 1;
    $caller_args;
}

1;
__END__

=head1 NAME

Sub::Args - Simple check/get arguments.

=head1 SYNOPSIS

  package Your::Class;
  use Sub::Args;
  sub foo {
      my $class = shift;
      my $args = args(
          {
              name => 1,
              age  => 0,
          }
      );
      $args;
  }
  sub bar {
      my $class = shift;
      my $args = args(
          {
              name => 1,
              age  => 0,
          }
      );
      $args->{email}; # die: email is not defined hash key.
  }
  
  # got +{name => nekokak, age => undef}
  Your::Class->foo(
      {
          name => 'nekokak',
      }
  );
  
  # got +{name => 'nekokak', age => 32}
  Your::Class->foo(
      {
          name => 'nekokak',
          age  => 32,
      }
  );
  
  # die: nick parameter don't defined for args method.
  Your::Class->foo(
      {
          name => 'nekokak',
          age  => 32,
          nick => 'inukaku',
      }
  );
  
  # die: name arguments must required.
  Your::Class->foo(
      {
          age => 32,
      }
  );

or

  package Your::Class;
  use Sub::Args;
  sub foo {
      my $class = shift;
      my $args = args(
          {
              name => 1,
              age  => 0,
          }, @_
      );
      $args;
  }
  
  # got +{name => nekokak}
  Your::Class->foo(
      {
          name => 'nekokak',
      }
  );

or

  package Your::Class;
  use Sub::Args;
  sub foo {
      my $args = args(
          {
              name => 1,
              age  => 0,
          }, @_
      );
      $args;
  }
  # got +{name => nekokak, age => undef}
  foo(
      {
          name => 'nekokak',
      }
  );

=head1 DESCRIPTION

This module makes your module more readable, and writable =p

and restrict a argument's hash. =(

When it accesses the key that doesn't exist, the exception is generated.

=head1 AUTHOR

Atsushi Kobayashi E<lt>nekokak _at_ gmail _dot_ comE<gt>

=head1 CONTRIBUTORS

hirobanex : Hiroyuki Akabane

=head1 SEE ALSO

L<Params::Validate>

L<Smart::Args>

L<Data::Validator>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
