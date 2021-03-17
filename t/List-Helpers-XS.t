package Test::TiedArray;

use utf8;
use strict;
use warnings;

sub STORE {
    my ($self, $key, $value) = @_;
    return $self->{data}[$key] = $value;
}

sub PUSH {
    my ($self, @values) = @_;
    push(@{$self->{data}}, @values);
    $self->STORESIZE(scalar(@{$self->{data} // []}));
}

sub TIEARRAY {
    my ($class, @list) = @_;
    my $self = bless({data => []}, $class);
    return $self;
}

sub FETCHSIZE {
    my ($self) = @_;
    return $self->{count} // 0;
}

sub STORESIZE {
    my ($self, $count) = @_;
    return ($self->{count} = $count);
}

sub FETCH {
    my ($self, $index) = @_;
    return($self->{data}->[$index]);
}

sub DELETE {
    my ($self, $key) = @_;
    return splice(@{$self->{data}}, $key, 1);
}

sub CLEAR {
    my ($self) = @_;
    return($self->{data} = []);
}

sub DESTROY {
    my ($self) = @_;
    delete(@{$self}{qw/data count/});
    return;
}

1;

package main;

use utf8;
use strict;
use warnings;

use Test::LeakTrace qw/ no_leaks_ok /;
use Test::More ('import' => [qw/ done_testing is ok use_ok /]);

BEGIN { use_ok('List::Helpers::XS') };

List::Helpers::XS->import(':all');

sub check_shuffled_array;

my @list = ( 0 .. 9 );

shuffle(\@list);
is( scalar(@list), 10, "Checking the list size after shuffling" );

check_shuffled_array( [0 .. 9], \@list);

List::Helpers::XS::shuffle(@list);
is( scalar(@list), 10, "Checking the list size after shuffling" );

random_slice_void(\@list, 3);
is( scalar(@list), 3, "Checking the list size after slicing in void context" );

@list = ( 0 .. 9 );

my $slice = random_slice(\@list, 3);
is( scalar(@list), 10, "Checking the list size after slicing" );
is( scalar(@$slice), 3, "Checking the slice size" );

my @list2 = (0..4);
my @list3 = (20..27);
my @list4 = (40..45);
shuffle_multi(\@list2, undef, \@list3, \@list4);

is( scalar(@list2), 5, "Checking the size of list2 after multi-array shuffling" );
is( scalar(@list3), 8, "Checking the size of list3 after multi-array shuffling" );
is( scalar(@list4), 6, "Checking the size of list4 after multi-array shuffling" );

check_shuffled_array( [0 .. 4], \@list2);
check_shuffled_array( [20 .. 27], \@list3);
check_shuffled_array( [40 .. 45], \@list4);

undef(@list2);
undef(@list3);
undef(@list4);
undef(@list);
undef($slice);

# tied lists

my @t_list;
tie(@t_list, "Test::TiedArray");
push(@t_list, ( 0 .. 9 ) );

shuffle(\@t_list);
is( scalar(@t_list), 10, "Checking the size of tied list after shuffling" );
check_shuffled_array( [0 .. 9], \@t_list);

List::Helpers::XS::shuffle(@t_list);
is( scalar(@t_list), 10, "Checking the size of tied list after shuffling" );

random_slice_void(\@t_list, 5);
is( scalar(@t_list), 5, "Checking the size of tied list after slicing in void context" );

push(@t_list, (11 .. 15));

my $t_slice = random_slice(\@t_list, 4);
is( scalar(@t_list), 15, "Checking the size of tied after slicing" );
is( scalar(@$t_slice), 4, "Checking the size of tied slice" );

undef(@t_list);
undef($t_slice);

# check for memory leaks
no_leaks_ok {

    @list = ( 0 .. 9 );

    shuffle(\@list);
    List::Helpers::XS::shuffle(@list);
        
    random_slice_void(\@list, 3);

    @list = ( 0 .. 9 );
    
    $slice = random_slice_void(\@list, 5);

    @list2 = (0..4);
    @list3 = (20..27);
    @list4 = (40..45);
    shuffle_multi(\@list2, undef, \@list3, \@list4);

    # tied array

    @t_list = ();
    tie(@t_list, "Test::TiedArray");

    push(@t_list, ( 0 .. 2 ) );

    shuffle(\@t_list);
    List::Helpers::XS::shuffle(@t_list);

    random_slice_void(\@t_list, 1);

    undef(@t_list);
} 'no memory leaks';

done_testing();

# ====

sub check_shuffled_array {
    my ($orig, $shuffled) = @_;
    my $is_shuffled = 0;
    is(scalar($orig->@*), scalar($shuffled->@*), "Comparing the size of original and shuffled arrays");
    for my $i (0 .. $#{$orig}) {
        my $orig_val = $orig->[$i];
        my $shuffled_val = $shuffled->[$i];
        if ($orig_val != $shuffled_val) {
            $is_shuffled = 1;
            last;
        }
    }
    ok($is_shuffled, "Checking that array is shuffled");
}

1;
__END__
