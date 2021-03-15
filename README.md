# perl_list_helpers_xs

### NAME
    List::Helpers::XS - Perl extension to provide some usefull functions with arrays

### SYNOPSIS

```perl
    use List::Helpers::XS qw/ :shuffle :slice /;

    my @slice = random_slice(\@list, $size);

    random_slice_void(\@list, $size);

    shuffle(\@list);
    shuffle(@list);
```

### DESCRIPTION
    This module provides some rare but usefull functions to work with
    arrays.

##### random_slice
    This method receives an array and amount of required elements from it,
    shuffles array's elements and returns the "num" elements from it.

    If "num" is equal or higher than amount of elements in array, then it
    won't do any work.

    Otherwise the original array will be truncated down to "num" elements.

    It doesn't shuffle the whole array, it shuffle only "num" elements and
    returns only them.

    This method can a bit slow down in case of huge arrays and "num",
    because of it copies chosen elements into the new array to be returned

    In this case please consider the usage of "random_slice_void" method.

    Also the original array will be shuffled at the end.

##### random_slice_void
    This method receives an array and amount of required elements from it,
    shuffles array's elements. Doesn't return anything.

    After method being called the passed array will contain only random
    "num" elements from the original array.

    This method is a memory efficient.

##### shuflle
      Shuffles the provided array.
      Doesn't return anything.

### Benchmarks
    Below you can find some benchmarks of "random_slice" and
    "random_slice_void" methods in comparison with
    "Array::Shuffle::shuffle_array" /
    "Array::Shuffle::shuffle_huge_array" with "splice" method
    invocation afterwards.

Total amount of elements in initial array: 250
```
                    Rate       shuffle_huge_array  random_slice  random_slice_void
shuffle_huge_array  94967/s    --                  -38%          -44%
random_slice        152439/s   61%                 --            -10%
random_slice_void   168634/s   78%                 11%           --
 
 
                   Rate       shuffle_array  random_slice  random_slice_void
shuffle_array      94877/s    --             -38%          -44%
random_slice       152439/s   61%            --            -10%
random_slice_void  168634/s   78%            11%           --
```

Total amount of elements in initial array: 25_000

```
                     Rate    shuffle_huge_array random_slice_void  random_slice
shuffle_huge_array    994/s  --                 -37%               -42%
random_slice_void    1588/s  60%                --                 -8%
random_slice         1726/s  74%                9%                 --
 
 
                     Rate    shuffle_array  random_slice_void  random_slice
shuffle_array         994/s  --             -37%               -42%
random_slice_void    1588/s  60%            --                 -8%
random_slice         1726/s  74%            9%                 --
```

Total amount of elements in initial array: 250_000

```
                    Rate    shuffle_huge_array  random_slice_void  random_slice
shuffle_huge_array  45.3/s  --                  -54%               -59%
random_slice_void   97.8/s  116%                --                 -11%
random_slice        110/s   144%                13%                --
 
 
                    Rate    shuffle_array  random_slice_void  random_slice
shuffle_array       73.6/s  --             -25%               -33%
random_slice_void   97.8/s  33%            --                 -11%
random_slice        110/s   50%            13%                --
```

The same benchmark for "shuffle"

```
                    Rate     shuffle_array shuffle_huge_array  shuffle
shuffle_array       56883/s  0%            -2%                 -2%
shuffle_huge_array  57078/s  0%            --                  -2%
shuffle             58173/s  2%            2%  
```

### AUTHOR
    Chernenko Dmitriy, cdn@cpan.org

### COPYRIGHT AND LICENSE
    Copyright (C) 2021 by Dmitriy

    This library is free software; you can redistribute it and/or modify it
    under the same terms as Perl itself, either Perl version 5.26.1 or, at
    your option, any later version of Perl 5 you may have available.
