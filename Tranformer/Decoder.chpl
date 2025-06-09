use LinearAlgebra;
use Util;
use Math;
use Config;
use DecoderLayer;
use Embedding;


class Decoder {
    proc init(in numTokens: int, in N: int) {
        embedding = new Embedding(numTokens);
        positionalEncoder = new PositionalEncoder();
        domDecoderLayer = {0..#N};
        for i in domDecoderLayer {
            decoderLayers[i] = new DecoderLayer();
        }
        norm = new LayerNorm(dModel);
        linear = new Linear(dModel, numTokens);
        softmax = new Softmax();
    }

    proc forward(ref tensor: [?D] real) : [D] real {
        var x = positionalEncoder.forward(embedding.forward(tensor));
        for i in domDecoderLayer {
            x = decoderLayers[i].forward(x);
        }
        return softmax.forward(linear.forward(norm.forward(x)));
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        var x = positionalEncoder.predict(embedding.predict(tensor));
        for i in domDecoderLayer {
            x = decoderLayers[i].forward(x);
        }
        return softmax.predict(linear.predict(norm.predict(x)));
    }

    proc backward(ref gradient: [?D] real) {
        var g = norm.backward(linear.backward(softmax.backward(gradient)));
        for i in domDecoderLayer by -1 {
            g = decoderLayers[i].backward(g);
        }
        embedding.backward(positionalEncoder.backward(g));
    }

    proc updateParameter() {
        embedding.updateParameter();
        for i in domDecoderLayer {
            decoderLayers[i].updateParameter();
        }
        norm.updateParameter();
        linear.updateParameter();
    }

    var embedding: Embedding;
    var positionalEncoder: PositionalEncoder;
    var domDecoderLayer = domain(1);
    var decoderLayers = [domDecoderLayer] DecoderLayer;
    var norm: LayerNorm;
    var linear: Linear;
    var softmax: Softmax;
}