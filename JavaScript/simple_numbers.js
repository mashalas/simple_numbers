function roundN(x, n)
{
  var mn = 1;
  for (var i=1; i<=n; i++)
    mn *= 10;
  x = x * mn;
  x = Math.round(x);
  x = x / mn;
  return x;
}

function isNumberSimple(checkingNumber, NumbersList)
{
  let remainder = undefined;
  //NumbersList.forEach
  for (let i=0; i<NumbersList.length; i++) {
    remainder = checkingNumber % NumbersList[i];
    if (remainder == 0)
      return false; //проверяемое число делится на одно из найденных ранее простых чисел без остатка - значит оно не является простым
  }
  //проверяемое число не делится без остатка ни на одно из найденных ранее простых чисел - это число являетя простым
  return true;
}

function fillSimpleNumbersList(targetNumbersCount, OBJ_NumbersList)
{
  let simple = undefined;
  OBJ_NumbersList.NumbersList = [];
  OBJ_NumbersList.NumbersList.push(2);
  let someNumber = OBJ_NumbersList.NumbersList[0] - 1;
  while (OBJ_NumbersList.NumbersList.length < targetNumbersCount) {
    someNumber += 2;
    //alert(someNumber);
    simple = isNumberSimple(someNumber, OBJ_NumbersList.NumbersList);
    if (simple)
      OBJ_NumbersList.NumbersList.push(someNumber);
  }
  return OBJ_NumbersList.NumbersList[OBJ_NumbersList.NumbersList.length-1];
}

function printResults(NumbersList, Receiver)
{
  let s;
  let sn;
  for (let i=0; i<NumbersList.length; i++) {
    sn = i + 1;
    s = sn.toString() + ')';
    s += ' ' + NumbersList[i].toString();
    s += '<br />';
    Receiver.innerHTML += s;
  }
}

function seekSimpleNumbers(targetNumbersCount, needToPrint, DurationContainer, NumbersListContainer)
{
  const DIGITS_AFTER_DOT = 3;
  DurationContainer.value = "?";
  NumbersListContainer.innerHTML = "";

  let OBJ_NumbersList = {NumbersList:[]};
  let DBegin = new Date();
  let millsecondsBegin = DBegin.getHours()*3600*1000 + DBegin.getMinutes()*60*1000 + DBegin.getSeconds()*1000 + DBegin.getMilliseconds();
  let lastNumber = fillSimpleNumbersList(targetNumbersCount, OBJ_NumbersList);
  let DComplete = new Date();
  let millsecondsComplete = DComplete.getHours()*3600*1000 + DComplete.getMinutes()*60*1000 + DComplete.getSeconds()*1000 + DComplete.getMilliseconds();
  let dt_seconds = (millsecondsComplete - millsecondsBegin)/1000.0;
  dt_seconds = dt_seconds.toFixed(DIGITS_AFTER_DOT);
  DurationContainer.value = dt_seconds.toString();
  if (needToPrint)
    printResults(OBJ_NumbersList.NumbersList, NumbersListContainer);
}

function processUserData()
{
  const BIG_PRINT_WARNING = 1000;
  let targetNumbersCount = parseInt(document.getElementById('target_numbers_count').value);
  let needToPrint = document.getElementById('need_to_print').checked
  let DurationContainer = document.getElementById('duration');
  let NumbersListContainer = document.getElementById('numbers_list');
  if (needToPrint && targetNumbersCount >= BIG_PRINT_WARNING) {
    let sure = confirm('Are you sure to print ' + targetNumbersCount + ' simple numbers?');
    if (!sure)
      return;
  }
  seekSimpleNumbers(targetNumbersCount, needToPrint, DurationContainer, NumbersListContainer);
}

