use IO;

var A = [1,2,3,4,5,65,6,true];


// hardware pallel without creating new task.
foreach a in zip(A, 1..) do
    a *= 2;

for a in A do
    writeln("Hello , ",a);


config const n = 10000;

var B: [1..n] real;

forall i in 1..n do 
    B[i] = i:real;

writeln("The B after the modification : ",B);

forall i in B.domain do
    B[i] = A[i % A.size];

writeln("after the forall modification 2 : ", B);


forall b in B do
    b = -b;

writeln(" The B after the 3rd modification :", B);
