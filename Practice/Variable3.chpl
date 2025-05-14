proc intWriteln(args: int ...?n) {                                  // arg is tuple of n
  for i in args.indices {
    if i != n-1 then
      write(args(i), " ");
    else
      writeln(args(i));
  }

  writeln("The first function receive arg as ", args.type:string);
}

intWriteln(1, 2, 3, 4);
// intWriteln();                                                    // not allowed




proc anyTypeWriteln(args...?n) {                                    // generic arg
  for param i in 0..<n {
    if i != n-1 then
      write(args(i), " ");
    else
      writeln(args(i));
  }
  writeln("The second fnuction receive arg as ", args.type:string);
}

anyTypeWriteln(1, 2.0, 3.14 + 2.72i);




proc defaultValues(type args...?n) {                                // Type tuple is accepted
  var val: args;
  return val;
}

anyTypeWriteln((...defaultValues(int, complex, bool, 2*real)));
