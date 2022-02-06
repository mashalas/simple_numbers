#!/usr/bin/env perl

use strict;

my $ARGUMENTS_START_SINCE = 0;
my $REQUIRED_ARGUMENTS_COUNT = 1;
my $RETCODE__NOT_ENOUGHT_ARGUMENTS = 1;
my $RETCODE__WRONG_AMOUNT_OF_SIMPLE_NUMBERS = 2;

sub help()
{
  print <<EOF
simple_numbers.pl [-h--help] [-p|--print[=filename]] <count>
  -h, --help             show this help and quit
  -p, --print            print found simple numbers to \"filename\" if specified or to STDOUT if no
  count                  target amount of simple numbers
EOF
}

sub print_array
{
my $filename = shift;
my @items = @_;
my $n = 0;

  if ($filename ne "") {
    # print array to file
    open(F, "> $filename");
    foreach my $elem(@items) {
      $n++;
      print F "$n)\t$elem\n";
    }
    close(F);
  }
  else {
    # print array to STDOUT
    foreach my $elem(@items) {
      $n++;
      print "$n)\t$elem\n";
    }
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
      return 0;
    }
  }
  return 1;
}

sub get_simple_numbers_list
{
my $target_numbers_count = shift;
my @numbers_list = ();
my ($some_number, $simple);

  push(@numbers_list, 2);
  $some_number = $numbers_list[0] - 1;
  while ($#numbers_list < $target_numbers_count-1) {
    $some_number += 2;
    $simple = is_number_simple($some_number, @numbers_list);
    if ($simple) {
      push(@numbers_list, $some_number);
    }
  }
  return @numbers_list;
}

sub init_default_params  #($\%)
{
  my $ref = shift;
  $ref->{help} = 0;
  $ref->{print} = 0;
  $ref->{filename} = "";
  $ref->{target_numbers_count} = -1;
}

sub parse_arguments
{
my $ref_argv = shift;
my $ref_program_params = shift;
my $s;
my ($arg, $arg_name, $arg_value);
my $arg_sn = 0;

  init_default_params($ref_program_params);
  foreach $arg(@{$ref_argv}) {
    if ($arg =~ /^-{1,2}\S+/) {
      #named argument
      ($arg_name, $arg_value) = ($arg =~ /^-{1,2}([a-zA-Z]+)=?(.*)/);
      if ($arg_name eq "p" || $arg_name eq "print") {
        $ref_program_params->{print} = 1;
        if ($arg_value ne "") {
          $ref_program_params->{filename} = $arg_value;
        }
        next;
      }
      if ($arg_name eq "h" || $arg_name eq "help") {
        $ref_program_params->{help} = 1;
        next;
      }
      print "Warning: unknown argument \"$arg\".\n";
      next;
    } # named argument
    # sequentional arguments
    $ref_program_params->{target_numbers_count} = $arg + 0 if ($arg_sn == 0);
    $arg_sn++;
  } #foreach arg
}

#-----------------------------------main-------------------------------------
my $ARGC = $#ARGV + 1;

if ($ARGC < $ARGUMENTS_START_SINCE + $REQUIRED_ARGUMENTS_COUNT) {
  print "ERROR! Not enought arguments.\n";
  help();
  exit($RETCODE__NOT_ENOUGHT_ARGUMENTS);
}

my %program_params = {};
parse_arguments(\@ARGV, \%program_params); # send to function reference to array and reference to hash; fill reference to hash in function

if ($program_params{help}) {
  # help is required
  help();
  exit(0);
}

if ($program_params{target_numbers_count} < 0) {
  # wrong target amount of simple numbers
  print "ERROR! Wrong amount of simple numbers.\n";
  help();
  exit($RETCODE__WRONG_AMOUNT_OF_SIMPLE_NUMBERS);
}

print "Seek $program_params{target_numbers_count} simple numbers";
if ($program_params{print}) {
  print " and print its";
  print "to file \"$program_params{filename}\"" if ($program_params{filename} ne "");
}
print "...\n";

my $start_time = time();
my @numbers_list = get_simple_numbers_list($program_params{target_numbers_count});
my $last_number = $numbers_list[$#numbers_list];
my $stop_time = time();
my $duration_seconds = $stop_time - $start_time;
if ($program_params{print}) {
  print_array($program_params{filename}, @numbers_list);
}
print "Duration: $duration_seconds seconds. ";
print " Last simple number = $last_number\n";
