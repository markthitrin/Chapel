use IO;

var i:int = 1;
while i < 100 {
    writeln("Hey",i);
    i *= 2;
}

while i < 900 do
    i *= 3;
do {
    writeln("dfdfdsfsdfsdfdsf");
} while i < 100;


do {
    const i = readln(int);
    writeln("wrtient");
}
while i < 30; // Read the wthin the loop



for i in 1..3 {
    writeln("iweofijwefi",i);
}

var A = [1.9,2,9,4.0];
for a in A { //  The a is the reference t the original element
    writeln("dsfsdfs",a);
}

for i in A.domain { // The index(itself) is copy of the domain
  writeln("In the third for-loop, element ", i, " of A is ", A[i]);
}

const Dom2D = {1..3, 1..3};

for idx in Dom2D {
  writeln("The fourth for-loop got index ", idx, " from Dom2D");
}



for idx in zip(1..4,1..8 by 2, A) do
    writeln("Writing : ", idx);

for (i,j,k) in zip(1..4,1..8 by 2, A) do
    writeln("Writing : ", i);



const tup = (1,2,"four");

writeln(tup.type:string);


// unroll the loop ans serialize the execution
for i in tup do
    writeln(" The type of tup ",i," is ",i.type:string);

for param i in 0..<tup.size do 
    writeln(tup(i));