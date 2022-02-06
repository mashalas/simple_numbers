program simple_numbers;

uses crt, sysutils;

const
  ARGUMENTS_START_SINCE = 1;
  REQUIRED_ARGUMENTS_COUNT = 1;
  RETCODE__NOT_ENOUGHT_ARGUMENTS = 1;
  RETCODE__WRONG_AMOUNT_OF_SIMPLE_NUMBERS = 2;

type
  TProgramParams = record
    help: boolean;
    print: boolean;
    filename: ShortString;
    TargetNumbersCount: LongWord;
  end;
  
var
  NumbersList: array of LongWord;
  BeginDateTime, CompleteDateTime: TDateTime;
  Duration: double;
  LastSimpleNumber: LongWord;
  ProgramParams: TProgramParams;


procedure help();
begin
  writeln('simple_numbers [-h|--help] [-p|--print[=filename]][TargetNumbersCount] <print>');
  writeln('  -h, --help             show this help and quit');
  writeln('  -p, --print            print found simple numbers to "filename" if specified or to STDOUT if no');
  writeln('  count                  target amount of simple numbers');
end;

procedure PrintArray(ItemsCount: LongWord; Items: array of LongWord; FileName: ShortString);
var
  i: LongWord;
  f: TextFile;
begin
  if FileName <> '' then
    begin
      assign(f, FileName);
      rewrite(f);
      append(f);
      for i:=0 to ItemsCount-1 do
        begin
          write(f, i+1);
          write(f, ') ');
          writeln(f, Items[i]);
        end;
      close(f);
    end
  else
    begin
      for i:=0 to ItemsCount-1 do
        begin
          write(i+1);
          write(') ');
          writeln(Items[i]);
        end;
    end;
end;

function IsNumberSimple(CheckingNumber: LongWord; NumbersCount: LongWord; NumbersList: array of LongWord): boolean;
var
  i: LongWord;
  remainder: LongWord;
begin
  IsNumberSimple := true;
  for i:=0 to NumbersCount-1 do
    begin
      remainder := CheckingNumber mod NumbersList[i];
      if remainder = 0 then
        begin
          IsNumberSimple := false;
          break;
        end;
    end;
end;

function FillSimpleNumbersList(TargetNumbersCount: LongWord; var NumbersList: array of LongWord): LongWord;
var
  FoundNumbersCount: LongWord;
  simple: boolean;
  SomeNumber: LongWord;
begin
  NumbersList[0] := 2;
  FoundNumbersCount := 1;
  SomeNumber := NumbersList[0] - 1;
  while FoundNumbersCount < TargetNumbersCount do
    begin
      Inc(SomeNumber, 2);
      simple := IsNumberSimple(SomeNumber, FoundNumbersCount, NumbersList);
      if simple then
        begin
          NumbersList[FoundNumbersCount] := SomeNumber;
          Inc(FoundNumbersCount);
        end;
    end;
  FillSimpleNumbersList := NumbersList[FoundNumbersCount - 1];
end;

function InitDefaultParams: TProgramParams;
//var
//  ProgramParams: TPr
begin
  InitDefaultParams.help := false;
  InitDefaultParams.print := false;
  InitDefaultParams.filename := '';
  InitDefaultParams.TargetNumbersCount := 0;
end;

function SplitArgumentToNameAndValue(s: ShortString; var Name: ShortString; var Value: ShortString): boolean;
var
  i: integer;
  ReadingNameNow: boolean;
begin
  SplitArgumentToNameAndValue := true;
  Name := '';
  Value := '';
  ReadingNameNow := true;
  i := 0;
  for i:=1 to Length(s) do
    begin
      if (i = 1) then
        begin
          if (s[i] <> '-') then
            begin
              //the first symbol should be minus
              //первым символом должен быть знак минуса
              SplitArgumentToNameAndValue := false;
              break;
            end;
          continue;
        end;
      if (i = 2) and (s[i] = '-') then
        continue; //second minus (long name parameter) второй минус (длинное имя параметра)
      if (ReadingNameNow) and (s[i] = '=') then
        begin
          //name reading is comleted, value will be next
          //закончили читать имя параметра, дальше будет значение параметра
          if Length(Name) = 0 then
            begin
              //name was not specified
              //имя не было указано
              SplitArgumentToNameAndValue := false;
              break;
            end;
          ReadingNameNow := false;
          continue;
        end;
      if ReadingNameNow then
        Name := Name + s[i]
      else
        Value := Value + s[i];
    end;
end;

procedure ParseArguments(var ProgramParams: TProgramParams);
var
  i: LongInt;
  Arg: ShortString;
  ArgName, ArgValue: ShortString;
  ok: boolean;
  ArgSN: integer;
begin
  ProgramParams := InitDefaultParams;
  ArgSN := 0;
  for i:=ARGUMENTS_START_SINCE to ParamCount do
    begin
      Arg := ParamStr(i);
      //writeln(' --- ' + Arg + ' ---');
      if length(Arg) >= 2 then
        begin
          if Arg[1] = '-' then
            begin
              //named parameter
              //именованный параметр
              ok := SplitArgumentToNameAndValue(Arg, ArgName, ArgValue);
              if not ok then
                continue;
              if (ArgName = 'p') or (ArgName = 'print') then
                begin
                  ProgramParams.print := true;
                  if ArgValue <> '' then
                    ProgramParams.filename := ArgValue;
                  continue;
                end;
              if (ArgName = 'h') or (ArgName = 'help') then
                begin
                  ProgramParams.help := true;
                  continue;
                end;
              writeln('WARNING! Unknown argument "' + Arg + '".');
              continue; //unknown argument  неизвестный параметр
            end;
        end;
      if ArgSN = 0 then
        ProgramParams.TargetNumbersCount := StrToInt(Arg);
      Inc(ArgSN);
    end;
end;

BEGIN
  //clrscr();

  if ParamCount < REQUIRED_ARGUMENTS_COUNT then
    begin
      writeln('ERROR! Not enought arguments.');
      help();
      halt(RETCODE__NOT_ENOUGHT_ARGUMENTS);
    end;

  ParseArguments(ProgramParams);

  if ProgramParams.help then
    begin
      help();
      halt(0);
    end;

  if ProgramParams.TargetNumbersCount = 0 then
    begin
      writeln('ERROR! Wrong amount of simple numbers.');
      halt(RETCODE__WRONG_AMOUNT_OF_SIMPLE_NUMBERS);
    end;

  write('Seek ', ProgramParams.TargetNumbersCount, ' simple numbers');
  if ProgramParams.print then
    begin
      write(' and print its');
      if ProgramParams.filename <> '' then
        write(' to file "' + ProgramParams.filename + '".');
    end;
  writeln('...');

  SetLength(NumbersList, ProgramParams.TargetNumbersCount);
  BeginDateTime := Now();
  LastSimpleNumber := FillSimpleNumbersList(ProgramParams.TargetNumbersCount, NumbersList);
  CompleteDateTime := Now();
  Duration := (CompleteDateTime - BeginDateTime)*24*3600;

  if ProgramParams.print then
    PrintArray(ProgramParams.TargetNumbersCount, NumbersList, ProgramParams.filename);

  writeln('Duration: ', Duration:1:3, ' seconds.');
  writeln('Last simple number = ', LastSimpleNumber);
END.
