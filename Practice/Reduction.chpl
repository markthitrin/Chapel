use Random; // For random number generation

config const seed = 31415; // Random generation seed
config const size = 10;    // The size of each side of the array

var A: [1..size, 1..size] real; // The 2D work array



fillRandom(A, seed);
writeln("A is: "); writeln(A);
writeln();



var eltAvg = (+ reduce A) / size**2;                                                            // + reduce
writeln("The average element of A has the value ", eltAvg);
writeln();

var frobNorm = sqrt(+ reduce A**2);
writeln("The Frobenius norm of A is ", frobNorm);
writeln();





var (maxVal, maxLoc) = maxloc reduce zip(A, A.domain);                                          // maxloc reduce (max Value, location)
var (minVal, minLoc) = minloc reduce zip(A, A.domain);
writeln("The maximum value in A is: A", maxLoc, " = ", maxVal);
writeln("The minimum value in A is: A", minLoc, " = ", minVal);
writeln("The difference is: ", maxVal - minVal);
writeln();


var vecNorms = [j in 1..size] sqrt(+ reduce A(1..size, j)**2);
writeln("The Euclidean norm of each column is: ", vecNorms);
writeln();