package List::Helpers::XS;

use 5.026001;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
  'all' => [ qw/ shuffle random_slice random_slice_void / ],
  'slice' => [ qw/ random_slice random_slice_void / ],
  'shuffle' => [ qw/ shuffle / ],
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw//;

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('List::Helpers::XS', $VERSION);

1;
__END__
=head1 NAME

List::Helpers::XS - Perl extension to provide some usefull functions with arrays

=head1 SYNOPSIS

  use List::Helpers::XS qw/ :shuffle :slice /;

  my @slice = random_slice(\@list, $size);

  random_slice_void(\@list, $size);

  shuffle(\@list);
  shuffle(@list);

=head1 DESCRIPTION

This module provides some rare but usefull functions to work with arrays.

=head2 random_slice

This method receives an array and amount of required elements from it,
shuffles array's elements and returns the C<num> elements from it.

If C<num> is equal or higher than amount of elements in array, then
it won't do any work.

Otherwise the original array will be truncated down to C<num> elements.

It doesn't shuffle the whole array, it shuffle only C<num> elements and returns only them.

This method can a bit slow down in case of huge arrays and C<num>,
because of it copies chosen elements into the new array to be returned

In this case please consider the usage of C<random_slice_void> method.

Also the original array will be shuffled at the end.

=head2 random_slice_void

This method receives an array and amount of required elements from it,
shuffles array's elements. Doesn't return anything.

After method being called the passed array will contain only
random C<num> elements from the original array.

This method is a memory efficient.

=head2 shuflle

  Shuffle the provided array.
  Doesn't return anything.

=cut

=head1 Benchmarks

Below you can find some benchmarks of C<random_slice> and C<random_slice_void> methods
in comparison with C<Array::Shuffle::shuffle_array> / C<Array::Shuffle::array_shuffle_huge_array>
with C<splice> method invocation afterwards.

=begin text

Total amount of elements in initial array: 250
Benchmark: timing 1000000 iterations of Array::Shuffle::shuffle_array, Array::Shuffle::shuffle_huge_array, List::Helpers::XS::random_slice, List::Helpers::XS::random_slice_void...
                                         Rate Array::Shuffle::shuffle_huge_array Array::Shuffle::shuffle_array List::Helpers::XS::random_slice List::Helpers::XS::random_slice_void
Array::Shuffle::shuffle_huge_array    94877/s                                 --                           -0%                            -38%                                 -44%
Array::Shuffle::shuffle_array         94967/s                                 0%                            --                            -38%                                 -44%
List::Helpers::XS::random_slice      152439/s                                61%                           61%                              --                                 -10%
List::Helpers::XS::random_slice_void 168634/s                                78%                           78%                             11%                                   --

=end text

=begin text

Total amount of elements in initial array: 25_000

Benchmark: timing 100000 iterations of Array::Shuffle::shuffle_array, Array::Shuffle::shuffle_huge_array, List::Helpers::XS::random_slice, List::Helpers::XS::random_slice_void...                                               
                                       Rate Array::Shuffle::shuffle_array Array::Shuffle::shuffle_huge_array List::Helpers::XS::random_slice_void List::Helpers::XS::random_slice
Array::Shuffle::shuffle_array         994/s                            --                                -0%                                 -37%                            -42%
Array::Shuffle::shuffle_huge_array    994/s                            0%                                 --                                 -37%                            -42%
List::Helpers::XS::random_slice_void 1588/s                           60%                                60%                                   --                             -8%
List::Helpers::XS::random_slice      1726/s                           74%                                74%                                   9%                              --

=end text

Total amount of elements in initial array: 250_000

=begin text

Benchmark: timing 10000 iterations of Array::Shuffle::shuffle_array, Array::Shuffle::shuffle_huge_array, List::Helpers::XS::random_slice, List::Helpers::XS::random_slice_void...
                                       Rate Array::Shuffle::shuffle_huge_array Array::Shuffle::shuffle_array List::Helpers::XS::random_slice_void List::Helpers::XS::random_slice
Array::Shuffle::shuffle_huge_array   45.3/s                                 --                          -38%                                 -54%                            -59%
Array::Shuffle::shuffle_array        73.6/s                                62%                            --                                 -25%                            -33%
List::Helpers::XS::random_slice_void 97.8/s                               116%                           33%                                   --                            -11%
List::Helpers::XS::random_slice       110/s                               144%                           50%                                  13%                              --

=end text

The same benchmark for C<shuffle>

=begin text

                                      Rate Array::Shuffle::shuffle_array Array::Shuffle::shuffle_huge_array List::Helpers::XS
Array::Shuffle::shuffle_array      56883/s                            --                                -0%               -2%
Array::Shuffle::shuffle_huge_array 57078/s                            0%                                 --               -2%
List::Helpers::XS                  58173/s                            2%                                 2%                --

=end text

=head1 AUTHOR

Chernenko Dmitriy, cdn@cpan.org

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2021 by Dmitriy

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.26.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
