use IO;

try {
  var myFile = open("test-file.txt", ioMode.cw);

  var myFileWriter = myFile.writer(locking=false);                                              // no parallel, no need lock
  var x: int = 17;

  myFileWriter.write(x);                                                                        // write

} catch e: Error {

}




try {
  var myFile = open("test-file.txt", ioMode.r);
  var myFileReader = myFile.reader(locking=false);

  var x: int;

  var readSomething = myFileReader.read(x);                                                     // read

  writeln("Read integer ", x);

} catch e: Error {

}



var x: int;
var y: real;

var ok:bool = read(x, y);


x = read(int);
y = read(real);

(x, y) = read(int, real);




// A record 'R' that serializes as an integer
record R : writeSerializable, readDeserializable {
  var x : int;

  proc serialize(writer: fileWriter(locking=false, ?),                                          // override the serailize
                 ref serializer: ?st) throws {
    writer.write(x);
  }

  proc deserialize(reader: fileReader(locking=false, ?),                                        // override the desetialize
                 ref deserializer: ?st) throws {
    reader.read(x);
  }
}

var val = new R(5);
writeln(val); // prints '5'