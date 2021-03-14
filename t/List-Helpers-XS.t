package main;

use utf8;
use strict;
use warnings;

use Test::LeakTrace qw/ no_leaks_ok /;
use Test::More ('import' => [qw/ done_testing is use_ok /]);

BEGIN { use_ok('List::Helpers::XS') };

List::Helpers::XS->import(':all');

my @list = ( 0 .. 9 );

shuffle(\@list);
is( scalar(@list), 10, "Checking the list size after shuffling" );

List::Helpers::XS::shuffle(@list);
is( scalar(@list), 10, "Checking the list size after shuffling" );

random_slice_void(\@list, 3);
is( scalar(@list), 3, "Checking the list size after slicing in void context" );

@list = ( 0 .. 9 );

my $slice = random_slice(\@list, 3);
is( scalar(@list), 10, "Checking the list size after slicing" );
is( scalar(@$slice), 3, "Checking the slice size" );

undef(@list);
undef($slice);

# check for memory leaks
no_leaks_ok {

    @list = ( 0 .. 9 );

    shuffle(\@list);
    List::Helpers::XS::shuffle(@list);
        
    random_slice_void(\@list, 3);

    @list = ( 0 .. 9 );
    
    $slice = random_slice_void(\@list, 5);

} 'no memory leaks';

done_testing();

1;
__END__
