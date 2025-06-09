use LinearAlgebra;
use Util;
use Math;
use Config;

class Embedding {
    proc init(in numTokens: int) {
        domTable = {0..#numTokens, 0..#dModel};
        domTableOpt = {0..#numTokens};
        for i in domTableOpt {
            tableOpt[i] = new AdamOptGradient(table[i, ..]);
        }
        feedCount = 0;
    }

    proc forward(ref tensor: [?D] real) : [D] real {
        domToken = D.dim(0);
        token = tensor;
        var output = Matrix(D.dim(0),dModel);
        for i in D.dim(0) {
            output[i, ..] = table[tensor[i]:int, ..];
        }
        return output;
    }

    proc predict(ref tensor: [?D] real) : [D] real {
        return forward(tensor);
    }

    proc backward(ref gradient: [?D] real) {
        feedCount += 1;
        for i in D.dim(0) {
            tableOpt[token[i]].gradient += gradient[i]; 
        }
    }

    proc updateParameter() {
        // fix to to make it individual later
        for i in domTableOpt {
            domTableOpt[i].gradient /= feedCount;

            AdamOpt(table[i, ..], tableOpt[i]);

            tableOpt[i].gradient = 0.0;
        }
        feedCount = 0;
    }

    var domTable: domain(2);
    var table: [domTable] real;
    
    var feedCount: int;
    var domTableOpt: domain(1);
    var tableOpt: [domTableOpt] AdamOptGradient;
    
    var domToken: domain(1);
    var token: [domToken] int;
}