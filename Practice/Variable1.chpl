var a: int;
// var a: real(32);             // multiple definition
{
    const i = 0;                // ok
}
writeln("a = ",a);              // initialized to be 0

var b = 1.612;                  // type: real(64)
writeln("b = ",b,"(Type = ",b.type:string, ")");

type myType = uint(16);
var c: myType = 3;
// var c: myType = -1           // error: u-1 assigned to unsigned integer
writeln("c = ",c,"(Type = ",myType:string,")");

const d = sqrt(c);              // const's value can be known at runtime
param k = 3.14;                 // param's value must be knwon at compile time

                                // in order to set the variable
config var z = 4;               // ./Variable1 --z=5
config const x = 4;             // ./Variable1 --x=6
config param y = 4;             // chpl Variable1.chpl -s y = 5 
config type jjjj = complex;     // chpl Variable1.chpl -s jjjj=imag

var f = 1.0, g, h: int, i, j = 1.0, l: real;
                                // The type of cast to the left
                                // f is real(64), value : 1.0
                                // g is int(64), value 0
                                // h is int(64), value 0
                                // i is real(64), value(0.0)
                                // j is real(64), value(0.0)
                                // l is real(64), value(0.0)


// Basic type in Chapel
// int(8)                                                   default value is 0
// int(16)                                                  default value is 0
// int(32)                                                  default value is 0
// int(64)                                                  default value is 0
// int                          // which is int(64)         default value is 0

// uint(8)                                                  default value is 0
// uint(16)                                                 default value is 0
// uint(32)                                                 default value is 0
// uint(64)                                                 default value is 0
// uint                         // which is uint(64)        default value is 0

// real(32)                                                 default value is 0.0
// real(64)                                                 default value is 0.0
// real                         // which is real(64)        default value is 0.0

// imag(32)                     //                          default value is 0.0i
// imag(64)                     //                          default value is 0.0i
// imag                         // which is imag(64)        default value is 0.0i

// complex(64)                  // real(32) and imag(32),   default value is 0.0 + 0.0i
// complex(128)                 // real(64) and real(64),   default value is 0.0 + 0.0i
// complex                      // whicg is complex(128),   default value is 0.0 + 0.0i

// bool                         // which 1 byte,            default value is false

// string                       // immutable UTF-8 string   default value is ""
// bytes                        // immutable raw bytes      default value is ""