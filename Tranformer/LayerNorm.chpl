use LinearAlgebra;
use Util;
use Config;
use ReplicatedDist;

class LayerNorm {

    proc init(in shape: int) {
        domGamma = {0..#shape};
        domBias = {0..#shape};
        gamma = 1.0;
        bias = 0.0;

        feedCount = 0;
        gammaOpt = new AdamOptGradient1(gamma);
        biasOpt = new AdamOptGradient1(bias);
    }

    proc forward(ref tensor: [?D] real) : [D] real {
        var shape = D.dim(1).size;
        var output = Matrix(D);
        domXHat = D;
        domStd = {D.dim(0)};
        forall i in D.dim(0) {
            ref rowIn = tensor[i, ..];
            ref rowOut = output[i, ..];
            ref rowXHat = xHat[i, ..];
            ref s = std[i];

            var mean: real = (+ reduce rowIn) / shape;
            s = sqrt((+ reduce (rowIn - mean)**2) / shape);
            rowXHat = (rowIn - mean) / (s + eps);
            rowOut = gamma * rowXHat + bias;
        }
        return output;
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        return forward(tensor);
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        feedCount += 1;
        var shape = D.dim(1).size;
        var outGradient = Matrix(D);
        for i in D.dim(0) {
            ref rowIn = gradient[i, ..];
            ref rowOut = outGradient[i, ..];
            ref rowXHat = xHat[i, ..];
            var s = std[i];
            ref gGrd = gammaOpt.gradient;
            ref bGrd = biasOpt.gradient;

            var gxH = rowIn * rowXHat;
            var sumG = (+ reduce rowIn);
            var sumGXHat = (+ reduce gxH);
            gGrd += gxH;
            bGrd += rowIn;
            var a = sumG / shape;
            var b = sumGXHat / shape;
            rowOut = (rowIn - a - rowXHat * b) * gamma / (s + eps); 
        }
        return outGradient;
    }

    proc updateParameter() {
        gammaOpt.gradient /= feedCount;
        biasOpt.gradient /= feedCount;

        AdamOpt(gamma, gammaOpt);
        AdamOpt(bias, biasOpt);

        feedCount = 0;
    }
    
    var domGamma: domain(1);
    var domBias: domain(1);
    var gamma: [domGamma] real;
    var bias: [domBias] real;

    var feedCount: int;
    var gammaOpt: AdamOptGradient1;
    var biasOpt: AdamOptGradient1;

    var domXHat: domain(2) dmapped new replicatedDist();
    var domStd: domain(1) dmapped new replicatedDist();
    var xHat: [domXHat] real;
    var std: [domStd] real;
}