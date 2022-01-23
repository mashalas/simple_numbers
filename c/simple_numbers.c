#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define ARGUMENTS_START_SINCE 1
#define REQUIRED_ARGUMENTS_COUNT 1
#define RETCODE__NOT_ENOUGHT_ARGUMENTS 1
#define RETCODE__AMOUNT_IS_NOT_INTEGER 2
#define MAX_LINE 255

void help()
{
  printf("simple_numbers <count> [print]\n");
  printf("  count   amount of simple numbers\n");
  printf("  print   print found simple numbers to stdout\n");
}

void PrintResults(int ItemsCount, int Items[])
{
  char msg[MAX_LINE];
  int i;

  for (i=0; i<ItemsCount; i++) {
    sprintf(msg, "%d)\t%d\n", i+1, Items[i]);
    printf(msg);
  }
}

short IsNumberSimple(int CheckingNumber, int NumbersCount, int NumbersList[])
{
  int i, remainder;
  for (i=0; i<NumbersCount; i++) {
    remainder = CheckingNumber % NumbersList[i];
    if (remainder == 0)
      return 0; //проверяемое число делится на одно из найденных ранее простых чисел без остатка - значит оно не является простым
  }
  //проверяемое число не делится без остатка ни на одно из найденных ранее простых чисел - это число являетя простым
  return 1;
}

int main(int argc, char **argv)
{
  if (argc < ARGUMENTS_START_SINCE+REQUIRED_ARGUMENTS_COUNT) {
    printf("ERROR! Not enought arguments.");
    help();
    exit(RETCODE__NOT_ENOUGHT_ARGUMENTS);
  }

  int TargetNumbersCount = atoi(argv[ARGUMENTS_START_SINCE+0]);

  short NeedToPrint = 0;
  if (argc >= ARGUMENTS_START_SINCE+2) {
    if (strncmp(argv[ARGUMENTS_START_SINCE+1], "print", strlen("print")) == 0) {
      NeedToPrint = 1;
    }
  }

  printf("Seek %d simple numbers...\n", TargetNumbersCount);

  int FoundNumbersCount = 0;
  int SomeNumber;
  short simple;
  int *NumbersList = (int *)malloc(sizeof(int) * TargetNumbersCount);
  time_t BeginTime = time(0);
  //suseconds_t BeginTime2
  //long beginTime = System.currentTimeMillis();

  NumbersList[FoundNumbersCount] = 2;
  SomeNumber = NumbersList[FoundNumbersCount];
  FoundNumbersCount++;
  while (FoundNumbersCount < TargetNumbersCount) {
    SomeNumber++;
    simple = IsNumberSimple(SomeNumber, FoundNumbersCount, NumbersList);
    if (simple) {
      //найдено очередное простое число - добавить его в массив простых чисел
      NumbersList[FoundNumbersCount++] = SomeNumber;
    }
  }
  //long completeTime = System.currentTimeMillis();
  //long durationMillis = completeTime - beginTime;
  //double durationSeconds = durationMillis / 1000.0;
  time_t CompleteTime = time(0);
  int DurationSeconds = (int)(CompleteTime - BeginTime);

  if (NeedToPrint)
    PrintResults(FoundNumbersCount, NumbersList);

  char msg[MAX_LINE];
  sprintf(msg, "Duration: %d seconds.", DurationSeconds);
  sprintf(msg, "%s Last simple number = %d\n", msg, NumbersList[FoundNumbersCount-1]);
  printf(msg);

  free(NumbersList);


  return 0;
}
