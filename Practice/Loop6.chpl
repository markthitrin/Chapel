forall i in 1..10 do                    // This nest loop can create up to 10*10 tasks
    forall j in 1..10 do                // but it likely to create as much as the number of core avaliable on the machine
        writeln ("Hi");
    

forall i in 1..10 do
    foreach j in 1..10 do               // This might makes more senses by createing 10 task with each doing its own foreach
        writeln("wow");                 // but maybe negligible


forall i in 1..10 do                    // apparantly no conflict here
    forall i in 1..3 do
        writeln("Hello",i);             // i is belong to the inner loop i


var A : [1..50] int;

forall a in A[2..A.size-1] do
    a = here.id;

writeln(A);



coforall l in Locales {                 // This is the correct, use coforall instead of forall in calling multiple nodes.
    on l {                              // as forall always consider the maxNumerTask in the locales.
        // do something
    }
}

