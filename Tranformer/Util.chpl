use LinearAlgebra;
use Random;
use Config;
use Math;
use CTypes;
use ReplicatedDist;

var rng = new randomStream(eltType=real);

record AdamOptGradient1 {
    proc init(ref parameter: [?D] real) {
        domDist = D;
        dom = D;
        t = 0;
    }
    
    var domDist: domain(1) dmapped new replicatedDist();
    var dom: domain(1);
    var gradient: [domDist] real;
    var accM: [dom] real;
    var accV: [dom] real;
    var t: int;
};

record AdamOptGradient2 {
    proc init(ref parameter: [?D] real) {
        domDist = D;
        dom = D;
        t = 0;
    }
    
    var domDist: domain(2) dmapped new replicatedDist();
    var dom: domain(2);
    var gradient: [dom] real;
    var accM: [dom] real;
    var accV: [dom] real;
    var t: int;
};

proc AdamOpt(ref parameter: [?D] real, ref optimizer: AdamOptGradient1) {
    var totalGradient = Matrix(D);
    coforall i in 0..#numLocales with (+ reduce totalGradient) {
        on Locales[i] {
            totalGradient += optimizer.gradient;
            optimizer.gradient = 0;
        }
    }
    var learningRate: real = sqrt(dModel) * min(optimizer.t ** -0.5, optimizer.t * warmupStep ** -1.5);
    optimizer.accM = optimizer.accM * beta1 + totalGradient * (1.0 - beta1);
    optimizer.accV = optimizer.accV * beta2 + totalGradient ** 2 * (1.0 - beta2);
    parameter -= learningRate * (optimizer.accM / beta1) / (sqrt(optimizer.accV / beta2) + eps);
    optimizer.t += 1;
}

proc AdamOpt(ref parameter: [?D] real, ref optimizer: AdamOptGradient2) {
    var totalGradient = Matrix(D);
    coforall i in 0..#numLocales with (+ reduce totalGradient) {
        on Locales[i] {
            totalGradient += optimizer.gradient;
            optimizer.gradient = 0;
        }
    }
    var learningRate: real = sqrt(dModel) * min(optimizer.t ** -0.5, optimizer.t * warmupStep ** -1.5);
    optimizer.accM = optimizer.accM * beta1 + totalGradient * (1.0 - beta1);
    optimizer.accV = optimizer.accV * beta2 + totalGradient ** 2 * (1.0 - beta2);
    parameter -= learningRate * (optimizer.accM / beta1) / (sqrt(optimizer.accV / beta2) + eps);
    optimizer.t += 1;
}

proc CrossEntropy(ref output: [?D1] real, const ref target: [?D2] real, ref outGradient: [D1] real) : real {
    outGradient = 0.0;
    var loss = 0.0;
    var d = D1.dim(0).size;
    for i in 0..#d {
        ref rowOut = output[i, ..];
        ref rowGrd = outGradient[i, ..];
        var targetToken = target[i]:int;
        if(rowOut[targetToken] < 1e-8) {
            rowGrd[targetToken] = -1.0 / 1e-8 / d;
        }
        else {
            rowGrd[targetToken] = -1.0 / rowOut[targetToken] / d;
        }

        loss += fast_log2(rowOut[targetToken]);
    }
    loss /= -d;
    return loss;
}

proc XavierUniformInit(ref parameter: [?D] real) {
    var size = D.size;
    var limit = sqrt(6.0 / size);
    fillRandom(parameter, -limit, limit);
}

proc UniformInit(ref parameter: [?D] real, in limit: real) {
    fillRandom(parameter, -limit, limit);
}

proc sampleNormal (in mu: real, in sigma: real) : real {
  const u1 = rng.next();
  const u2 = rng.next();
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

proc bitcast(x : real(64)) : int(64) {
    var u = x;
    var r: int(64);
    var p = c_ptrTo(u);
    r = (p:c_ptr(int(64))).deref();
    return r;
}

proc fast_log2(x: real): real {
  if x <= 0.0 then
    halt("Input must be positive");

  var bits = bitcast(x);  
  var exponent = ((bits >> 52) & 0x7FF):int - 1023; 
  var mantissa = (bits & 0xFFFFFFFFFFFFF) | (1 << 52); 
  var m = mantissa:real / (1 << 52);
  return exponent:real + (m - 1.0);
}