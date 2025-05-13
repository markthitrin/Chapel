use IO;

var A = [1,2,3,4,5,65,6,true];                  // type : [domain(1,int(64),one)] int(64)




foreach a in A do
    a *= 2;
                                                // hardware pallel without creating new task.
                                                // When executing a foreach-loop on a conventional processor or GPU,
                                                // the compiler will attempt to implement its iterations 
                                                // using any hardware SIMD/SIMT parallelism that’s available
                                                // but will not implement its iterations using multiple Chapel tasks or software threads 

foreach (a, i) in zip(A, 1..) do                // unbound 1.. is allow as A is knwon domain
    a += i;

for a in A do
    writeln("Hello , ",a);
