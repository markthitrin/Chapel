use BlockDist;


config const n = 10;         
var  B = [1,2,3,4,5,6,7,8,9,0] : real;
var  A = [1,2] : real;

forall i in 0..#n do                             // run parallel on multiples cores, by creating multiple Chapel tasks according to the iterand
    B[i] = i:real;

writeln("The B after the modification : ",B);

forall i in B.domain do
    B[i] = A[i % A.size];

writeln("after the forall modification 2 : ", B);


forall b in B do
    b = -b;

writeln("The B after the 3rd modification :", B);




const BlockDom = blockDist.createDomain({1..n,1..n});
writeln("Thet type of block dom is ",BlockDom.type:string);
writeln("The value of BlockDom is ", BlockDom);

var C: [BlockDom] real;                                     // type : [BlockDom(2,int(64),one,unmanaged DefaultDist)] real(64)

writeln("Thet type of C dom is ",C.type:string);
writeln("The value of C is ", C);

forall (i,j) in BlockDom do
    C[i,j] = (100 * here.id) + i + j / 1000.0;

writeln("After the firsr forall thing, ",C);

forall c in C do
    c *= 2;

writeln("Everything is fine now : ", C);


[i in 0..#n] B[i] = B[i] * 2;                               // This is the same as for[each|all] loop, if the iterand is parallel it is forall

writeln("B after the first forall : ",B);

[b in B] b *= 5;
writeln("B after the second forall : ",B);

[i in 0..#n] writeln("Number : ", i);                       // This one get forall

forall c in C do                                            // This cause data race, but compiled
    B[0] += c;                                              // data race, the result likely to differ.

writeln("B after the data race :", B);                      



var D = [i in 1..10] (i**2): real;
writeln("Before the race-y averaging loop, D is: ", D);         
forall i in 2..<10 do
  D[i] = (D[i-1] + D[i+1]) / 2;

writeln("After the race-y averaging loop, D is: ", D);      // data race, the result likely differ every time.



writeln("Before the third averaging loop, D is: ", D);      // no data race since it only write the even poistion of the array
forall i in 2..<n by 2 do
  D[i] = (D[i-1] + D[i+1]) / 2;

writeln("After the third averaging loop, D is: ", D);