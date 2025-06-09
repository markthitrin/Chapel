use LinearAlgebra;
use Util;
use Math;
use Config;
use Softmax;

class MultiheadAttention {
    proc init() {
        domWQ = {0..#qshape, 0..#dModel};
        domWK = {0..#qshape, 0..#dModel};
        domWV = {0..#dModel, 0..#dModel};
        domWO = {0..#dModel, 0..#dModel};
        HeNormalInit(WQ);
        HeNormalInit(WK);
        HeNormalInit(WV);
        HeNormalInit(WO);

        feedCount = 0;
        WQOpt = new AdamOptGradient(WQ);
        WKOpt = new AdamOptGradient(WK);
        WVOpt = new AdamOptGradient(WV);
        WOOpt = new AdamOptGradient(WO);
    }

    proc forward(ref tensorQ: [?D] real, ref tensorK: [D] real, ref tensorV: [D] real, in l: int) : [D] real {
        inputQ = tensorQ;
        inputK = tensorK;
        inputV = tensorV;

        var batch: int = D.dim(0) / l;
        var qPerHead: int = qshape / head;
        var outPerHead: int = dModel / head;
        
        domQT = {0..#(batch * qshape),0..#l};
        domKT = {0..#(batch * qshape),0..#l};
        domVT = {0..#(batch * dModel),0..#l};
        domA = {0..#(batch * head * l),0..#l};
        domAs = {0..#(batch * head * l),0..#l};
        domOT = {0..#(batch * dModel),0..#l};
        var output = Matrix(batch * l, dModel);

        for i in 0..#batch {
            QT[(i * qshape)..#qshape, ..] = dot(WQ, tensorQ[(i * l)..#l, ..].T);
            KT[(i * qshape)..#qshape, ..] = dot(WK, tensorQ[(i * l)..#l, ..].T);
            VT[(i * dModel)..#dModel, ..] = dot(WV, tensorQ[(i * l)..#l, ..].T);
        }
        for i in 0..#batch {
            for j in 0..#head {
                var ij = (i * head + j);
                A[(ij * l)..#l, ..] = dot(QT[(ij * qPerHead)..#qPerHead, ..].T, KT[(ij * qPerHead)..#qPerHead]);
            }
        }
        A = triu(A) / sqrt(qPerHead);
        As = softmax.forward(A);
        for i in 0..#batch {
            for j in 0..#head {
                var ij = (i * head + j);
                OT[(ij * outPerHead)..#outPerHead, ..] = dot(VT[(ij * outPerHead)..#outPerHead, ..], As[(ij * l)..#l, ..].T);
            }
        }
        for i in 0..#batch {
            output[(i * l)..#l, ..] = dot(OT[(i * dModel)..#dModel, ..].T, WO);
        }
    }

    proc predict(ref tensorQ: [?D] real, ref tensorK: [D] real, ref tensorV: [D] real, in l: int) : [D] real {
        return forward(tensorQ, tensorK, tensorV, l);
    }

    proc backward(ref gradient: [?D] real) : [D] real {
        var outGradientQ = Matrix(D);
        var outGradientK = Matrix(D);
        var outGradientV = Matrix(D);

        var batch: int = D.dim(0) / l;
        var qPerHead: int = qshape / head;
        var outPerHead: int = dModel / head;

        var QTGradient = Matrix(domQT);
        var KTGradient = Matrix(domKT);
        var VTGradient = Matrix(domVT);
        var AGradient = Matrix(domA);
        var AsGradient = Matrix(domAs);
        var OTGradient = Matrix(domOT);
        var outGradient = Matrix(D);

        feedCount = 0;
        for i in 0..#batch {
            WOOpt.gradient += dot(OT[(i * dModel)..#dModel, ..], gradient[(i * l)..#l, ..]);
            OTGradient[(i * dModel)..#dModel, ..] = dot(WO, gradient[(i * l)..#l, ..].T);
        }
        for i in 0..#batch {
            for j in 0..#head {
                var ij = (i * head + j);
                AsGradient[(ij * l)..#l, ..] = dot(OTGradient[(ij * outPerHead)..#outPerHead, ..].T, VT[(ij * outPerHead)..#outPerHead, ..]);
                VTGradient[(ij * outPerHead)..#outPerHead, ..] = dot(OT[(ij * outPerHead)..#outPerHead, ..], As[(ij * l)..#l, ..]);
            }
        }
        AGradient = triu(softmax.backward()) / sqrt(qPerHead);
        for i in 0..#batch {
            for j in 0..#head {
                var ij = (i * head + j);
                KTGradient[(ij * qPerHead)..#qPerHead, ..] = dot(QT[(ij * qPerHead)..#qPerHead, ..], AGradient[(ij * l)..#l, ..]);
                QTGradient[(ij * qPerHead)..#qPerHead, ..] = dot(KT[(ij * qPerHead)..#qPerHead, ..], AGradient[(ij * l)..#l, ..].T);
            }
        }
        for i in 0..#batch {
            WQGradient += dot(QTGradient[(i * qshape)..#qshape, ..], inputQ[(i * l)..#l, ..]);
            WKGradient += dot(KTGradient[(i * qshape)..#qshape, ..], inputK[(i * l)..#l, ..]);
            WVGradient += dot(VTGradient[(i * dModel)..#dModel, ..], inputV[(i * l)..#l, ..]);
            outGradientQ += dot(QTGradient[(i * qshape)..#qshape, ..].T, WQ);
            outGradientK += dot(KTGradient[(i * qshape)..#qshape, ..].T, WK);
            outGradientV += dot(VTGradient[(i * dModel)..#dModel, ..].T, WV);
        }
        return (outGradientQ, outGradientK, outGradientV);
    }

    proc updateParameter() {
        WQOpt.gradient /= feedCount;
        WKOpt.gradient /= feedCount;
        WVOpt.gradient /= feedCount;
        WOOpt.gradient /= feedCount;

        AdamOpt(WQ, WQOpt);
        AdamOpt(WK, WKOpt);
        AdamOpt(WV, WVOpt);
        AdamOpt(WO, WOOpt);

        WQOpt.gradient = 0;
        WKOpt.gradient = 0;
        WVOpt.gradient = 0;
        WOOpt.gradient = 0;
        feedCount = 0;
    }

    var domWQ: domain(2);
    var domWK: domain(2);
    var domWV: domain(2);
    var domWO: domain(2);
    var WQ: [domWQ] real;
    var WK: [domWK] real;
    var WV: [domWV] real;
    var WO: [domWO] real;

    var feedCount = 0;
    var WQOpt: AdamOptGradient;
    var WKOpt: AdamOptGradient;
    var WVOpt: AdamOptGradient;
    var WOOpt: AdamOptGradient;

    var softmax: Softmax;

    var domQT: domain(2);
    var domKT: domain(2);
    var domVT: domain(2);
    var domA: domain(2);
    var domAs: domain(2);
    var domOT: domain(2);
    var domInputQ: domain(2);
    var domInputK: domain(2);
    var domInputV: domain(2);
    var QT: [domQT] real;
    var KT: [domKT] real;
    var VT: [domVT] real;
    var A: [domA] real;
    var As: [domAs] real;
    var OT: [domOT] real;
    var inputQ: [domInputQ] real;
    var inputK: [domInputK] real;
    var inputV: [domInputV] real;
}