//+------------------------------------------------------------------+
//|                                               simple_numbers.mq5 |
//|                                                  Mashalas Alexey |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Mashalas Alexey"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs
//--- input parameters
input int   inp_TargetNumbersCount=10;
input bool  inp_PrintToFile=false;

void PrintResult(string FileName, int NumbersCount, const int &NumbersList[])
{
   int f = FileOpen(FileName, FILE_WRITE|FILE_ANSI|FILE_TXT);
   for (int i=0; i<NumbersCount; i++) {
      FileWriteString(f, IntegerToString(i+1) + ")\t" + IntegerToString(NumbersList[i]) + "\n");
   }
   FileClose(f);
}

bool IsNumberSimple(int CheckingNumber, int NumbersCount, const int &NumbersList[])
{
   int remainder;
   for (int i=0; i<NumbersCount; i++) {
      remainder = CheckingNumber % NumbersList[i];
      if (remainder == 0)
         return false; //проверяемое число делится на одно из найденных ранее простых чисел без остатка - значит оно не является простым
   }
  //проверяемое число не делится без остатка ни на одно из найденных ранее простых чисел - это число являетя простым
  return true;
}

int FillSimpleNumbersList(int TargetNumbersCount, int &NumbersList[])
{
   bool simple;
   int FoundNumbersCount = 0;
   NumbersList[FoundNumbersCount] = 2;
   int SomeNumber = NumbersList[FoundNumbersCount] - 1;
   FoundNumbersCount++;
   while (FoundNumbersCount < TargetNumbersCount) {
      SomeNumber += 2;
      simple = IsNumberSimple(SomeNumber, FoundNumbersCount, NumbersList);
      if (simple)
         NumbersList[FoundNumbersCount++] = SomeNumber;
   }
   return NumbersList[FoundNumbersCount-1];
}

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   const string ReportFileName = "simple_numbers.txt";
   string msg;
   msg = "Seek " + IntegerToString(inp_TargetNumbersCount) + " simple numbers";
   if (inp_PrintToFile)
      msg += " and print them";
   msg += "...";
   Print(msg);
   
   int NumbersList[];
   ArrayResize(NumbersList, inp_TargetNumbersCount);
   datetime BeginTime = TimeLocal();
   int LastNumber = FillSimpleNumbersList(inp_TargetNumbersCount, NumbersList);
   datetime CompleteTime = TimeLocal();
   int Duration = (int)(CompleteTime - BeginTime);
   
   if (inp_PrintToFile)
      PrintResult(ReportFileName, inp_TargetNumbersCount, NumbersList);
   
   msg = "Duration: " + IntegerToString(Duration) + " seconds.";
   msg += " Last simple number = " + IntegerToString(LastNumber);
   Print(msg);
   
   ArrayFree(NumbersList);
  }
//+------------------------------------------------------------------+
