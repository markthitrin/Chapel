use LinearAlgebra;
use Util;
use Math;
use Config;

class PositionalEncoder {
    proc forward(ref tensor: [?D] real, in l: int) : [D] real {
        var shape: int = D.dim(1).size;
        var output = Matrix(D);
        for (i,j) in D {
            var subL: int = i / l;
            if j % 2 == 0 {
                output[i,j] = tensor[i,j] + sin(subL / pow(10000, j:real / shape));
            } 
            else {
                output[i,j] = tensor[i,j] + cos(subL / pow(10000, j:real / shape));
            }
        }
        return output;
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        return forward(tensor);   
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        return gradient;
    }
}