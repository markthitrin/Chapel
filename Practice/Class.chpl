class C {
    var a, b : int;
    proc printFields() {
        writeln("a = ", a, ", b = ",b);
    }
}

var c = new C(1,23);
c.printFields();
writeln(c);                                                 // default output


var a = c.borrow();
a.b -= 1;                                                   // THis affect to original instance
writeln(c);                                         


proc C.sum_sum(b:int) {                                     // method can be define outside the class
    return a + b + this.b;                                  // "this" refer to the instance of the class
}

writeln(c.sum_sum(89));

// proc C.sum_sum(b:int) {                                  // error : multiple overload
//     writeln("Something changed");   
// }


class D : C {                                               // class derive
    var c = 1.03, d =9.0;
    override proc printFields() {                           // this is for override the function, without override it will error
        writeln("a = ", a, " b = ", b, " c = ", c, " d = ", d);
    }
}                                                           // Note that multiple inheritance is not allow
                                                            // nor the loop inheritance
                                                            // adding inheritance is not allow either



var c1 : C;                                                 // default C
// c1.printFields();                                        // Error c1 is just geneic type without the object assigned.
c1 = new D();                                               // allowed as D derive C
c1.printFields();                                           // use tht printFields function of D


// var d1 : D;                                              // This error as D must have memory management declaration
// d1 = new C()                                             // not allow



// MEMORY management

var aa = new C();                                            // default as owned

var unm: unmanaged C = new unmanaged C();                   // this need manual delete
delete unm;

var b = new owned C();                                      // basic memory management, destroy after b out oof scope or assigned to other.
    b = new owned C();                                      // The old C got deleted.
var b2 = new owned C();                                     // Note that only one can own an instance of owned C at a time.
assert(b.type == b2.type);

var s : shared C = new shared C(1,49);                      // The share object will by deleted if all holder dead/ out of scope
var s2 = s;

var brr = b.borrow();                                       // borrow is allow but will be invalid if used when the instance is destroy
// var brr2 = b;                                            // error
// var brr3 : owned C = b                                   // error
var brr4 : borrowed C = b;                                  // ok

brr.a = 10;
writeln(b);                                                 // the value change too
writeln(brr4);                                              // the value change too

proc func1(a : borrowed C) {                                // The proc borrow
    a.a = 20;
}

func1(brr4);
writeln(b);

var x : borrowed C?;                                        // nil -able class type
x = b;
// x.printFields();                                         // THis is not allowed  
x!.printFields();                                           // ! assert the nil type and return the "borrowed" if it isn't nil
