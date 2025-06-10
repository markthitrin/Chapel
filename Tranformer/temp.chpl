use LinearAlgebra;
use Random;
use Math;

proc func () {
    return (Matrix(10),Matrix(10),Matrix(10),Matrix(10));   
}


proc func2(ref a: [?D] real) {
    a[0,0] = 0;
}

var (a,b,c) = func();
func2(a);

writeln(a);