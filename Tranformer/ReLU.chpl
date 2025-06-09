use LinearAlgebra;

class ReLU {
    proc forward(ref tensor: [?D] real) : [D] real {
        domMask = D;
        mask = [i in D] if tensor[i] >= 0 then 1.0 else 0.0;
        return tensor * mask;
    }   

    proc predict(ref tensor: [?D] real) : [D] real {
        return forward(tensor);
    }

    proc backward(ref gradient : [?D] real) : [D] real {
        return gradient * mask;
    }

    var domMask = domain(2);
    var mask: [domMask] real;
}