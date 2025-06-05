use IO;                                             // Import module name




var i:int = 1;                                      // normal while loop, do on single core
while i < 100 {
    writeln("Hey",i);
    i *= 2;
}

while i < 900 do                                    // "do" for one line loop body
    i *= 3;

do {                                                // the do-while loop
    writeln("dfdfdsfsdfsdfdsf");
} while i < 100;

do {
    const i = readln(int);
    writeln("wrtient");
}
while i < 30;                                       // ******* Read the i within the loop

// while i < 500000 {                               // ******* infinite loop, Read the i in the loop
//     var i: int;
//     writeln("HJHJHJHJHJ");
//     i *= 3;
// }







for i in 1..3 {                                     // It call iterand 1..3, depends on the type of the iterand, i might be reference or just const copy
    writeln("iweofijwefi",i);                       // 
    // i = 8;                                       // error, i is not assignable here.
}
                                                    // Basically
                                                    // {
                                                    //      const i = 1;
                                                    //      writeln("iweofijwefi", i);
                                                    // }
                                                    // {
                                                    //      const i = 2;
                                                    //      writeln("iweofijwefi", i);
                                                    // }
                                                    // {
                                                    //      const i = 3;
                                                    //      writeln("iweofijwefi", i);
                                                    // }

var A = [1.9,2,9,4.0];
for a in A {                                        // The a is the reference t the original element   
    writeln("dsfsdfs ",a);
    a *= 2;                                         // This modify the priginal element in the A too
}   

for i in A.domain {                                 // The i is the index of the A, read-only copy
  A[i] += 3;                                        // ok
  writeln("In the third for-loop, element ", i, " of A is ", A[i]);
}

const Dom2D = {1..3, 1..3};
for idx in Dom2D {
  writeln("The fourth for-loop got index ", idx, " from Dom2D");
}

for idx in zip(1..4,1..8 by 2, A) do                // The dimension of each element in zip much be the same
    writeln("Writing : ", idx);

for (i,j,k) in zip(1..4,1..8 by 2, A) do
    writeln("Writing : ", i);



const tup = (1,2,"four");

writeln(tup.type:string);

                                                    
for i in tup do                                     // Complete unroll the loop for heterogeneous tuple
    writeln(" The type of tup ",i," is ",i.type:string);

for param i in 0..<tup.size do                      // Complete unroll the loop as the index is param and both lower, upper bound is param
    writeln(tup(i));