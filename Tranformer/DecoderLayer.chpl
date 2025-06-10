use LinearAlgebra;
use Util;
use Math;
use Config;
use LayerNorm;
use MultiheadAttention;
use DropOut;
use PositionwiseFeedForward;

class DecoderLayer {
    proc init() {
        norm1 = new LayerNorm(dModel);
        mulAtt = new MultiheadAttention();
        dropout1 = new DropOut(dropoutRate);
        norm2 = new LayerNorm(dModel);
        pff = new PositionwiseFeedForward();
        dropout2 = new DropOut(dropoutRate);
    }

    proc forward(ref tensor: [?D] real, in l: int) : [D] real {
        var x1 = norm1.forward(tensor);
        var x2 = mulAtt.forward(x1, x1, x1, l);
        var x3 = tensor + dropout1.forward(x2);
        var x4 = norm2.forward(x3);
        var x5 = pff.forward(x4);
        return x3 + dropout2.forward(x5);
    }

    proc predict(ref tensor: [?D] real, in l: int) : [D] real {
        var x1 = norm1.predict(tensor);
        var x2 = mulAtt.predict(x1, x1, x1, l);
        var x3 = tensor + dropout1.predict(x2);
        var x4 = norm2.predict(x3);
        var x5 = pff.predict(x4);
        return x3 + dropout2.predict(x5);
    }

    proc backward(ref gradient: [?D] real, in l: int) : [D] real {
        var g1 = dropout2.backward(gradient);
        var g2 = pff.backward(g1);
        var g3 = gradient + norm2.backward(g2);
        var g4 = dropout2.backward(g3);
        var (g5Q, g5K, g5V) = mulAtt.backward(g4, l);
        var g5all = g5Q + g5K + g5V;
        return g3 + norm1.backward(g5all);
    }

    proc updateParameter() {
        norm1.updateParameter();
        mulAtt.updateParameter();
        norm2.updateParameter();
        pff.updateParameter();
    }

    var norm1: owned LayerNorm;
    var mulAtt: owned MultiheadAttention;
    var dropout1: owned DropOut;
    var norm2: owned LayerNorm;
    var pff: owned PositionwiseFeedForward;
    var dropout2: owned DropOut;
}