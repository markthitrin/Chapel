use IO;


config const numTask = 4;
var total: atomic int;

coforall tid in 1..numTask do                   // The coforall force the program to create each task for each iteration
    total.add(tid);

writeln("sum : ", total);




coforall loc in Locales {                       // loop to each locales avaliable
    on loc {                                    // in that locale
        coforall tid in 1..here.maxTaskPar {    // create task as much as the number of th thread avaliable
            // Do something 
        }
    }
}
