use BlockDist, CyclicDist;

config const n = 8;
const Space = {1..n, 1..n};

const BlkDist = new blockDist(boundingBox=Space);
const BlockSpace = BlkDist.createDomain(Space);
var BA: [BlockSpace] int;

const BlockSpace22 = blockDist.createDomain({1..n, 1..n});
const BA22: [BlockSpace22] int;


// create the array using an anonymous distribution and domain
const BA3 = blockDist.createArray({1..n, 1..n}, int);

forall ba in BA do
  ba = here.id;


writeln("Block Array Ownership Map");
writeln(BA);
writeln();


writeln("Locale 0 owns the following indices of BA: ", BA.localSubdomain());
writeln();


coforall L in Locales {
  on L {
    const myIndices = BA.localSubdomain();
    for i in myIndices {
      if BA[i] != L.id then
        halt("Error: incorrect locale id");
    }
  }
}


const BigBlockSpace = BlkDist.createDomain({0..n+1, 0..n+1});                                                   // out of bound space, assign locale with the nearby value



var MyLocales = reshape(Locales, {0..<numLocales, 0..0});                                                       // reshape (array, domain) return view, not deep copy
                                                                                                                // change B = change A too.

const BlkDist2 = new blockDist(boundingBox=Space, targetLocales=MyLocales);
const BlockSpace2 = BlkDist2.createDomain(Space);
var BA2: [BlockSpace2] int;

forall ba2 in BA2 do
  ba2 = here.id;

writeln("Block Array Ownership Map");
writeln(BA2);
writeln();

forall (l, ml) in zip(BA2.targetLocales(), MyLocales) do                                                        // targetLocales() get the locales array
  if l != ml then
    halt("Error: BA2.targetLocales() should equal MyLocales");





const CycDist = new cyclicDist(startIdx=Space.low);
const CyclicSpace = CycDist.createDomain(Space);
var CA: [CyclicSpace] int;

const CyclicSpace22 = cyclicDist.createDomain({1..n, 1..n});
const CA22: [CyclicSpace22] int;

const CA3 = cyclicDist.createArray({1..n, 1..n}, int);


forall ca in CA do
  ca = here.id;

writeln("Cyclic Array Ownership Map");
writeln(CA);
writeln();

writeln("Locale 0 owns the following indices of CA: ", CA.localSubdomain());