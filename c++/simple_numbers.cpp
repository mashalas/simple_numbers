
#include <iostream>
#include <vector>
#include <algorithm>
#include <math.h>

//using std;

const int ARGUMENTS_START_SINCE=1;
const int REQUIRED_ARGUMENTS_COUNT=1;
const int RETCODE__NOT_ENOUGHT_ARGUMENTS=1;
const int RETCODE__AMOUNT_IS_NOT_INTEGER=2;

void help()
{
    std::cout << "simple_numbers <count> [print]" << std::endl;
    std::cout << "  count   amount of simple numbers" << std::endl;
    std::cout <<"  print   print found simple numbers to stdout" << std::endl;
}

template <typename T> void PrintResults(std::vector<T> Items)
{
    int n = 0;
    for (T x : Items) {
        std::cout << ++n << ")\t" << x << std::endl;
    }
}

template <typename T> bool IsNumberSimple(T CheckingNumber, std::vector<T> NumbersList)
{
    T remainder;
    for (T x : NumbersList) {
        remainder = CheckingNumber % x;
        if (remainder == 0)
            return false; //проверяемое число делится на одно из найденных ранее простых чисел без остатка - значит оно не является простым
    }
    //проверяемое число не делится без остатка ни на одно из найденных ранее простых чисел - это число являетя простым
    return true;
}

template <typename T> T FillSimpleNumbersList(T TargetNumbersCount, std::vector<T> &NumbersList)
{
    bool simple;
    NumbersList.clear();
    NumbersList.push_back(2);
    T SomeNumber = NumbersList[0] - 1;
    while (NumbersList.size() < TargetNumbersCount) {
        SomeNumber += 2;
        simple = IsNumberSimple(SomeNumber, NumbersList);
        if (simple)
            NumbersList.push_back(SomeNumber);
    }
    return NumbersList.back();
}

int main(int argc, char *argv[])
{
    const int Roinding = 1000;
    if (argc < ARGUMENTS_START_SINCE+REQUIRED_ARGUMENTS_COUNT) {
        std::cout << "ERROR! Not enought arguments." << std::endl;
        help();
        return RETCODE__NOT_ENOUGHT_ARGUMENTS;
    }

    int TargetNumbersCount = atoi(argv[ARGUMENTS_START_SINCE+0]);

    bool NeedToPrint = false;
    if (argc >= ARGUMENTS_START_SINCE+2) {
        std::string SecondArgument(argv[ARGUMENTS_START_SINCE+1]); //variant 1
        //std::string SecondArgument;  SecondArgument.assign(argv[ARGUMENTS_START_SINCE+1], strlen(argv[ARGUMENTS_START_SINCE+1])); //variant 2
        std::transform(SecondArgument.begin(), SecondArgument.end(), SecondArgument.begin(), tolower);
        if (SecondArgument == "print")
            NeedToPrint = true;
    }

    std::cout << "Seek " << TargetNumbersCount << " simple numbers";
    if (NeedToPrint)
        std::cout << " and print them";
    std::cout << " ..." << std::endl;

    std::vector<int> NumbersList;
    const clock_t BeginTime = clock();
    int LastNumber = FillSimpleNumbersList(TargetNumbersCount, NumbersList);
    //std::cout << NumbersList[0] << std::endl;
    const clock_t CompleteTime = clock();
    double Duration = (double)(CompleteTime - BeginTime) / CLOCKS_PER_SEC;
    Duration = round(Duration * Roinding) / Roinding;
    if (NeedToPrint)
        PrintResults(NumbersList);
    std::cout << "Duration: " << Duration << " seconds.";
    std::cout << " Last simple number = " << LastNumber << std::endl;
    return 0;
}
