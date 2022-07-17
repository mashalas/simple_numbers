SET SERVEROUTPUT ON


-- create or replace type numb_arr_type as table of number(10) index by binary_integer;
create or replace type NumbersListType as table of number;
/

create or replace function IsNumberSimple(CheckingNumber in number, NumbersCount in number, NumbersList in NumbersListType) return boolean
as
  i number;
  remainder_value number; -- ¬ oracle есть функци€ с именем remainder
begin
  for i in 1..NumbersCount loop
    remainder_value := mod(CheckingNumber, NumbersList(i));
    if remainder_value = 0 then
      return false;
    end if;
  end loop;
  return true;
end;
/

create or replace function FillSimpleNumbersList(TargetNumbersCount in number, NumbersList in out NumbersListType) return number
as
  FoundNumbersCount number;
  SomeNumber number;
  Simple_Flag boolean;
begin
  NumbersList(1) := 2;
  FoundNumbersCount := 1;
  SomeNumber := NumbersList(1) - 1;
  while FoundNumbersCount < TargetNumbersCount
  loop
    SomeNumber := SomeNumber + 2;
    Simple_Flag := IsNumberSimple(SomeNumber, FoundNumbersCount, NumbersList);
    if Simple_Flag then
      NumbersList(FoundNumbersCount+1) := SomeNumber;
      FoundNumbersCount := FoundNumbersCount + 1;
    end if;
  end loop;
  return NumbersList(FoundNumbersCount); -- вернуть последнее найденное число
end;
/

create or replace procedure PrintResults(ItemsCount in number, Items in NumbersListType)
as
  i number;
begin
  for i in 1..ItemsCount loop
    dbms_output.put_line(i || ') ' || Items(i));
  end loop;
end;
/

create or replace procedure SeekSimpleNumbers(TargetNumbersCount in number, NeedToPrint in boolean)
as
  SimpleNumbers NumbersListType;
  LastSimpleNumber number;
  
  begin_hour number;
  begin_minute number;
  begin_second number;
  begin_time_int number;
  begin_time_str varchar2(32);
  
  end_hour number;
  end_minute number;
  end_second number;
  end_time_int number;
  end_time_str varchar2(32);
  
  DurationSeconds number;
begin
  dbms_output.put('Seek ' || TargetNumbersCount || ' simple numbers');
  if NeedToPrint then
    dbms_output.put(' and print its');
  end if;
  dbms_output.put_line('...');
  SimpleNumbers := NumbersListType();
  SimpleNumbers.extend(TargetNumbersCount);
  
  -- врем€ начала
  begin_hour := to_number(to_char(sysdate, 'HH24'));
  begin_minute := to_number(to_char(sysdate, 'MI'));
  begin_second := to_number(to_char(sysdate, 'SS'));
  begin_time_int := 3600*begin_hour + 60*begin_minute + begin_second;
  begin_time_str := begin_hour || ':' || begin_minute || ':' || begin_second;
  dbms_output.put_line('Begins at ' || begin_time_str);
  
  LastSimpleNumber := FillSimpleNumbersList(TargetNumbersCount, SimpleNumbers);
  
  -- врем€ завершени€
  end_hour := to_number(to_char(sysdate, 'HH24'));
  end_minute := to_number(to_char(sysdate, 'MI'));
  end_second := to_number(to_char(sysdate, 'SS'));
  end_time_int := 3600*end_hour + 60*end_minute + end_second;
  end_time_str := end_hour || ':' || end_minute || ':' || end_second;
  dbms_output.put_line('Ends at ' || end_time_str);
  
  -- продолжительность вычислений в секундах
  DurationSeconds := end_time_int - begin_time_int;
  if DurationSeconds < 0 then
    -- начали до полуночи, завершили после полуночи
    DurationSeconds := 3600*24 + DurationSeconds;
  end if;
  
  if NeedToPrint then
    -- нужно вывести список найденных простых чисел
    PrintResults(TargetNumbersCount, SimpleNumbers);
  end if;

  dbms_output.put_line('Duration: ' || DurationSeconds || ' seconds.');
  dbms_output.put_line('Last simple number = ' || LastSimpleNumber);
end;
/

declare
begin
  -- SeekSimpleNumbers(10, true);
  SeekSimpleNumbers(2000, false);
end;

-- номер строки с ошибкой отсчитываетс€ от ключевого слова begin тела функции (begin = строка с номером 1)
