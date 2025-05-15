
config const numTasks = here.maxTaskPar;
if numTasks < 1 then
    halt("numTasks must be a positive integer");

config const probSize = 15;
    var A: [1..probSize] real;


iter count(n: int, low: int=1) {
    for i in low..#n do
        yield i;
}


iter count(param tag: iterKind, n: int, low: int = 1) where tag == iterKind.standalone {                            // This is an overload function                                                                                                            // tag is apss when the parallel is meant to be used.
    coforall tid in 0..#numTasks {
        const myIter = computeChunk(low..#n, tid, numTasks);                                                        // The compute chuck is define at the bottom of the file

        for i in myIter {
            yield i;
        }
    }
}

forall i in count(probSize) do
    A[i] = i:real;

writeln("After parallel initialization, A is:");
writeln(A);
writeln();





iter count(param tag: iterKind, n: int, low: int=1) where tag == iterKind.leader {
    writeln("In count() leader, creating ", numTasks, " tasks");

    coforall tid in 0..#numTasks {
        const myIters = computeChunk(low..#n, tid, numTasks);
        const zeroBasedIters = myIters.translate(-low);

        writeln("task ", tid, " owns ", myIters, " yielded as: ", zeroBasedIters);

        yield (zeroBasedIters,);
    }
}

iter count(param tag: iterKind, n: int, low: int=1, followThis) where tag == iterKind.follower && followThis.size == 1 {
    const (followInds,) = followThis;
    const lowBasedIters = followInds.translate(low);

    writeln("Follower received ", followThis, " as work chunk; shifting to ",lowBasedIters);

    for i in lowBasedIters do
        yield i;
}


forall (i, a) in zip(count(probSize), A) do                                                                         // count is the leader, count and A is followers
    a = i/10.0;

writeln("After re-assigning A using parallel zippering:");
writeln(A);
writeln();

forall (a, i) in zip(A, count(probSize)) do                                                                          // A is the leader, A and count is the followers
    a = i/10.0;


A = count(probSize, low=100);                                                                                        // A is the leader

writeln("After re-assigning A using whole-array assignment:");
writeln(A);
writeln();


proc computeChunk(r: range, myChunk, numChunks) {
    const numElems = r.size;
    const elemsperChunk = numElems/numChunks;
    const rem = numElems%numChunks;
    var mylow = r.low;
    if myChunk < rem {
        mylow += (elemsperChunk+1)*myChunk;
        return mylow..#(elemsperChunk + 1);
    } else {
        mylow += ((elemsperChunk+1)*rem + (elemsperChunk)*(myChunk-rem));
        return mylow..#elemsperChunk;
    }
}