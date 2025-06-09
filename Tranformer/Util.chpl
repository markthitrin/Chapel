use LinearAlgebra;
use Random;
use Config;
use Math;

var rng = new randomStream(eltType=real);

record AdamOptGradient {
    proc init(ref parameter: [?D] real) {
        dom = D;
        t = 0;
    }
    
    var dom: domain(2);
    var gradient: [dom] real;
    var accM: [dom] real;
    var accV: [dom] real;
    var t: int;
};

proc AdamOpt(ref parameter: [?D] real, ref optimizer: AdamOptGradient) {
    var learningRate: real = sqrt(dModel) * min(pow(optimizer.t, -0.5), optimizer.t * pow(warmupStep, -1.5));
    optimizer.accM = optimizer.accM * beta1 + optimizer.gradient * (1.0 - beta1);
    optimizer.accV = optimizer.accV * beta2 + optimizer.gradient ** 2 * (1.0 - beta2);
    parameter -= learningRate * (optimizer.mHat / beta1) / (sqrt(optimizer.accV / beta2) + eps);
    optimizer.t += 1;
}

proc CrossEntropy(ref output: [?D1] real, const ref target: [?D2] real, ref outGradient: [D1] real) : real {
    outGradient = 0.0;
    var loss = 0.0;
    var d = D1.dim(0).size;
    for i in 1..d {
        var rowOut = output[i, ..];
        var rowGrd = outGradient[i, ..];
        var targetToken = target[i];
        if(rowOut[targetToken] < 1e-8) {
            rowGrd[targetToken] = -1.0 / 1e-8 / d;
        }
        else {
            rowGrd[targetToken] = -1.0 / rowOut[targetToken] / d;
        }

        loss += log(rowOut);
    }
    loss *= -1.0 / d;
    return loss;
}

proc XavierUniformInit(ref parameter: [?D] real) {
    var (inD, outD) = D;
    var limit = sqrt(6.0 / (inD + outD));
    fillRandom(parameter, -limit, limit);
}

proc UniformInit(ref parameter: [?D] real, in limit: real) {
    fillRandom(parameter, -limit, limit);
}

proc sampleNormal (in mu: real, in sigma: real) : real {
  const u1 = rng.getNext();
  const u2 = rng.getNext();
  const z0 = sqrt(-2 * log(u1)) * cos(2 * pi * u2);
  return mu + sigma * z0;
}

proc HeNormalInit(ref parameter: [?D] real) {
    var inD = parameter.shape[0];
    var stddev = sqrt(2.0 / inD);
    for p in parameter {
        p = sampleNormal(0.0, stddev);
    }
}