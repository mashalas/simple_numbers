namespace PrimeNumbers3;

class Program
{

    static bool IsNumberPrime(int Candidate, int FoundCount, int[] PrimeNumbers) {
        int remainder;
        for (int i=0; i<FoundCount; i++) {
            remainder = Candidate % PrimeNumbers[i];
            if (remainder == 0)
                return false;
        }
        return true;
    }

    static int SeekPrimeNumbers(int TargetCount, bool NeedToPrint)
    {
        int FoundCount = 0;
        int [] PrimeNumbers = new int[TargetCount];
        //Console.WriteLine("len: " + PrimeNumbers.Length); return;
        PrimeNumbers[FoundCount++] = 2;
        int CurrentNumber = PrimeNumbers[FoundCount-1];
        bool Prime;
        while (FoundCount < TargetCount) {
            CurrentNumber++;
            Prime = IsNumberPrime(CurrentNumber, FoundCount, PrimeNumbers);
            if (Prime) {
                //Console.WriteLine(CurrentNumber + " is prime");
                PrimeNumbers[FoundCount++] = CurrentNumber;
            }
            else {
                //Console.WriteLine(CurrentNumber + " is not prime");
            }
            //break;
        }
        if (NeedToPrint) {
            for (int i=0; i<PrimeNumbers.Length; i++) {
                Console.WriteLine(i+1 + ") " + PrimeNumbers[i]);
            }
        }
        return PrimeNumbers[FoundCount-1];
    }

    static int Main(string[] args)
    {
        //string command = string.Empty;
        int i;
        bool NeedToPrint = false;
        int PrimeNumbersCount = -1;
        bool ok;
        for (i=0; i<args.Length; i++) {
            if (args[i] == "-print" || args[i] == "--print" || args[i] == "-p") {
                NeedToPrint = true;
                continue;
            }
            //PrimeNumbersCount = int.Parse(args[i]);
            ok = int.TryParse(args[i], out PrimeNumbersCount);
            if (!ok) {
                Console.WriteLine("Cannot convert \"" + args[i] + "\" to integer number.");
                return 1;
            }
        }

        Console.Write("Seek {0} prime numbers", PrimeNumbersCount);
        if (NeedToPrint)
            Console.Write(" and print its");
        Console.WriteLine(".");

        var BeginTime = DateTime.UtcNow;
        Console.WriteLine("BeginTime: " + BeginTime);
        int LastPrimeNumber = SeekPrimeNumbers(PrimeNumbersCount, NeedToPrint);
        var CompleteTime = DateTime.UtcNow;
        Console.WriteLine("CompleteTime: " + CompleteTime);
        TimeSpan tsDuration = CompleteTime - BeginTime;
        double Duration = tsDuration.TotalSeconds; //TotalMilliseconds - milliseconds
        Console.WriteLine("Duration: " + Duration + " seconds");
        Console.WriteLine("Last prime number = " + LastPrimeNumber);
        return 0;
    }
}
