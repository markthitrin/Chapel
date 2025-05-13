use IO;
use BlockDist;


const BlockDom = blockDist.createDomain({1..10,1..10});

proc foo(ref x : real, t:(int,int), d:real) {
    x = t(0) + t(1) / d;
}

var C: [BlockDom] real(64);

foo(C,BlockDom, 100.0);                                 // The procedure promoted to forall
// foo(c[0,0],BlockDom, 100.0);                         // data race, this error

writeln("The C after the for loop", C);

forall (c, ij) in zip(C, BlockDom) do                   // This is basically the same thing.
    foo(c,ij,100.0);

writeln("The C after the second for lop",C);
