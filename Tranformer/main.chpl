use IO;
use Data;
use Decoder;
use Config;
use Util;
use Time;

param trainingSize = 700000;
param trainingIteration = 2000;
param testIteration = 10;

proc main() {
    try {
        var t: stopwatch;
        var dataFile = open("DatasetToken.txt", ioMode.r);
        var translateFile = open("DatasetTranslate.txt", ioMode.r);
        var dataReader = dataFile.reader(locking=false);
        var translateReader = translateFile.reader(locking=false);

        var dataMaxSize = 1110000;
        var translateMaxSize = 66;
        var data: [{0..#dataMaxSize}] int;
        var translate: [{0..#translateMaxSize}] int;
        for i in 0..#dataMaxSize {
            data[i] = dataReader.read(int);
        }
        for i in 0..#translateMaxSize {
            translate[i] = translateReader.read(int);
        }

        var model = new Decoder(translateMaxSize, 6);
        var avgTime = 0.0;

        for i in 1..trainingIteration {
            t.start();
            var (input, target) = getData(data[0..#trainingSize], batch, sequenceLength);
            var output = model.forward(input, sequenceLength);
            var outGradient = output;
            // for i in 0..#(batch * sequenceLength) {
            //     var row = output[i, ..];
            //     var maxVal = 0.0;
            //     var maxLoc = 0;
            //     for k in 0..#translateMaxSize {
            //         if (row[k] > maxVal) {
            //             maxLoc= k;
            //             maxVal = row[k];
            //         }
            //     }
            //     writeln(maxVal, " aaaaaa ::: ", maxLoc);
            // }
            var loss = CrossEntropy(output, target, outGradient);
            write("Iteration : ", i , " / ",trainingIteration,"loss : ",loss);
            model.backward(outGradient, sequenceLength);
            model.updateParameter();
            t.stop();
            avgTime += t.elapsed();
            writeln(" Speed :", 1.0 / (avgTime / i), " iteration Per second");
            t.clear();
        }
        for i in 1..testIteration {
            var (input, target) = getData(data[trainingSize..], batch, sequenceLength);
            var output = model.predict(input, sequenceLength);
            for i in 0..#batch {
                writeln("predict==========================");
                for j in 0..#sequenceLength {
                    var targetToken = target[i * sequenceLength + j];
                    var row = output[i * sequenceLength + j, ..];
                    var maxVal = 0.0;
                    var maxLoc = 0;
                    for k in 0..#translateMaxSize {
                        if (row[k] > maxVal) {
                            maxLoc= k;
                            maxVal = row[k];
                        }
                    }
                    writeln("target [",translate[targetToken:int],"] :: [",translate[maxLoc:int],"] :---:",maxVal);
                }
            }
        }
    }
    catch e : Error {
        writeln("erro something");
    }
}