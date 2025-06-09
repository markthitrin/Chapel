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
        dropout = new DropOout(dropoutRate);
        linear2 = new Linear(dFF, dModel);
    }

    proc forward(ref tensor: [?D] real) : [D] real {
        return 
        linear2.forward(
        dropout.forward(
        relu.forward(
        linear1.forward(
        tensor
        ))));
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        return 
        linear2.predict(
        dropout.predict(
        relu.predict(
        linear1.predict(
        tensor
        ))));
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        return 
        linear1.backward(
        relu.backward(
        dropout.backward(
        linear2.backward(
        gradient
        ))));
    }

    proc updateParameter() {
        linear1.updateParameter();
        linear2.updateParameter();
    }

    var linear1: Linear;
    var relu: RelU;
    var dropout: DropOut;
    var linear2: Linear;
}