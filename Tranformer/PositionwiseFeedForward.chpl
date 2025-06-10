use LinearAlgebra;
use Util;
use Math;
use Linear;
use DropOut;
use ReLU;
use Config;

class PositionwiseFeedForward {
    proc init() {
        linear1 = new Linear(dModel, dFF);
        relu = new ReLU();
        dropout = new DropOut(dropoutRate);
        linear2 = new Linear(dFF, dModel);
    }

    proc forward(ref tensor: [?D] real) : [D] real {
        var x1 = linear1.forward(tensor);
        var x2 = relu.forward(x1);
        var x3 = dropout.forward(x2);
        return linear2.forward(x3);
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        var x1 = linear1.predict(tensor);
        var x2 = relu.predict(x1);
        var x3 = dropout.predict(x2);
        return linear2.predict(x3);
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        var g1 = linear2.backward(gradient);
        var g2 = dropout.backward(g1);
        var g3 = relu.backward(g2);
        return linear1.backward(g3);
    }

    proc updateParameter() {
        cobegin {
            linear1.updateParameter();
            linear2.updateParameter();
        }
    }

    var linear1: owned Linear;
    var relu: owned ReLU;
    var dropout: owned DropOut;
    var linear2: owned Linear;
}