// var tt000 = ();                                                  // empty tuple is not allow
var tt000 = (1);                                                    // 1 element tuple


var t = (1, "Hi");

writeln(t(0),t(1));
writeln(t[0],t[1]);                                                 // [] is allowed too.
writeln(t);
writeln(t.size);



var t2 : (int, string);
t2 = t;

t2[0] = 10;                                                         // copy
writeln(t);                                                         // no change



var t3 : 3 * real;                                                  // (real,real,real)
t3 += 1.0;                                                          // if tuple contain only 1 type, some operator is supported
writeln(t3);                                                        // (1.0, 1.0, 1.0)

for i in t {                                                        // iterable
    writeln(i);                                                     // The loop are always unroll to match the type of tuple
}
                                                                    // tuple with single type should be able to use forall and coforall


var (a,b) = t;                                                      // unpack is allowed, wors in for, forall loop and function call too.
writeln(a,b);





proc add(a ,b, c) {
    return a + b + c;
}

add((...t3));                                                       // is add(t3(0), t3(1), t3(2));