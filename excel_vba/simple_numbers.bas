
'int    2 bytes: -32 768 .. 32 767
'long   4 bytes: -2 147 483 648 .. 2 147 483 647

Function IsNumberSimple(CheckingNumber As Long, NumbersCount As Long, NumbersList() As Long) As Boolean
Dim i As Long
Dim remainder As Long

    For i = 0 To NumbersCount - 1
        remainder = CheckingNumber Mod NumbersList(i)
        If remainder = 0 Then
            IsNumberSimple = False
            Exit Function
        End If
    Next i
    IsNumberSimple = True
End Function



Function FillSimpleNumbersList(TargetNumbersCount As Long, NumbersList() As Long) As Long
Dim FoundNumbersCount As Long
Dim simple As Boolean
Dim SomeNumber As Long

    NumbersList(0) = 2
    FoundNumbersCount = 1
    SomeNumber = NumbersList(0) - 1
    While FoundNumbersCount < TargetNumbersCount
        SomeNumber = SomeNumber + 2
        simple = IsNumberSimple(SomeNumber, FoundNumbersCount, NumbersList)
        If simple Then
            NumbersList(FoundNumbersCount) = SomeNumber
            FoundNumbersCount = FoundNumbersCount + 1
        End If
    Wend
    FillSimpleNumbersList = NumbersList(FoundNumbersCount - 1)
End Function

Sub PrintResults(ItemsCount As Long, Items() As Long, WorksheetNumber As Integer)
Const ColumnNumber = 1
Const StartRowNumber = 1
Dim i As Long

    For i = 0 To ItemsCount - 1
        ThisWorkbook.Worksheets(WorksheetNumber).Cells(StartRowNumber + i, ColumnNumber).Value = Str(Items(i))
    Next i
End Sub

Sub StartCalc()
Const ActiveWorksheet = 1
Dim NumbersList() As Long
Dim TargetNumbersCount As Long
Dim LastSimpleNumber As Long
Dim s As String
Dim NeedToPrint As Boolean
Dim Answer As Variant
Dim BeginDateTime As Date
Dim EndDateTime As Date
Dim BeginDateTimeStr As String
Dim DurationSeconds As Long
Dim msg As String
  
    s = InputBox("Enter amount of simple numbers:")
    If Len(s) = 0 Then
        'либо введена пустая строка, либо нажата отмена
        Exit Sub
    End If
    On Error GoTo Err_IsNotNumber 'при возникновении ошибки при конвертировании строки в число перейти в обработчик этой ошибки
    TargetNumbersCount = CLng(s)
    On Error GoTo 0 'отменить переход в обработчик ошибок; следующие ошибки будут обрабатываться в общем порядке
        
    Answer = MsgBox("Print found numbers ?", vbYesNoCancel + vbQuestion + vbDefaultButton2)
    Select Case (Answer)
        Case vbYes
            NeedToPrint = True
        Case vbNo
            NeedToPrint = False
        Case vbCancel
            Exit Sub
    End Select
    ThisWorkbook.Worksheets(ActiveWorksheet).Range("A1:A1048576").Clear 'очистить первый столбец
    
    ReDim NumbersList(TargetNumbersCount) 'задать длину массива
    BeginDateTime = Now()
    LastSimpleNumber = FillSimpleNumbersList(TargetNumbersCount, NumbersList)
    EndDateTime = Now()
    DurationSeconds = DateDiff("s", BeginDateTime, EndDateTime)
    BeginDateTimeStr = Format(BeginDateTime, "yyyy-mm-dd hh:nn:ss")
    EndDateTimeStr = Format(EndDateTime, "yyyy-mm-dd hh:nn:ss")
    
    If NeedToPrint Then
        Call PrintResults(TargetNumbersCount, NumbersList, ActiveWorksheet)
    End If
    msg = "Duration: " & CStr(DurationSeconds) & " seconds"
    msg = msg & vbCrLf & "Last simple number = " & CStr(LastSimpleNumber)
    msg = msg & vbCrLf & "Begin at [" & BeginDateTimeStr & "]"
    msg = msg & vbCrLf & "Complete at [" & EndDateTimeStr & "]"
    Call MsgBox(msg, vbOKOnly + vbInformation)
    Exit Sub 'перед началом блока обработки ошибок завершить работу процедуры/функции, иначе начнёт выполняться код обработчика ошибок
    
Err_IsNotNumber:
    'Не удалось из строки получить целое число с количеством простых чисел
    Call MsgBox("""" & s & """ is not integer number", vbOKOnly + vbCritical)
    Exit Sub
End Sub
