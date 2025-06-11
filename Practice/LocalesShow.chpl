use MemDiagnostics;

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

coforall loc in Locales do
    on loc {
      var a = [1,2,3,4,5];
      var b = [2,3,4,5,6];
      for i in 1..10000000 {
        var c = a + b;
      }
    }