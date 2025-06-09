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

    proc forward(ref tensor: [?D] real) : [D] real {
        var x1 = norm1.forward(tensor);
        var x2 = x1 + dropout1.forward(mulAtt.forward(x1, x1, x1));
        return x2 + dropout2.forward(pff.forward(norm2.forward(x2)));
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        var x1 = norm1.predict(tensor);
        var x2 = tensor + dropout1.predict(mulAtt.predict(x1, x1, x1));
        return x2 + dropout2.predict(pff.predict(norm2.predict(x2)));
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        var g1 = gradient + norm2.backward(pff.backward(dropout2.backward(gradient)));
        var (g2Q, g2K, g2V) = mulAtt.backward(dropout2.backward(g1));
        return g1 + norm1.backward(g2Q + g2K + g2V);
    }

    proc updateParameter() {
        norm1.updateParameter();
        mulAtt.updateParameter();
        norm2.updateParameter();
        pff.updateParameter();
    }

    var norm1: LayerNorm;
    var mulAtt: MultiheadAttention;
    var dropout1: DropOut;
    var norm2: LayerNorm;
    var pff: PositionwiseFeedForward;
    var dropout2: DropOut;
}