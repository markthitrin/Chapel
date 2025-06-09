use LinearAlgebra;
use Random;
use Math;

var a = Matrix(10,10);
var output = a;


for (i,j) in a.domain {
    a[i,j] = i + j;
}



for i in 0..<10 {
    ref r = a[i, ..];
    var maxValue = (max reduce r);
    var sumExp = (+ reduce exp(r - maxValue));
    output[i, ..] = exp(r - maxValue) / sumExp;
}

writeln(output);