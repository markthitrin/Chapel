use LinearAlgebra;
use Util;
use Config;

class Linear {
    proc init(in inD: int, in outD: int) {
        domWeight = {0..#ind, 0..#outD};
        domBias = {0..#outD};
        HeNormalInit(weight);
        HeNormalInit(bias);
        
        feedCount = 0;
        weightOpt = new AdamOptGradient(weight);
        biasOpt = new AdamOptGradient(bias);
    }

    proc forward(ref tensor: [?D] real) : [D] real {
        domInput = D;
        input = tensor;
        var result = dot(tensor, weight);
        for i in D.dim(0) {
            result[i, ..] += bias;
        }
        return result;
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        return forward(tensor);
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        feedCount += 1;
        var outGradient = Matrix(D);
        for r in D.dim(0) {
            biasOpt.gradient += gradient[r, ..];
        }
        weightOpt.gradient += dot(gradient.T, input);
        return dot(gradient, weight.T);
    }

    proc updateparameter() {
        weightOpt.gradient /= feedCount;
        biasOpt.gradient /= feedCount;

        AdamOpt(weight, weightOpt);
        AdamOpt(bias, biasOpt);

        weightOpt.gradient = 0;
        biasOpt.gradient = 0;
        feedCount = 0;
    }

    var domWeight: domain(2);
    var domBias: domain(1);
    var weight: [domWeight] real;
    var bias: [domBias] real;

    var feedCount: int;
    var weightOpt: AdamOptGradient;
    var biasOpt: AdamOptGradient;

    var domInput: domain(2);
    var input: [domInput] real;
}