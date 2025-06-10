use LinearAlgebra;
use Util;
use Math;
use Random;

var rng = new randomStream(real, seed=0);

proc GenerateDropoutMask(ref mask: [?D] real, in dropoutRate : real) {
    for idx in mask.domain {
        mask[idx] = if rng.next() > dropoutRate then 1.0 else 0.0;
    }
}

class DropOut {
    proc init(in dropoutRate: real) {
        this.dropoutRate = dropoutRate;
    }

    proc forward(ref tensor: [?D] real) : [D] real {
        domMask = D;
        GenerateDropoutMask(mask, dropoutRate);
        return tensor * mask / (1.0 - dropoutRate);
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        return tensor;
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        return gradient * mask / (1.0 - dropoutRate);
    }    

    var dropoutRate: real;

    var domMask: domain(2);
    var mask: [domMask] real;
}