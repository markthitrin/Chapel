use LinearAlgebra;
use Util;
use Math;
use Config;
use ReplicatedDist;

class Embedding {
    proc init(in numTokens: int) {
        domTable = {0..#numTokens, 0..#dModel};
        table = Matrix(domTable);
        UniformInit(table, 0.1);

        feedCount = 0;
        domTableOpt = {0..#numTokens};
        tableOpt = forall i in domTableOpt do new AdamOptGradient1(table[i, ..]);
    }

    proc forward(ref tensor: [?D] real) : [{D.dim(0), 0..#dModel}] real {
        domToken = D;
        token = tensor;
        var output = Matrix(D.dim(0).size, dModel);
        forall i in D.dim(0) {
            output[i, ..] = table[tensor[i]:int, ..];
        }
        return output;
    }

    proc predict(ref tensor: [?D] real) : [{D.dim(0), 0..#dModel}] real {
        return forward(tensor);
    }

    proc backward(ref gradient: [?D] real) {
        feedCount += 1;
        for i in D.dim(0) {
            tableOpt[token[i]:int].gradient += gradient[i, ..]; 
        }
    }

    proc updateParameter() {
        // fix to to make it individual later
        forall i in domTableOpt {
            tableOpt[i].gradient /= feedCount;

            AdamOpt(table[i, ..], tableOpt[i]);
        }
        feedCount = 0;
    }

    var domTable: domain(2);
    var table: [domTable] real;
    
    var feedCount: int;
    var domTableOpt: domain(1);
    var tableOpt: [domTableOpt] AdamOptGradient1;
    
    var domToken: domain(1) dmapped new replicatedDist();
    var token: [domToken] real;
}