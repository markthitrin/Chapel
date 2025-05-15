writeln("1: ### The begin statement ###");
begin writeln("1: output from spawned task");                                                   // new parallel task
writeln("1: output from main task");



writeln("2: ### The cobegin statement ###");
cobegin {                                                                                       // parallel in block
  writeln("2: output from spawned task 1");
  writeln("2: output from spawned task 2");
}                                                                                               // block finish first before proceed
writeln("2: output from main task");




writeln("3: ### The cobegin statement with nested begin statements ###");
cobegin {
  begin writeln("3: output from spawned task 1");                                               // parallel task, might not finish before the block ends
  begin writeln("3: output from spawned task 2");
}
writeln("3: output from main task");





writeln("4");
cobegin {                                                                                       // paralle between blocks
    {                                                                                           // serial in each block
        writeln("THing1a");
        writeln("THing1b");
        writeln("THing1c");
        writeln("THing1d");
        writeln("THing1e");
        writeln("THing1f");
    }
    {
        writeln("THing2a");
        writeln("THing2b");
        writeln("THing2c");
        writeln("THing2d");
        writeln("THing2e");
        writeln("THing2f");
    }
}
writeln("end 4");



writeln("4: ### The coforall loop ###");
config const n = 10;
coforall i in 1..n {
  writeln("4: output 1 from spawned task ", i);
  writeln("4: output 2 from spawned task ", i);
}
writeln("4: output from main task");



writeln("5: ### The coforall loop with nested begin statements ###");
coforall i in 1..n {
  begin writeln("5: output from spawned task 1 (iteration ", i, ")");
  begin writeln("5: output from spawned task 2 (iteration ", i, ")");
}
writeln("5: output from main task");





var outerArray = [10, 11, 12];
begin with (in outerArray) assert(outerArray[0] == 10);                                         // copy intent with "with" clause

var outerRealVariable = 1.0;

coforall i in 1..n with (ref outerRealVariable) {
  if i == 1 then
    outerRealVariable *= 2;
}        




var outerIntVariable = 2;
var outerMaxVariable = 0;
var outerMinVariable = 0;

coforall i in 1..n with (+ reduce outerIntVariable,
                         max reduce outerMaxVariable,
                         min reduce outerMinVariable) {
    outerIntVariable = i;

    if i % 2 == 0 then
        outerMaxVariable = i;  // compute the max of even indices
    else
        outerMinVariable = -i; // ... and the min of negated odd ones

    // The loop body can contain other code
    // regardless of reduce-related operations.
}

writeln(outerIntVariable); // get the sum
