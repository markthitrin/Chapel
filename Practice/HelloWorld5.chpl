config const numTasks = here.maxTaskPar;


coforall tid in 0..#numTasks do
    writeln("Hello World (from task ",tid," of ",numTasks, ")");