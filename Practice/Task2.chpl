config const n = 7;

var si: sync int=1;                                     // state = full, value = 1                             
var sb: sync bool;                                      // state = empty, value = false


// si.writeEF(6);
// si.writeFF(6);

// si.readFE();
// si.readFF();

sb.writeEF(true);
var si2 = si.readFE();
writeln("si2 ", si2);
var sb2 = sb.readFF();
writeln("sb2 ", sb2);

var done: sync bool;
writeln("Launching new task");
begin {
  var si4 = si.readFE(); // This statement will block until si is full
  writeln("New task unblocked, si4=", si4);
  done.writeEF(true);
}

writeln("After launching new task");
si.writeEF(n);
done.readFE();




var count: sync int = n; 
var release: sync bool;

coforall t in 1..n {
  var myc = count.readFE();
  if myc!=1 {
    write(".");
    count.writeEF(myc-1);
    release.readFF();
  } else {
    release.writeEF(true);
    writeln("done");
  }
}



si.writeEF(4*n);
writeln("now passing to f_withSyncIntFormal");
f_withSyncIntFormal(si);                                        // Synce are pass by reference so wverything is the same in the function




f_withGenericDefaultIntentFormal(si);
f_withGenericDefaultIntentFormal(sb);
f_withGenericRefFormal(si);
f_withGenericRefFormal(sb);


writeln(si.readFF());
writeln(si.readFE());









proc f_withSyncIntFormal(x: sync int) {
  writeln("the value is: ", x.readFF());
}

proc f_withGenericDefaultIntentFormal(x) {
  writeln("the value is: ", x.readFF());
}

proc f_withGenericRefFormal(ref x) {
  writeln("the value is: ", x.readFF());
}