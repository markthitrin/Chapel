// Atomic support all numerics na bool


config const n = 31;
const R = 1..n;

var x: atomic int;                                                  // atomic keyword

x.write(n);                                                         // use write() and read()
if x.read() != n then
    halt("Error: x (", x.read(), ") != n (", n, ")");




var numFound: atomic int;
coforall id in R {
    numFound.add(x.compareAndSwap(n, id-1));                        // equal the firs argument = exchange and return true
}
if numFound.read() != 1 then                 
    halt("Error: numFound != 1 (", numFound.read(), ")");
if x.read() == n then
    halt("Error: x == n");




var flag: atomic bool;
var result: [R] bool;
coforall r in result do
    r = flag.testAndSet();                                          // read value and set to true


var found = false;
for r in result {
  if !r then
    if found then
      halt("Error: found multiple times!");
    else
      found = true;
}
if !found then
  halt("Error: not found!");
flag.clear();




// fetchAdd() and add() +
// fetchSub() and sub() -
// fetchOr() and or()   |
// fetchAnd() and and() &
// fetchXor() and xor() ^


var a: atomic int;
coforall id in R do a.add(id*id);

var expected = n*(n+1)*(2*n+1)/6;
if a.read() != expected then
    halt("Error: a=", a.read(), " (should be ", expected, ")");




a.write(0);
const sumOfSq = n*(n+1)*(2*n+1)/6;
coforall id in R {
    const mySq = id*id;
    const last = a.fetchAdd(mySq);
    if sumOfSq-mySq == last {
        const t = a.read();
        if t != n*(n+1)*(2*n+1)/6 then
        halt("Error: a=", t, " (should be ", sumOfSq, ") id=", id);
    }
}