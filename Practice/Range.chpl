const n = 5,
      lo = -3,
      hi = 3;
writeln("Basic ranges");
const r = 1..10,    // 1, 2, 3, ..., 10
      r2 = 0..n,    // 0, 1, 2, ..., n
      r3 = lo..hi;  // -3, -2, -1, ..., 3
writeRange(r);
writeRange(r2);
writeRange(r3);
writeln();



writeln("Open interval ranges");
const rOpen = 1..<10,  // 1, 2, 3, ..., 9
      rOpen2 = 0..<n;  // 0, 1, 2, ..., n-1
writeRange(rOpen);
writeRange(rOpen2);
writeln();


writeln("Empty ranges");
const empty1 = 1..0,
      empty2 = 0..-1,
      empty3 = 10..1;
writeRange(empty1);
writeRange(empty2);
writeRange(empty3);
writeln();


writeln("Decreasing range");
const countDown = 1..10 by -1;  // 10, 9, 8, ..., 1
writeRange(countDown);
writeln();



var sum = 0;
for i in 1..10 do       // compute 1 + 2 + 3 + ... + 10
  sum += i;
writeln("The sum of the values in '1..10' is ", sum);
writeln();



writeln("Domains and arrays");
const D = {1..10, 1..10};  // could also use '= {r, r};'
var A: [D] real;           // a 10x10 array of real floating point values
writeln("D = ", D);
writeln("Array A");
writeln(A);
writeln();


var A1: [1..n] int,
    A2: [1..n, 1..n] string;


sum = + reduce r;  // compute 1 + 2 + 3 + ... + 10
writeln("The sum of the values in ", r, ", computed by reduce, is also ", sum);


A1 = r;      // assign the elements of A1 their corresponding values of r
writeln(A1);
writeln();


writeln("Unbounded ranges");
writeRange(1..);   // 1, 2, 3, ...
writeRange(..5);   // ..., 3, 4, 5
writeRange(..);    // ...
writeln();



writeln("Iterating over zip(312..315, 1..) generates");
for (i, j) in zip(312..315, 1..) {
  write(" ", (i, j));
}
writeln();
writeln();





writeln("Ranges over bools and enums:");
enum dir {north, south, east, west};
enum color {red=4, orange=2, yellow=1, green=3, blue=6, indigo=7, violet=5};
const boolRange = false..true,                 // false, true
      enumRange = dir.north..dir.west,         // north, south, east, west
      colorRange = color.orange..color.green;  // orange, yellow, green
writeRange(boolRange);
writeRange(enumRange);
writeRange(colorRange);
writeln();



// the highest/lowest value of that typ eis the bound
writeRange(false..);         // like 'false..true'
writeRange(dir.south..);     // like 'dir.south..dir.west'
writeRange(..color.indigo by -1);  // like 'color.red..color.indigo by -1'
writeln();



