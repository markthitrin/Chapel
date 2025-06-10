use LinearAlgebra;
use Random;

var rng = new randomStream(int);

proc randomInt(low: int, high: int): int {
    return rng.next(low, high);
}

proc getData(ref data: [?D] int, in batch: int, in length: int) {
    var input = Vector(batch * length);
    var target = Vector(batch * length);
    var maxLength = data.dim(0).size;
    for i in 0..#batch {
        var spos = randomInt(0, maxLength - 1 - length);
        input[(i * length)..#(length - 1)] = data[spos..#(length - 1)];
        target[(i * length)..#length] = data[spos..#length];
    }
    return (input, target);
}
