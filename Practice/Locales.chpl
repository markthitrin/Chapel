writeln(here.id);
writeln(here.hostname);
writeln(here.maxTaskPar);
writeln(here.numPUs());


writeln("This program is running on ", numLocales, " locales");                                 // numLocales is variable provided by Chapel

writeln("It began running on locale #", here.id);                                               // it always start with locales 0, where the program is exeucted
writeln();

writeln(Locales);                                                                               // array of locales
writeln(Locales.type:string);


writeln(Locales[0].name);   
writeln(Locales[0].hostname);
writeln(Locales[0].numPUs());
writeln(Locales[0].maxTaskPar);


var MyLocaleArray: [1..10] locale =
      for i in 1..10 do Locales[(i-1)%numLocales];

for i in 1..10 do
  on MyLocaleArray[i] do
    writeln("MyLocaleArray[", i, "] is really locale ", here.id);

writeln();





use MemDiagnostics; // for physicalMemory()
config const printLocaleInfo = true;  // permit testing to turn this off

if printLocaleInfo then
  for loc in Locales do
    on loc {
      writeln("locale #", here.id, "...");
      writeln("  ...is named: ", here.name);
      writeln("  ...has hostname: ", here.hostname);
      writeln("  ...has ", here.numPUs(), " processor cores");
      writeln("  ...has ", here.physicalMemory(unit=MemUnits.GB, retType=real),
              " GB of memory");
      writeln("  ...has ", here.maxTaskPar, " maximum parallelism");
    }

writeln();



{                                                                                                 // the value of x and y are the same
  var x: int = 2;
  on Locales[1 % numLocales] {
    var y: int = 3;
    writeln("From locale ", here.id, ", x is: ", x, " and y is: ", y);
    on Locales[0] {
      writeln("From locale 0, x is: ", x, " and y is: ", y);
    }
  }
  writeln();
}


{                                                                                                  // use x.locale to get access to where x is defined.
  var x: int = 2;
  on Locales[1 % numLocales] {
    var y: int = 3;
    writeln("x is stored on locale ", x.locale.id, ", while y lives on ",
            y.locale.id);
  }
  writeln();
}


class Data {
  var x:int;
}

var myData: unmanaged Data?; // myData is a class pointer stored on locale 0 whose default value is `nil`

on Locales[1 % numLocales] {
  writeln("at start of 'on', myData is on locale ", myData.locale.id);
  myData = new unmanaged Data(1);
  // now myData points to something on Locales[1]
  writeln("at end of 'on', myData is on locale ", myData.locale.id);
}
writeln("after 'on', myData is on locale ", myData.locale.id);

on myData {
  writeln("Using 'on myData', I'm now executing on locale ", here.id);
}

delete myData;