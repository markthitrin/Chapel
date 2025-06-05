config const n = 5;
var A: [1..n] real;
writeln("Initially, A is: ", A);                                                      // prints 0.0 for each array element


var A2 = [-1.1, -2.2, -3.3, -4.4, -5.5];
writeln("Initially, A2 is: ", A2);



A[1] = 1.1;
A(2) = 2.2;
writeln("After assigning two elements, A is: ", A);




A[2..4] = 3.3;
writeln("After assigning its interior values, A is: ", A);
writeln();
writeln("A(2..4) is: ", A(2..4), "\n");





var B: [1..n, 1..n] real;
forall (i,j) in {1..n, 1..n} do
  B[i,j] = i + j/10.0;

writeln("Initially, B is:\n", B, "\n");



var B2 = [                                                                                          // seperate with ; for dimension
  -1.1, -2.2, -3.3, -4.4, -5.5 ;
  -2.1, -3.2, -4.3, -5.4, -6.5 ;
  ;
  -3.1, -4.2, -5.3, -6.4, -7.5 ;
  -4.1, -5.2, -6.3, -7.4, -8.5 ;
  ;
  -5.1, -6.2, -7.3, -8.4, -9.5 ;
  -6.1, -7.2, -8.3, -9.4, -10.5 ;
];

writeln("Initially, B2 (shape=", B2.shape ,") is:\n", B2, "\n");





forall b in B do
  b += 1;

writeln("After incrementing B's elements, B is:\n", B, "\n");





forall (i,j) in B.domain do                                                                         // query the index
  B[i,j] -= 1;

writeln("After decrementing B's elements, B is:\n", B, "\n");






proc negateAndPrintArr(ref X: [?D] real) {                                                          // query the doamin using [?]
  writeln("within negateAndPrintArr, D is: ", D, "\n");
  forall (i,j) in D do
    X[i,j] = -X[i,j];
  writeln("after negating X within negateAndPrintArr, X is:\n", X, "\n");
}

negateAndPrintArr(B);



const ProbSpace = {1..n, 1..n};                                                                     // create doamin and assign name
var C, D, E: [ProbSpace] bool;


forall (i,j) in ProbSpace do    
  C[i,j] = (i+j) % 3 == 0;

writeln("After assigning C, its value is:\n", C, "\n");
for (i,j) in ProbSpace do
  B[i,j] = i + j/10.0;

writeln("B has been re-assigned to:\n", B, "\n");
for ij in ProbSpace do
  D[ij] = ij(0) == ij(1);

writeln("After assigning D, its value is:\n", D, "\n");




E = C;                                                                                              // copy the whole array
writeln("After assigning C to E, E's value is:\n", E, "\n");

E = true;                                                                                           // assigne the whole array
writeln("After being assigned 'true', E is:\n", E, "\n");

var F, G: [ProbSpace] real;
F[2..n-1, 2..n-1] = B[1..n-2, 3..n];                                                                // sub array assignment
writeln("After assigning a slice of B to a slice of F, F's value is:\n", F, "\n");

G[2.., ..] = B[..n-1, ..];                                                                          // missing bound is determined by the array bound
writeln("After assigning a slice of B to G, G's value is:\n", G, "\n");


A = B[n/2, ..];                                                                                     // like python thing
writeln("After being assigned a slice of B, A is:\n", A, "\n");

writeln("ProbSpace[1..n-2, 3..] is: ", ProbSpace[1..n-2, 3..], "\n");                               // domain can be slice, and find the intersection
const ProbSpaceSlice = ProbSpace[0..n+1, 3..];
writeln("B[ProbSpaceSlice] is:\n", B[ProbSpaceSlice], "\n");                                        // use domain the slice the array



var VarDom = {1..n};
var VarArr: [VarDom] real = [i in VarDom] i;                                                        // [i in Dom] i is a special expression to assign array
writeln("Initially, VarArr = ", VarArr, "\n");



VarDom = {1..2*n};
writeln("After doubling VarDom, VarArr = ", VarArr, "\n");                                          // the array resize and become 1,2,3 ... n,0,0,...,0

VarDom = {-n+1..2*n};
writeln("After lowering VarDom's lower bound, VarArr = ", VarArr, "\n");                            // the array resize and become 0,0,0...,1,2,3,...n

VarDom = {2..n-1};
writeln("After shrinking VarDom, VarArr = ", VarArr, "\n");                                         // the value is thrown away 



VarDom = {1..0};  // empty the array such that no values need to be preserved
writeln("VarArr is now empty: ", VarArr, "\n");
VarDom = {1..n};  // re-assign the domain to establish the new indices
writeln("VarArr should now be reset: ", VarArr, "\n");





record wrapFixedArr {                                                                               // unknown size array int he record
  const size: int;
  var Arr: [1..size] real;
}

var RSmall = new wrapFixedArr(size=10);
var RLarge = new wrapFixedArr(size=1000);

writeln("Size of RSmall's FieldArr: ", RSmall.Arr.size);
writeln("Size of RLarge's FieldArr: ", RLarge.Arr.size);



record wrapDynArr {
  var Inds = {1..0};
  var Arr: [Inds] real;                                                                             // resizable array in the record
}
var r: wrapDynArr;
writeln("Initial size of r: ", r.Arr.size);
r.Inds = {1..100};                                                                                  // resizing
writeln("New size of r: ", r.Arr.size);




var Y: [ProbSpace] [1..3] real;                                                                     // array of array

forall (i,j) in ProbSpace do
  for k in 1..3 do
    Y[i,j][k] = i*10 + j + k/10.0;

writeln("Y is:\n", Y);




var AA : [2..10,1..10] real;
writeln(AA.reindex(1..9,101..110).domain);