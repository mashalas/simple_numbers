#!/usr/bin/env python3

import sys
import time

ARGUMENTS_START_SINCE = 1
REQUIRED_ARGUMENTS_COUNT = 1
RETCODE__NOT_ENOUGHT_ARGUMENTS = 1
RETCODE__AMOUNT_IS_NOT_INTEGER = 2


def help():
    print("simple_numbers <count> [print]");
    print("  count   amount of simple numbers");
    print("  print   print found simple numbers to stdout");


def print_results(Items):
    for i in range(len(Items)):
        msg = str(i+1) + ")\t" + str(Items[i])
        print(msg);


def is_number_simple(checking_number, numbers_list):
    for x in numbers_list:
      remainder = checking_number % x
      if remainder == 0:
        return False; #проверяемое число делится на одно из найденных ранее простых чисел без остатка - значит оно не является простым
    #проверяемое число не делится без остатка ни на одно из найденных ранее простых чисел - это число являетя простым
    return True;


if __name__ == "__main__":
    if len(sys.argv) < ARGUMENTS_START_SINCE + REQUIRED_ARGUMENTS_COUNT:
        print("ERROR! Not enought arguments")
        help()
        exit(RETCODE__NOT_ENOUGHT_ARGUMENTS)

    target_numbers_count = 0
    try:
        target_numbers_count = int(sys.argv[ARGUMENTS_START_SINCE+0])
    except:
        print("ERROR! Cannot parse \"{}\" as integer." . format(sys.argv[ARGUMENTS_START_SINCE+0]))
        help()
        exit(RETCODE__AMOUNT_IS_NOT_INTEGER)

    need_to_print = False
    if len(sys.argv) >= ARGUMENTS_START_SINCE+2:
        if sys.argv[ARGUMENTS_START_SINCE+1].lower() == "print":
            need_to_print = True

    print("Seek {} simple numbers..." . format(target_numbers_count))

    numbers_list = [2,]
    some_number = numbers_list[0]
    begin_time = time.time()
    while len(numbers_list) < target_numbers_count:
      some_number += 1
      simple = is_number_simple(some_number, numbers_list)
      if simple:
        #найдено очередное простое число - добавить его в массив простых чисел
        numbers_list.append(some_number)

    complete_time = time.time();
    duration_seconds = complete_time - begin_time

    if need_to_print:
      print_results(numbers_list)

    msg = "Duration: {:.3f} seconds." . format(duration_seconds)
    msg += " " + "Last simple number = " + str(numbers_list[len(numbers_list)-1])
    print(msg)
