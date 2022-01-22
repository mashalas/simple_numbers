
class simple_numbers {
  public static void main(String[] args)
  {
    final int ARGUMENTS_START_SINCE = 0;
    final int REQUIRED_ARGUMENTS_COUNT = 1;
    final int RETCODE__NOT_ENOUGHT_ARGUMENTS = 1;
    final int RETCODE__AMOUNT_IS_NOT_INTEGER = 2;

    if (args.length < ARGUMENTS_START_SINCE+REQUIRED_ARGUMENTS_COUNT) {
      System.out.println("ERROR! Not enought arguments.");
      help();
      System.exit(RETCODE__NOT_ENOUGHT_ARGUMENTS);
    }

    int targetNumbersCount = 0;
    try {
      targetNumbersCount = Integer.parseInt(args[ARGUMENTS_START_SINCE+0]);
    }
    catch (Exception e) {
      String msg = String.format("ERROR! Cannot parse \"%s\" as integer.", args[ARGUMENTS_START_SINCE+0]);
      System.out.println(msg);
      help();
      System.exit(RETCODE__AMOUNT_IS_NOT_INTEGER);
    }

    boolean needToPrint = false;
    if (args.length >= ARGUMENTS_START_SINCE+2) {
      if (args[ARGUMENTS_START_SINCE+1].equalsIgnoreCase("print")) {
        needToPrint = true;
      }
    }

    String msg;
    msg = String.format("Seek %s simple numbers...", targetNumbersCount);
    System.out.println(msg);

    int foundNumbersCount = 0;
    int someNumber;
    boolean simple;
    int[] NumbersList;
    long beginTime = System.currentTimeMillis();

    NumbersList = new int[targetNumbersCount];
    NumbersList[foundNumbersCount] = 2;
    someNumber = NumbersList[foundNumbersCount];
    foundNumbersCount++;
    while (foundNumbersCount < targetNumbersCount) {
      someNumber++;
      simple = isNumberSimple(someNumber, foundNumbersCount, NumbersList);
      if (simple) {
        //найдено очередное простое число - добавить его в массив простых чисел
        NumbersList[foundNumbersCount++] = someNumber;
      }
    }
    long completeTime = System.currentTimeMillis();
    long durationMillis = completeTime - beginTime;
    double durationSeconds = durationMillis / 1000.0;

    if (needToPrint)
      printResults(NumbersList);

    msg = "Duration: " +  Double.toString(durationSeconds) + " seconds.";
    msg += " " + "Last simple number = " + Integer.toString(NumbersList[foundNumbersCount-1]);
    System.out.println(msg);
    System.exit(0);
  }

  public static void help()
  {
        System.out.println("simple_numbers <count> [print]");
        System.out.println("  count   amount of simple numbers");
        System.out.println("  print   print found simple numbers to stdout");
  }

  public static void printResults(int[] Items)
  {
    String msg;
    int n = 0;
    for (Integer x:Items) {
        n++;
        msg = Integer.toString(n) + ")\t" + Integer.toString(x);
        System.out.println(msg);
    }
  }

  public static boolean isNumberSimple(int checkingNumber, int numbersCount, int[] NumbersList)
  {
    int remainder;
    for (int i=0; i<numbersCount; i++) {
      remainder = checkingNumber % NumbersList[i];
      if (remainder == 0)
        return false; //проверяемое число делится на одно из найденных ранее простых чисел без остатка - значит оно не является простым
    }
    //проверяемое число не делится без остатка ни на одно из найденных ранее простых чисел - это число являетя простым
    return true;
  }
}
