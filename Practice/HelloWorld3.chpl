module Hello3{
    config const numMessage = 10000;

    proc main() {
        forall msg in 1..numMessage do {
            writeln("Hello World (from itegration",msg," of ",numMessage,")");
            writeln("Hello World (from itegration",msg," of ",numMessage,")");
        }

        writeln(1..numMessage);                 // start at 1, end at numMessage
        writeln((1..numMessage).type:string);   
        writeln(3..#numMessage);                // start at 3, count to 3 + numMessage
        writeln((3..#numMessage).type:string);
        writeln(1..<numMessage);                // start at 1, end before numMessage
        writeln((1..<numMessage).type:string);
        // writeln(3..#-numMessage);            // error : negative count not allowed
        // writeln((3..#-numMessage).type:string);
        writeln(1..#numMessage by 2);           // start at 1, step 2 at a time, count up to numMessage times, i.e. got 1,3,5,7,9,...,2*numMesasge - 1
        writeln((1..#numMessage by 2).type:string);
        writeln(1..#numMessage by -2);          // start at 1, step -1 at a time, count up to numMessage times, i.e. got 1,-1,-3,-5,...,-2*numMessage + 3
        writeln((1..#numMessage by -2).type:string);
        writeln(1..numMessage by 2);            // start at 1, step 2 at a time, end at no after numMessage
        writeln((1..numMessage by 2).type:string);

        // output
        // 1..10000
        // range(int(64),both,one)  range of interger64, include start and end, step one at a time
        //                          var r = range(int(64), boundKind.both, strideKind.one);
        //                          r = 1..numMessage
        // 3..10002
        // range(int(64),both,one)
        // 1..9999
        // range(int(64),both,one)
        // 1..10000 by 2
        // range(int(64),both,positive)
        // 1..10000 by -2
        // range(int(64),both,negative)
        // 1..10000 by 2
        // range(int(64),both,positive)
    }
}