writeln("The count operator");
const numElements = 5;
writeRange(0..#numElements);  // 0, 1, 2, 3, 4
writeRange(r # 4);            // 1, 2, 3, 4     // first 4 values
writeRange(..5 # -3);         // 3, 4, 5        // last 3 values
writeln();



// positive stride is align with Low bound
// negative stride is align with high bound
writeln("Strided ranges using the by operator");
writeRange(r by 2);       // 1, 3, 5, 7, 9
writeRange(r by 2 by 2);  // 1, 5, 9
writeRange(r by -1);      // 10, 9, 8, ..., 1
writeRange(5.. by 2);     // 5, 7, 9, 11, ...
writeln();

writeln("Examples mixing # and by");
writeRange(r by 2 # 4);    // 1, 3, 5, 7
writeRange(r # 4 by 2);    // 1, 3
writeRange(r by -2 # 4);   // 10, 8, 6, 4
writeRange(r # 4 by -2);   // 4, 2
writeRange(r by 2 # -4);   // 3, 5, 7, 9
writeRange(r # -4 by 2);   // 7, 9
writeRange(r by -2 # -4);  // 8, 6, 4, 2
writeRange(r # -4 by -2);  // 10, 8            
writeln();


// align is used with "indice"
// it use who match the modulo result with stride
writeln("Range alignment and the align operator");
const oddsBetween1and10  = r by 2 align 1,  // 1, 3, 5, 7, 9
      evensBetween1and10 = r by 2 align 2;  // 2, 4, 6, 8, 10
writeRange(oddsBetween1and10);
writeRange(evensBetween1and10);

const allOdds = .. by 2 align 1,
      allEvens = .. by 2 align 2;
writeRange(allOdds);
writeRange(allEvens);
writeln();




// + and - shift the range
writeln("Operators + and -");
writeRange(r + 5);          // 6..15
writeRange(r - 3);          // -2..7
writeRange((r by 2) - 1);   // 0..9  by 2
writeRange(1 + ..5);        // ..6
writeln();



// == check if range is equal
writeln("Range equality");
writeln(r == 1..10);                               // true
writeln((1..10 by 2) == (1..9 by 2));              // true
writeln(r == (r by 2));                            // false
writeln(oddsBetween1and10 != evensBetween1and10);  // true
writeln();



// range used as index of another range
// the reuslt is intersection
writeln("Range slicing");
writeln("A slice of ", r, " with ", 2..7);
writeRange(r[2..7]);  // 2..7
const r1 = 5..15;
writeln("A slice of ", r, " with ", r1);
writeRange(r[r1]);    // 5..10
writeln("A slice of ", r1, " with ", r, " is the same");
writeRange(r1[r]);    // 5..10




writeRange(r[allOdds]);   // 1, 3, 5, 7, 9
writeRange(r[allEvens]);  // 2, 4, 6, 8, 10

writeln(r[allOdds] == oddsBetween1and10);    // true
writeln(r[allEvens] == evensBetween1and10);  // true




// negative could reverse the order of range
const rs = 1..20 by 3;
writeln("A slice of ", rs, " with ", 1..20 by 2);
writeRange(rs[1..20 by 2]);  // 1, 7, 13, 19
writeln("A slice of ", rs, " with ", 1..20 by -2);
writeRange(rs[1..20 by -2]); // 16, 10, 4
writeln();

writeln("A slice of ", r, " with ", 5..);
writeRange(r[5..]);       // 5, 6, 7, 8, 9, 10
writeln("A slice of ", r, " with ", 5.. by 2);
writeRange(r[5.. by 2]);  // 5, 7, 9
writeln("A slice of ", 1.., " with ", ..5);
writeRange((1..)[..5]);   // 1, 2, 3, 4, 5
writeln();

// range declaration
// idxType : default as int
// bounds : default as boundKind.both
// strides : default as strideKind.one

const rt: range(int) = 1..10,
      rt2: range(int, bounds=boundKind.both, strides=strideKind.one)
         = 1..10,
      rte: range(color) = color.orange..color.green,
      rts: range(strides=strideKind.any) = 1..10 by 2,
      rtub: range(bounds=boundKind.low) = 1..;



var rangeVar: range(int, strides=strideKind.any) = 1..10;   // This strideKind.any create felxibility to range to be assigned with other stride

// This is used to create procedure.
proc acceptsNonStridedIntRangesOnly(r: range(int)) { }
proc acceptsAnyRange(r: range(?)) { }

acceptsNonStridedIntRangesOnly(1..10);
acceptsAnyRange(1..10);
acceptsAnyRange(1..10 by 2);
acceptsAnyRange(color.orange..color.green);

























proc writeRange(r: range(?)) {
  write("Range ", r);
  if r.bounds == boundKind.both ||
    ((isBoolType(r.idxType) || isEnumType(r.idxType)) && r.hasFirst()) {
      // The range is fully bounded, either because it is a bounded
      // range or because it is unbounded but defined on bools or an
      // enum, so - print its entire sequence.
    write(" = ");
    var first: bool = true;;
    for i in r {
      if !first then write(", ");
      write(i);
      first = false;
    }
  } else if r.hasFirst() {
    // The range is not fully bounded, but its sequence has a starting point
    // - print the first three indices.  Note that in this and the next
    // case the sequence can be either increasing or decreasing.
    write(" = ");
    for i in r # 3 do
      write(i, ", ");
    write("...");
  } else if r.hasLast() {
    // The range is not fully bounded, but its sequence has an ending point.
    // Print the last three indices.
    write(" = ...");
    for i in r # -3 do
      write(", ", i);
  } else if r.stride == 1 || r.stride == -1 {
    // If we are here, the range is fully unbounded.
    write(" = all integers, ",
          if r.stride > 0 then "increasing" else "decreasing");
  } else {
    // We got a more complex range, do not elaborate.
  }
  writeln();
}