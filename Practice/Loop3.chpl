use BlockDist;


config const n = 10;
const BlockDom = blockDist.createDomain({1..n,1..n});
writeln(" Thet typ eof block dom is",BlockDom.type:string);
writeln(" The talue of BlockDom is", BlockDom);

var C: [BlockDom] real;

forall (i,j) in BlockDom do
    C[i,j] = (100 * here.id) + i + j / 1000.0;

writeln("After the firsr forall thing, ",C);

forall c in C do
    c *= 2;

writeln("Everything is fine now : ", C);


var  B = [1,2,3,4,5,6,7,8,9,0];
[i in 0..#n] B[i] = B[i] * 2;

writeln("B after the first forall : ",B);

[b in B] b *= 5;
writeln("B after the second forall : ",B);