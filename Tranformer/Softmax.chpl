use LinearAlgebra;
use Util;
use Math;
use ReplicatedDist;

class Softmax {
    proc forward(ref tensor: [?D] real) : [D] real {
        domOutput = D;
        output = Matrix(D);
        forall i in D.dim(0) {
            ref rowIn = tensor[i, ..];
            ref rowOutput = output[i, ..];

            var maxValue = (max reduce rowIn);
            var sumExp = (+ reduce exp(rowIn - maxValue));
            rowOutput = exp(rowIn - maxValue) / sumExp;
        }
        return output;
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        return forward(tensor);
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        var outGradient = Matrix(D);
        forall i in D.dim(0) {
            ref rowIn = gradient[i, ..];
            ref rowOut = outGradient[i, ..];
            ref rowOutput = output[i, ..];

            var sumGY = (+ reduce (rowIn * rowOutput));
            rowOut = rowOutput * (rowIn - sumGY);
        }
        return outGradient;
    }    

    var domOutput: domain(2) dmapped new replicatedDist();
    var output: [domOutput] real;
}