package main

//import "fmt"
//import "time"
import (
    "fmt"
    "os"
    "time"
    "strconv"
)

const ARGUMENTS_START_SINCE int = 1
const REQUIRED_ARGUMENTS_COUNT int = 1

func PrintArray(NumbersList []int) {
    for i:=0; i<len(NumbersList); i++ {
	fmt.Println(fmt.Sprintf("%d) %d", i+1, NumbersList[i]))
    }
}

func IsNumberSimple(CheckingNumber, NumbersCount int, NumbersList []int) bool {
    var remainder int
    for i:=0; i<NumbersCount; i++ {
	remainder = CheckingNumber % NumbersList[i]
	if remainder == 0 {
	    return false
	}
    }
    return true
}

func FillSimpleNumbersList(TargetNumbersCount int, NumbersList []int) int {
    var SomeNumber int
    var FoundNumbersCount int = 1
    var simple bool
    NumbersList[0] = 2
    SomeNumber = NumbersList[0] - 1
    for ; FoundNumbersCount < TargetNumbersCount; {
	SomeNumber += 2
	simple = IsNumberSimple(SomeNumber, FoundNumbersCount, NumbersList)
	if simple {
	    NumbersList[FoundNumbersCount] = SomeNumber
	    FoundNumbersCount += 1
	}
	//fmt.Println(SomeNumber, simple)
    }
    return NumbersList[FoundNumbersCount-1]
}

func help() {
    fmt.Println("simple_numbers <count> [print]")
    fmt.Println("  count    amount of prime numbers")
    fmt.Println("  print    print found prime numbers to stdout")
}

func main() {
    if len(os.Args) < ARGUMENTS_START_SINCE+REQUIRED_ARGUMENTS_COUNT {
	fmt.Println("ERROR! Not enought arguments.")
	help()
	return
    }
    var TargetNumbersCount, err = strconv.Atoi(os.Args[1])
    if err != nil {
	fmt.Println("ERROR! Cannot convert first argument to integer value.")
	return
    }
    var NeedToPrint bool = false
    if len(os.Args) >= 3 {
	NeedToPrint = os.Args[2] == "print"
    }

    var msg string
    msg = fmt.Sprintf("Seek %d prime numbers", TargetNumbersCount)
    if NeedToPrint {
	msg = fmt.Sprintf("%s and print its", msg)
    }
    msg += "."
    fmt.Println(msg)
    
    var NumbersList []int
    NumbersList = make([]int, TargetNumbersCount)
    var BeginTime = time.Now()
    fmt.Println("Begins at: ", BeginTime.Format("2006-01-02 15:04:05"))
    var LastSimpleNumber = FillSimpleNumbersList(TargetNumbersCount, NumbersList)
    var CompleteTime = time.Now()
    fmt.Println("Complete at: ", CompleteTime.Format("2006-01-02 15:04:05"))
    var DurationMilliseconds = CompleteTime.Sub(BeginTime)
    var DurationSeconds float64 = float64(DurationMilliseconds / time.Millisecond)/1000
    if NeedToPrint {
	PrintArray(NumbersList)
    }
    fmt.Printf("Duration: %.3f seconds. ", DurationSeconds)
    fmt.Println("Last simple number = ", LastSimpleNumber)
    return
}
