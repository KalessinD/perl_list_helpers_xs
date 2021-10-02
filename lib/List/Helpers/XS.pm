package List::Helpers::XS;

use 5.026001;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [ qw/ shuffle_multi shuffle random_slice / ],
  'slice' => [ qw/ random_slice random_slice_void / ],
  'shuffle' => [ qw/ shuffle shuffle_multi / ],
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw//;

our $VERSION = '0.17';

require XSLoader;
XSLoader::load('List::Helpers::XS', $VERSION);

1;
__END__
=head1 NAME

List::Helpers::XS - Perl extension to provide some usefull functions with arrays

=head1 SYNOPSIS

  use List::Helpers::XS qw/ :shuffle :slice /;

  my $slice = random_slice(\@list, $size); # returns array reference

  shuffle(\@list);
  shuffle(@list);

  # undef value will be skipped
  shuffle_multi(\@list1, \@list2, undef, \@list3);

  # the same for tied arrays

  tie(@list, "MyPackage");
  shuffle(@list);
  shuffle(\@list);
  my $slice = random_slice(\@list, $size); # returns array reference

=head1 DESCRIPTION

This module provides some rare but usefull functions to work with arrays.
It supports tied arrays.

=head2 random_slice

This method receives the array and the amount of required elements to be shuffled,
shuffles array's elements and returns the array reference to the new
arrays with C<num> elements from original one.

If C<num> is equal or higher than amount of elements in array, then
it won't do any work.

It doesn't shuffle the whole array, it shuffles only C<num> elements and returns only them.
So, if you need to shuffle and get back only a part of array, then this method can be faster than others approaches.

Be aware that the original array will be shuffled too, but it won't be sliced.

=head2 shuflle

Shuffles the provided array.
Doesn't return anything.

=head2 shuffle_multi

Shuffles multiple arrays.
Each array must be passed as array reference.
All undefined arrays will be skipped.
This method will allow you to save some time by getting rid of extra calls.
You can pass so many arguments as Perl stack allows.

=head1 Benchmarks

Below you can find some benchmarks of C<random_slice> and C<random_slice_void> methods
in comparison with C<Array::Shuffle::shuffle_array> / C<Array::Shuffle::shuffle_huge_array>
with C<splice> method invocation afterwards.

Total amount of elements in initial array: 250

                           Rate shuffle and splice List::Util::sample List::MoreUtils::samples random_slice
shuffle and splice       70.0/s                 --               -61%                     -62%         -63%
List::Util::sample        178/s               154%                 --                      -3%          -5%
List::MoreUtils::samples  184/s               163%                 3%                       --          -2%
random_slice              188/s               168%                 5%                       2%           --

Total amount of elements in initial array: 25_000

                           Rate shuffle and splice List::Util::sample List::MoreUtils::samples random_slice
shuffle and splice       70.3/s                 --               -62%                     -62%         -62%
List::Util::sample        183/s               160%                 --                      -0%          -1%
List::MoreUtils::samples  184/s               162%                 0%                       --          -1%
random_slice              186/s               164%                 1%                       1%           --

Total amount of elements in initial array: 250_000

                           Rate shuffle and splice List::MoreUtils::samples List::Util::sample random_slice
shuffle and splice       69.9/s                 --                     -62%               -62%         -63%
List::MoreUtils::samples  183/s               161%                       --                -1%          -3%
List::Util::sample        184/s               163%                       1%                 --          -2%
random_slice              189/s               170%                       3%                 2%           --

The benchmark code is below:

  cmpthese timethese(
      1_00_000,
      {
          'shuffle and splice' => sub {
              my $arr = [@array];
              if ($slice_size < scalar $arr->@*) {
                  shuffle_array(@$arr);
                  @$arr = splice(@$arr, 0, $slice_size);
              }
          },
          'random_slice' => sub {
              my $arr = [@array];
              $arr = random_slice($arr, $slice_size);
          },
          'List::MoreUtils::samples' => sub {
              my $arr = [@array];
              @$arr = List::MoreUtils::samples($slice_size, @$arr);
          },
          'List::Util::sample' => sub {
              my $arr = [@array];
              @$arr = List::Util::sample($slice_size, @$arr);
          },
      }
  );

The benchmark results for C<shuffle> method

                            shuffle_huge_array  List::Helpers::XS::shuffle
shuffle_huge_array                          --                         -5%
List::Helpers::XS::shuffle                  5%                          --

                            shuffle_array  List::Helpers::XS::shuffle
shuffle_array                                      --             -4%
List::Helpers::XS::shuffle                          4%             --

                            List::Util::shuffle  List::Helpers::XS::shuffle
List::Util::shuffle                          --                        -63%
List::Helpers::XS::shuffle                  170%                         --

=head1 AUTHOR

Chernenko Dmitriy, cdn@cpan.org

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2021 by Dmitriy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.26.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
