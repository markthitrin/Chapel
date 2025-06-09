use LinearAlgebra;
use Util;
use Math;

class LogSoftmax {
    proc forward(ref tensor: [?D] real) : [D] real {
        domOutput = D;
        for i in D.dim(0) {
            ref rowIn = tensor[i, ..];
            ref rowOut = output[i, ..];

            var maxValue = (max reduce rowIn);
            var sumExp = (+ reduce exp(rowIn - maxValue));
            var logSumExp = maxValue + log(sumExp);
            rowOut = rowIn - logSumExp;
        }
        return output;
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        return forward(tensor);
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        var outGradient = Matrix(D);
        for i in D.dim(0) {
            ref rowIn = gradient[i, ..];
            ref rowOut = outGradient[i, ..];
            ref rowOutput = output[i, ..];
            
            rowOut = exp(rowOutput);
            var dotProd = (+ reduce (rowIn * rowOut));
            rowOut = rowIn - rowOut * dotProd;
        }
        return outGradient;
    }    

    var domOutput: domain(2);
    var output: [domOutput] real;
}