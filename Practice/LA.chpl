use LinearAlgebra;

var vector1: [0..#5] int;                                                               // Vector is 1D array
var vector2 = Vector(5, eltType=int); 
assert(vector1.type == vector2.type); 

var matrix1: [0..#3, 0..#5] int;                                                        // Vector is 2D array
var matrix2 = Matrix(3, 5, eltType=int);
assert(matrix1.type == matrix2.type);




var a: [0..#3, 0..#5] real;

a = 1.0;

writeln(a.rank);                                                                        // num dimension
writeln(a.size);                                                                        // num element
writeln(a.shape);                                                                       // tuple shape
writeln(a.eltType: string); // real(64




a = a + 1; // or, a += 1
writeln(a);
a = a / 4.0;
writeln(a);
a[0, ..] = 0.0; // Sets first row to 0.0
writeln(a);
a[.., 1] = 3.0; // Sets second column to 3.0
writeln(a);





var v0: [0..#5] real;
writeln(v0);
var v1 = Vector(5);       // length
var v2 = Vector(0..#5);
var v3 = Vector({0..#5});
var v4 = Vector([0, 0, 0, 0, 0], eltType=real);
var v5 = Vector(0, 0, 0, 0, 0, eltType=real);

var v6 = Vector(0.0, 0, 0, 0, 0);                                                       // type = type of first element
assert(v6.eltType == real);






var M0: [0..#3, 0..#3] real; 
writeln(M0);
var M1 = Matrix(3);                                                                    // 3*3
var M2 = Matrix(3, 3);
var M3 = Matrix(0..#3);
var M4 = Matrix(0..#3, 0..#3);
var M5 = Matrix({0..#3, 0..#3});
var M6 = Matrix(M5);
var M7 = Matrix([0,0,0],[0,0,0],[0,0,0], eltType=real);





var I1 = eye(3);                                                                        // eye
writeln(I1);
var I2 = eye(3,3);
var I3 = eye({0..#3, 0..#3});




var vec = Vector(1, 2, 3, eltType=real);
var diagMatrix = diag(vec);                                                             // get diagonal matrix
writeln(diagMatrix);




var A = Matrix(3,5),
    B = Matrix(3,5);
A = 1.0;
B = 2.0;

var ApB = A + B;                                                                        // element wise
var AmB = A - B;
var AtB = A * B;
var AdB = A / B;



var M0T = transpose(M0);                                                                // transpose
M0T = M0.T;

var t1 = v0.T;                                                                          
writeln("vector transpoze shape",v0.T.shape);    
assert(t1.type == v0.type);
assert(t1 == v0);




var X = Matrix(3, 5),
    y = Vector(3),
    z = Vector(5);
X = 1;
X -= eye(3,5);
writeln(X);
y = 2;
z = 1;





var MM = dot(X, X.T);                                                                   // MatMul
var Mv = dot(X, z);
var vM = dot(y.T, X);                     
var vv = dot(y, y);                                                                     // always inner product

var yz = outer(y, z);                                                                   // outer product
writeln('outer:', yz);

var MM4 = matPow(MM, 4);                                                                // pow

var crossProduct = cross(y, y);                                                         // cross product






var tr = trace(diagMatrix); // 6.0

var N1 = norm(vec); // 3.74166

var N2 = norm(diagMatrix); // 3.74166




var diagVec = diag(diagMatrix); // 1.0 2.0 3.0
writeln(isDiag(diagMatrix)); // true



var onesMatrix = Matrix(5,5);
onesMatrix = 1.0;
writeln(onesMatrix);

var upper = triu(onesMatrix, k=0); // k=0 includes diagonal
writeln(upper);

writeln(isTriu(upper));                 // true
writeln(isTriu(upper, k=1));            // false (k=1 does not include diagonal)
