use LinearAlgebra;
use Util;

class LayerNorm {

    proc init(in shape: int) {
        domGamma = {0..#shape};
        domBias = {0..#shape};
        gamma = 1.0;
        bias = 0.0;

        feedCount = 0;
        gammaOpt = new AdamOptGradient(gamma);
        biasOpt = new AdamOptGradient(bias);
    }

    proc forward(ref tensor: [?D] real) : [D] real {
        var shape = D.dim(1).size;
        var output = Matrix(D);
        domXHat = D;
        domStd = {D.dim(0)};
        for i in D.dim(0) {
            ref rowIn = tensor[i, ..];
            ref rowOut = output[i, ..];
            ref rowXHat = xHat[i, ..];
            ref s = std[i];
            var g = gamma[i];
            var b = bias[i];

            var mean: real = (+ reduce rowIn) / shape;
            s = sqrt((+ reduce rowIn**2) / shape);
            rowXHat = (rowIn - mean) / (s + eps);
            rowOut = g * rowXHat + b;
        }
        return output;
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        return forward(tensor);
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        var shape = D.dim(1).size;
        var outGradient = Matrix(D);
        for i in D.dim(0) {
            ref rowIn = gradient[i, ..];
            ref rowOut = outGradient[i, ..];
            ref rowXHAT = xHat[i, ..];
            var s = std[i];
            var g = gamma[i];
            ref gGrd = gammaOpt.gradient[i];
            ref bGrd = biasOpt.gradient[i];

            var gxH = rowIn * rowXHat;
            var sumG = (+ reduce rowIn);
            var sumGXHat = (+ reduce gxH);
            gGrd = (+ reduce gxH);
            bGrd = (+ reduce rowIn);
            var a = sumG / shape[1];
            var b = sumGXHat / shape[1];
            rowOut = (rowIn - a - rowXHat * b) * g / s; 
        }
        return outGradient;
    }

    proc updateparameter() {
        gammaOpt.gradient /= feedCount;
        biasOpt.gradient /= feedCount;

        AdamOpt(gamma, gammaOpt);
        AdamOpt(bias, biasOpt);

        gammaOpt.gradient = 0;
        biasOpt.gradient = 0;
        feedCount = 0;
    }
    
    var domGamma: domain(1);
    var domBias: domain(1);
    var gamma: [domGamma] real;
    var bias: [domBias] real;

    var feedCount: int;
    var gammaOpt: AdamOptGradient;
    var biasOpt: AdamOptGradient;

    var domXHat: domain(2);
    var domStd: domain(2);
    var xHat: [domXHat] real;
    var std: [domStd] real;
}