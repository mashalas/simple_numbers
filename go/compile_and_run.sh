#!/usr/bin/sh

# запуск без компиляции
# go run simple_numbers.go 10 print

# компиляция
go build simple_numbers.go
if [ $? -eq 0 ]
then
  ./simple_numbers 50000
fi
