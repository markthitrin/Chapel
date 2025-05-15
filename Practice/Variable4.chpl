// The Nothingg will be remove by the compiler and only "none" can assigned to it

var nothingVar: nothing;
var nothingVar2 = none;





record nothingRecord {
  param useImpl2: bool = false;                                                     // useful to conditionally remove the varaible at compile time
  var impl1Var1 = if useImpl2 then none else 1;                                     // as it will be remove and save the cache and memeory
  var impl1Var2 = if useImpl2 then none else 2.0;

  var impl2Var1 = if useImpl2 then 3.0 else none;
  var impl2Var2 = if useImpl2 then "4.0" else none;

  proc myProc() {
    if useImpl2 {
      writeln((impl2Var1, impl2Var2));
    } else {
      writeln((impl1Var1, impl1Var2));
    }
  }
}

var vr1 = new nothingRecord(useImpl2=false),
    vr2 = new nothingRecord(useImpl2=true);

vr1.myProc();
vr2.myProc();

config const n = 1000;
var A: [1..n] nothingRecord(useImpl2=false);
for vr in A {
  if vr.useImpl2 {
    vr.impl2Var1 = 1.1;
    vr.impl2Var2 = "hello world!";
  } else {
    vr.impl1Var1 = 42;
    vr.impl1Var2 = 3.14;
  }
}