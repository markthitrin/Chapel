config const n = 5;
var A: [1..n] real;
forall i in 1..n {                                                                          // Must parallel, call parallel iterand
  A[i] = i;
}
writeln("After setting up, A is:");
writeln(A);
writeln();


var B = forall a in A do a * 3;                                                             // Must parallel
writeln("After initialization, B is:");
writeln(B);
writeln();


var C: [1..n] real;
forall (a, b, i) in zip(A, B, C.domain) do                                                  // Must parallel
  C[i] = a * 10 + b / 10 + i * 0.001;

writeln("After a zippered loop, C is:");
writeln(C);
writeln();





iter onlySerial(m: int) {
  for j in 1..m do
    yield j;
}
[i in onlySerial(n)] {                                                                      // May parallel, only serial provided, call serial
  writeln("in onlySerial iteration #", i);
}
writeln();


// forall i in onlySerial(n) {                                                              // not ok
//   writeln("in iteration #", i);
// }


var D = [(a,b,c) in zip(A,B,C)] a + c - b;                                                  // May paralle, call paralle iterand
writeln("The result of may-parallel expression, D is:");
writeln(D);
writeln();



                                                                                            // variable are pass into the lloop according to the default intent
var outerIntVariable = 0;
proc updateOuterVariable() {
  outerIntVariable += 1;  // always refers to the outer variable
}
var outerAtomicVariable: atomic int;

forall i in 1..n {

  D[i] += 0.5; // if multiple iterations of the loop update the same
               // array element, it could lead to a data race

  outerAtomicVariable.add(1);  // ok: concurrent updates are atomic

  if i == 1 then           // ensure only one task updates outerIntVariable
    updateOuterVariable(); // to avoid the risk of a data race

  // the shadow variable always contains the value as of loop start
  writeln("shadow outerIntVariable is: ", outerIntVariable);
}

writeln();
writeln("After a loop with default intents, D is:");
writeln(D);
 // This variable is updated exactly once, so its value is 1.
writeln("outerIntVariable is: ", outerIntVariable);
 // This variable is incremented atomically n times, so its value is n.
writeln("outerAtomicVariable is: ", outerAtomicVariable.read());
writeln();






var outerRealVariable = 1.0;

forall i in 1..n with (in outerIntVariable,                                                         // with clause, pass variable by in, const in, ref, const ref, reduce
                       ref outerRealVariable) {
  outerIntVariable += 1;    // a per-task copy, never accessed concurrently

  if i == 1 then            // ensure only one task accesses outerIntVariable
    outerRealVariable *= 2; // to avoid the risk of a data race
}

writeln("After a loop with explicit intents:");
 // This outer variable's value is unaffected by the loop
 // because its shadow variables have the 'in' intent.
writeln("outerIntVariable is: ", outerIntVariable);
writeln("outerRealVariable is: ", outerRealVariable);
writeln();






 // The values of the outer variables before the loop will be included
 // in the reduction result.
writeln("outerIntVariable before the loop is: ", outerIntVariable);
var outerMaxVariable = 0;

forall i in 1..n with (+ reduce outerIntVariable,                                                   // reduce
                       max reduce outerMaxVariable) {
  outerIntVariable += i;
  if i % 2 == 0 then
    outerMaxVariable reduce= i;                                                                     // use reduce= operaotor to do things

  // The loop body can contain other code
  // regardless of reduce-related operations.
}

writeln("After a loop with reduce intents:");
writeln("outerIntVariable = ", outerIntVariable);
writeln("outerMaxVariable = ", outerMaxVariable);
writeln();








forall i in 1..n with (var myReal: real,  // starts at 0 for each task                              // var, private variable
                       ref outerIntVariable, // a shadow variable
                       ref myRef = outerIntVariable) {

  myReal += 0.1;   // ok: never accessed concurrently

  if i == 1 then   // ensure only one task accesses outerIntVariable
    myRef *= 3;    // to avoid the risk of a data race
}

writeln("After a loop with task-private variables:");
 // outerIntVariable was updated through the task-private reference 'myRef'
writeln("outerIntVariable is: ", outerIntVariable);
writeln();








record MyRecord {
  var arrField: [1..n] int;
  var intField: int;
}

proc ref MyRecord.myMethod() {
  forall i in 1..n {
    // intField += 1;                                                                               // would cause "illegal assignment" error
  }
  forall i in 1..n with (ref this) {                                                                // ref this to access record's variable
    arrField[i] = i * 2;
    if i == 1 then
      intField += 1;                                                                                // beware of potential for data races
  }
}

var myR = new MyRecord();
myR.myMethod();

writeln("After MyRecord.myMethod, myR is:");
writeln(myR);
writeln();