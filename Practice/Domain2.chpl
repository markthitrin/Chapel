config var n = 9;
const dnsDom = {1..n, 1..n};
var spsDom: sparse subdomain(dnsDom);

var spsArr: [spsDom] real;                                                              // create array

writeln("Initially, spsDom is: ", spsDom);
writeln("Initially, spsArr is: ", spsArr);
writeln();

proc writeSpsArr() {
  for (i,j) in dnsDom {
    write(spsArr(i,j), " ");
    if (j == n) then writeln();
  }
  writeln();
}


writeln("Printing spsArr with a dense representation:");
writeSpsArr();

spsArr.IRV = 7.7;                                                                       // change the defualt value
writeln("Printing spsArr after changing its IRV:");
writeSpsArr();

spsDom += (1,n);                                                                        // add corner
spsDom += (n,n);    
spsDom += (1,1);
spsDom += (n,1);

writeln("Printing spsArr after adding the corner indices:");
writeSpsArr();

writeln("After adding corners, spsDom is:\n", spsDom);
writeln("After adding corners, spsArr is:\n", spsArr);
writeln();

proc computeVal(row, col) do return row + col/10.0;

spsArr(1,1) = computeVal(1,1);                                                          // change corner value
spsArr(1,n) = computeVal(1,n);
spsArr(n,1) = computeVal(n,1);
spsArr(n,n) = computeVal(n,n);

writeln("Printing spsArr after assigning the corner elements:");
writeSpsArr();


writeln("Positions that are members in the sparse domain are marked by a '*':");

for (i,j) in dnsDom {
  if spsDom.contains(i,j) then                                                          // check if contain
    write("* "); // (i,j) is a member in the sparse index set
  else
    write(". "); // (i,j) is not a member in the sparse index set

  if (j == n) then writeln();
}
writeln();



writeln("Iterating over spsDom and indexing into spsArr:");
for ij in spsDom do
  writeln("spsArr(", ij, ") = ", spsArr(ij));
writeln();

writeln("Iterating over spsArr:");
for a in spsArr do
  writeln(a, " ");
writeln();




var sparseSum = + reduce spsArr;                                                        // reduction can be apply
var denseSum = + reduce [ij in dnsDom] spsArr(ij);

writeln("the sum of the sparse elements is: ", sparseSum);
writeln("the sum of the dense elements is: ", denseSum);
writeln();




spsDom.clear();                                                                         // empty the sparse index set
spsArr.IRV = 0.0;                                                                       // reset the IRV

for i in 1..n do
  spsDom += (i,i);

[(i,j) in spsDom] spsArr(i,j) = computeVal(i,j);

writeln("Printing spsArr after resetting and adding the diagonal:");
writeSpsArr();




spsDom.clear();
spsDom = ((1,1), (n/2, n/2), (n,n));                                                    // asign the tuple

[(i,j) in spsDom] spsArr(i,j) = computeVal(i,j);

writeln("Printing spsArr after resetting and assigning a tuple of indices:");
writeSpsArr();



iter antiDiag(n) {
  for i in 1..n do
    yield (i, n-i+1);
}

spsDom = antiDiag(n);                                                                   // iterator assignable

[(i,j) in spsDom] spsArr(i,j) = computeVal(i,j);

writeln("Printing spsArr after resetting and assigning the antiDiag iterator:");
writeSpsArr();