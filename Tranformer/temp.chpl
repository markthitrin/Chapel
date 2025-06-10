use LinearAlgebra;
use Random;
use Math;

use CTypes;

proc bitcast(x : real(64)) : int(64) {
    var u = x;
    var r: int(64);
    var p = c_ptrTo(u);
    r = (p:c_ptr(int(64))).deref();
    return r;
}

proc fast_log2(x: real): real {
  if x <= 0.0 then
    halt("Input must be positive");

  // reinterpret the bits of the float as an int
  var bits = bitcast(x);  // Assuming 64-bit double
  var exponent = ((bits >> 52) & 0x7FF):int - 1023;  // Extract exponent (bias 1023)
  var mantissa = (bits & 0xFFFFFFFFFFFFF) | (1 << 52); // Normalize mantissa with implicit 1

  // Scale mantissa to [1.0, 2.0)
  var m = mantissa:real / (1 << 52);

  // Approximate log2(x) ≈ exponent + (m - 1)
  return exponent:real + (m - 1.0);
}

proc main() {
  for x in 1..16 by 1 {
    writeln("x = ", x, ", fast_log2 = ", fast_log2(x:real), ", log2 = ", log2(x:real));
  }
}