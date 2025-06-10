use LinearAlgebra;
use Random;
use Math;
use Time;

config var size = 8;
config var ite = 1000;
var a = Matrix(size);
var b = Matrix(size);

b = 2;
a = 0;

coforall i in 0..#16 with (+ reduce a) {

  on Locales[0] {
    a += b;
  }
}

writeln(a);