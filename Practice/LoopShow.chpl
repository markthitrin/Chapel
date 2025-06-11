config var loopSelect = 0;

if (loopSelect == 0) {
    writeln("For-loop");

    for i in 1..10 do 
        writeln("Hello : ", i);
}


if (loopSelect == 1) {
    writeln("Forall-loop");

    forall i in 1..10 do 
        writeln("Hello : ", i);
}


if (loopSelect == 2) {
    writeln("Coforall-loop");

    coforall i in 1..10 do 
        writeln("Hello : ", i);
}

if (loopSelect == 3) {
    writeln("Coforall-loop");

    coforall i in 1..1000000 do 
        writeln("Hello : ", i);
}