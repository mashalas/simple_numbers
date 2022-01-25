#!/usr/bin/perl

use strict;

my $ARGUMENTS_START_SINCE = 0;
my $REQUIRED_ARGUMENTS_COUNT = 1;
my $RETCODE__NOT_ENOUGHT_ARGUMENTS = 1;
my $RETCODE__AMOUNT_IS_NOT_INTEGER = 2;

sub help()
{
  print "simple_numbers <count> [print]\n";
  print "  count   amount of simple numbers\n";
  print "  print   print found simple numbers to stdout\n";
}

sub print_results
{
my $n = 0;

  foreach my $elem(@_) {
    $n++;
    print "$n)\t$elem\n";
  }
}

sub is_number_simple
{
my $checking_number = shift;
my @numbers_list = @_;
my ($elem, $remainder);

  foreach $elem(@numbers_list) {
    $remainder = $checking_number % $elem;
    if ($remainder == 0) {
      return 0; #проверяемое число делится на одно из найденных ранее простых чисел без остатка - значит оно не является простым
    }
  }
  #проверяемое число не делится без остатка ни на одно из найденных ранее простых чисел - это число являетя простым
  return 1;
}

sub fill_simple_numbers_list
{
my $target_numbers_count = shift;
my ($ref__numbers_list) = @_;
#my @numbers_list = ();
my ($some_number, $simple);

  #push(@numbers_list, 2);
  #$some_number = $numbers_list[0] - 1;
  push(@{$ref__numbers_list}, 2);
  $some_number = ${$ref__numbers_list}[0] - 1;
  #while ($#numbers_list < $target_numbers_count-1) {
  while ($#{$ref__numbers_list} < $target_numbers_count-1) {
    $some_number += 2;
    $simple = is_number_simple($some_number, @{$ref__numbers_list});
    #print "$some_number $simple\n";
    if ($simple) {
      #push(@numbers_list, $some_number);
      push(@{$ref__numbers_list}, $some_number);
    }
    #last;
  }
  return ${$ref__numbers_list}[0];
}

#-----------------------------------main-------------------------------------
my $ARGC = $#ARGV + 1;

if ($ARGC < $ARGUMENTS_START_SINCE + $REQUIRED_ARGUMENTS_COUNT) {
  print "ERROR! Not enought arguments.\n";
  help();
  exit($RETCODE__NOT_ENOUGHT_ARGUMENTS);
}

my $target_numbers_count = $ARGV[$ARGUMENTS_START_SINCE + 0];
my $need_to_print = 0;
if ($ARGC >= $ARGUMENTS_START_SINCE + 2) {
  if ($ARGV[$ARGUMENTS_START_SINCE + 1] =~ /^print$/i) {
    $need_to_print = 1;
  }
}

print "Seek $target_numbers_count simple numbers";
print " and print its" if ($need_to_print);
print "...\n";

my @numbers_list = ();
my $start_time = time();
my $last_number = fill_simple_numbers_list($target_numbers_count, \@numbers_list);
my $stop_time = time();
if ($need_to_print) {
  print_results(@numbers_list);
}
my $duration_seconds = $stop_time - $start_time;
print "Duration: $duration_seconds seconds\n";
