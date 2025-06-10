use IO;
use Data;
use Decoder;
use Config;
use Util;

param trainingSize = 700000;
param trainingIteration = 100;

proc main() {
    try {
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

        for i in 1..trainingIteration {
            var (input, target) = getData(data[0..#trainingSize], batch, sequenceLength);
            var output = model.forward(input, sequenceLength);
            var outGradient = output;
            var loss = CrossEntropy(output, target, outGradient);
            writeln("loss : ",loss);
            model.backward(outGradient, sequenceLength);
            model.updateParameter();
        }
    }
    catch e : Error {
        writeln("erro something");
    }
}