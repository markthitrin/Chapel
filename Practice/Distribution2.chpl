use ReplicatedDist;
config const n = 8;
const Space = {1..n, 1..n};


const ReplicatedSpace = Space dmapped new replicatedDist();
var RA: [ReplicatedSpace] int;                                                                  // create replication for each locale

writeln("Replicated Array has ", RA.size, " elements per locale");




on Locales[numLocales-1] do
  forall ra in RA do
    ra = here.id;                                                                               // assign to the locale's array

writeln("Locale 0's copy of RA is:\n", RA);





writeln("Locale ", numLocales-1, "'s copy of RA is:\n",
         RA.replicand(Locales[numLocales-1]));                                                  // access that replicand of that locale

on Locales[numLocales-1] do
  writeln("Locale ", numLocales-1, "'s copy of RA is:\n", RA);




proc writeReplicands(X) {
  for loc in Locales {
    writeln(loc, ":");
    writeln(X.replicand(loc));
  }
}

writeln("Replicated Array Index Map");
writeReplicands(RA);
writeln();




var A: [Space] int = [(i,j) in Space] i*100 + j;                                                    // assign to only current locale's array
RA = A;
writeln("Replicated Array after whole-array assignment:");
writeReplicands(RA);
writeln();




coforall loc in Locales do on loc do
  RA = loc.id;

writeln("Replicated Array after assigning on each locale:");
writeReplicands(RA);
writeln();




on Locales[0] do
  writeln("on ", here, ": ", RA(Space.low));
on Locales[LocaleSpace.high] do
  writeln("on ", here, ": ", RA(Space.low));
writeln();



on Locales[LocaleSpace.high] do
  RA(Space.low) = 7777;

writeln("Replicated Array after being indexed into");
writeReplicands(RA);
writeln();




on Locales[LocaleSpace.high] do
  A = RA + 4;                                                                                           // A got assign by one of the replicands
writeln("Non-Replicated Array after assignment from Replicated Array + 4");
writeln(A);
writeln();