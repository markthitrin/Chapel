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
        WQ = Matrix(domWQ);
        WK = Matrix(domWK);
        WV = Matrix(domWV);
        WO = Matrix(domWO);
        XavierUniformInit(WQ);
        XavierUniformInit(WK);
        XavierUniformInit(WV);
        XavierUniformInit(WO);

        feedCount = 0;
        WQOpt = new AdamOptGradient2(WQ);
        WKOpt = new AdamOptGradient2(WK);
        WVOpt = new AdamOptGradient2(WV);
        WOOpt = new AdamOptGradient2(WO);
        
        softmax = new Softmax();
    }

    proc forward(ref tensorQ: [?D] real, ref tensorK: [D] real, ref tensorV: [D] real, in l: int) : [D] real {
        domInputQ = D;
        domInputK = D;
        domInputV = D;
        inputQ = tensorQ;
        inputK = tensorK;
        inputV = tensorV;

        var batch: int = D.dim(0).size / l;
        var qPerHead: int = qshape / head;
        var outPerHead: int = dModel / head;
        
        domQT = {0..#(batch * qshape),0..#l};
        domKT = {0..#(batch * qshape),0..#l};
        domVT = {0..#(batch * dModel),0..#l};
        domA = {0..#(batch * head * l),0..#l};
        domAs = {0..#(batch * head * l),0..#l};
        domOT = {0..#(batch * dModel),0..#l};
        var output = Matrix(batch * l, dModel);

        forall i in 0..#batch {
            QT[(i * qshape)..#qshape, ..] = dot(WQ, inputQ[(i * l)..#l, ..].T);
            KT[(i * qshape)..#qshape, ..] = dot(WK, inputK[(i * l)..#l, ..].T);
            VT[(i * dModel)..#dModel, ..] = dot(WV, inputV[(i * l)..#l, ..].T);
        }
        forall ij in 0..#(batch * head) {
            A[(ij * l)..#l, ..] = dot(QT[(ij * qPerHead)..#qPerHead, ..].T, KT[(ij * qPerHead)..#qPerHead, ..]);
        }
        A = A / sqrt(qPerHead);
        forall ij in 0..#(batch * head) {
            forall k in 1..<l {
                forall w in 0..<k {
                    A[(ij * l) + k, w] = -1e9;
                }
            }
        }
        As = softmax.forward(A);
        forall ij in 0..#(batch * head) {
            OT[(ij * outPerHead)..#outPerHead, ..] = dot(VT[(ij * outPerHead)..#outPerHead, ..], As[(ij * l)..#l, ..].T);
        }
        forall i in 0..#batch {
            output[(i * l)..#l, ..] = dot(OT[(i * dModel)..#dModel, ..].T, WO);
        }
        return output;
    }

    proc predict(ref tensorQ: [?D] real, ref tensorK: [D] real, ref tensorV: [D] real, in l: int) : [D] real {
        return forward(tensorQ, tensorK, tensorV, l);
    }

    proc backward(ref gradient: [?D] real, in l: int) : 3 * ([D] real) {
        var outGradientQ = Matrix(D);
        var outGradientK = Matrix(D);
        var outGradientV = Matrix(D);

        var batch: int = D.dim(0).size / l;
        var qPerHead: int = qshape / head;
        var outPerHead: int = dModel / head;

        var QTGradient = Matrix(domQT);
        var KTGradient = Matrix(domKT);
        var VTGradient = Matrix(domVT);
        var AGradient = Matrix(domA);
        var AsGradient = Matrix(domAs);
        var OTGradient = Matrix(domOT);

        feedCount += 1;
        forall i in 0..#batch {
            WOOpt.gradient += dot(OT[(i * dModel)..#dModel, ..], gradient[(i * l)..#l, ..]);
            OTGradient[(i * dModel)..#dModel, ..] = dot(WO, gradient[(i * l)..#l, ..].T);
        }
        forall ij in 0..#(batch * head) {
            AsGradient[(ij * l)..#l, ..] = dot(OTGradient[(ij * outPerHead)..#outPerHead, ..].T, VT[(ij * outPerHead)..#outPerHead, ..]);
            VTGradient[(ij * outPerHead)..#outPerHead, ..] = dot(OT[(ij * outPerHead)..#outPerHead, ..], As[(ij * l)..#l, ..]);
        }
        AGradient = softmax.backward(AsGradient) / sqrt(qPerHead);
        forall ij in 0..#(batch * head) {
            AGradient[(ij * l)..#l, ..] = triu(AGradient[(ij * l)..#l, ..]);
        } 
        forall ij in 0..#(batch * head) {
            KTGradient[(ij * qPerHead)..#qPerHead, ..] = dot(QT[(ij * qPerHead)..#qPerHead, ..], AGradient[(ij * l)..#l, ..]);
            QTGradient[(ij * qPerHead)..#qPerHead, ..] = dot(KT[(ij * qPerHead)..#qPerHead, ..], AGradient[(ij * l)..#l, ..].T);
        }
        forall i in 0..#batch {
            WQOpt.gradient += dot(QTGradient[(i * qshape)..#qshape, ..], inputQ[(i * l)..#l, ..]);
            WKOpt.gradient += dot(KTGradient[(i * qshape)..#qshape, ..], inputK[(i * l)..#l, ..]);
            WVOpt.gradient += dot(VTGradient[(i * dModel)..#dModel, ..], inputV[(i * l)..#l, ..]);
            outGradientQ[(i * l)..#l, ..] = dot(QTGradient[(i * qshape)..#qshape, ..].T, WQ);
            outGradientK[(i * l)..#l, ..] = dot(KTGradient[(i * qshape)..#qshape, ..].T, WK);
            outGradientV[(i * l)..#l, ..] = dot(VTGradient[(i * dModel)..#dModel, ..].T, WV);
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

    var feedCount: int;
    var WQOpt: AdamOptGradient2;
    var WKOpt: AdamOptGradient2;
    var WVOpt: AdamOptGradient2;
    var WOOpt: AdamOptGradient2;

    var softmax: owned Softmax;

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