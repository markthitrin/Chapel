use LinearAlgebra;
use Util;
use Math;
use Config;
use DecoderLayer;
use Embedding;
use PositionalEncoder;
use LayerNorm;
use Linear;
use Softmax;
use ReplicatedDist;

iter localeIter(in N: int) {
    var each: int = N / numLocales;
    var s = 0;
    var e = each;
    while(s < N) {
        yield s..<min(N,e);
        s = e;
        e += each;
    }
}

class Decoder {
    proc init(in numTokens: int, in N: int) {
        this.numTokens = numTokens;
        embedding = new Embedding(numTokens);
        positionalEncoder = new PositionalEncoder();
        domDecoderLayer = {0..#N};
        decoderLayers = forall i in domDecoderLayer do new DecoderLayer();
        norm = new LayerNorm(dModel);
        linear = new Linear(dModel, numTokens);
        softmax = new Softmax();
    }

    proc forward(ref tensor: [?D] real, in l: int) : [{0..#D.dim(0).size, 0..#numTokens}] real {
        var output = Matrix(D.dim(0).size, numTokens);
        coforall (rge,loc) in zip(localeIter(D.dim(0).size), 0..) do on Locales[loc] {
            var x1 = embedding.forward(tensor[rge]);
            var xi = positionalEncoder.forward(x1, l);
            for i in domDecoderLayer {
                xi = decoderLayers[i].forward(xi, l);
            }
            var x2 = norm.forward(xi);
            var x3 = linear.forward(x2);
            output[rge, ..] = softmax.forward(x3);
        }
        return output;
    }

    proc predict(ref tensor: [?D] real, in l: int) : [{0..#D.dim(0).size, 0..#numTokens}] real {
        var output = Matrix(D.dim(0).size, numTokens);
        coforall (rge,loc) in zip(localeIter(D.dim(0).size), 0..) do on Locales[loc] {
            var x1 = embedding.predict(tensor[rge]);
            var xi = positionalEncoder.predict(x1, l);
            for i in domDecoderLayer {
                xi = decoderLayers[i].predict(xi, l);
            }
            var x2 = norm.predict(xi);
            var x3 = linear.predict(x2);
            output[rge, ..] = softmax.predict(x3);
        }
        return output;
    }

    proc backward(ref gradient: [?D] real, in l: int) {
        coforall (rge,loc) in zip(localeIter(D.dim(0).size), 0..) do on Locales[loc] {
            var g1 = softmax.backward(gradient[rge, ..]);
            var g2 = linear.backward(g1);
            var gi = norm.backward(g2);
            for i in domDecoderLayer by -1 {
                gi = decoderLayers[i].backward(gi, l);
            }
            embedding.backward(gi);
        }
    }

    proc updateParameter() {
        cobegin {
            embedding.updateParameter();
            forall i in domDecoderLayer {
                decoderLayers[i].updateParameter();
            }
            norm.updateParameter();
            linear.updateParameter();
        }
    }
    
    var numTokens: int;
    var embedding: owned Embedding;
    var positionalEncoder: owned PositionalEncoder;
    var domDecoderLayer: domain(1);
    var decoderLayers: [domDecoderLayer] owned DecoderLayer;
    var norm: owned LayerNorm;
    var linear: owned Linear;
    var softmax: owned Softmax;
}