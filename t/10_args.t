use strict;
use warnings;
use Test::More;
use Test::Mock::Guard qw(mock_guard);

package Some::Class;

sub new { bless {} => shift }
sub foo { "foo" }

package main;

{
    # class
    my $guard = mock_guard('Some::Class' => { foo => sub {} });
    my $obj = Some::Class->new;
    is_deeply $guard->args('Some::Class', 'foo') => [];
    $obj->foo('bar','baz');
    $obj->foo();
    $obj->foo(1,3);
    is_deeply $guard->args('Some::Class', 'foo'),[['bar','baz'],[],[1,3]];
}

{
    # object
    my $obj = Some::Class->new;
    my $guard = mock_guard($obj => { foo => sub {}});
    is_deeply $guard->args($obj, 'foo'),[['a','b'],[3,4]];
    $obj->foo('a','b');
    $obj->foo(3,4);
    $obj->foo();
    is_deeply $guard->args($obj, 'foo'),[['a','b'],[3,4],[]];
}

done_testing;
