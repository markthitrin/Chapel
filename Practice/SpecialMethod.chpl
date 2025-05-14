record R {
  var a: int;
  
  proc init() {
    writeln("This is INIt");
  }

  proc postinit() {
    writeln("This is post init");                                               // post init do after the init function is called
  }
}

var a :R;



{

  record R2 {
    proc func1() {
      writeln("This is primary Method");                                        // primary method, the function declare in the class/record
    }
  }
  proc R2.func2() {
    writeln("this is secondary Method");                                        // secondary method, the function declare outside 
  }                                                                             // the class/record but in the same scope
  
  var a2:R2;
}




record R3 : hashable, writeSerializable, readDeserializable {
  param size: int = 10;
  var vals: size*int;                                                           // tuple 10 int -> (int,int,int,int,...,int)
}



var a1:R3;
var a2:R3;


use Map;

proc R3.hash(): uint {                                                        // Note that the this is user-custom hasing function
  writeln("hashing");                                                         // The default of hasing function auto created if == and != isn't implemented
  return vals[0]: uint;
}

var m0 = new map(R3, int);
var m1: domain(R3);
var m2 = new R3();

writeln(m0);
writeln(m1);
writeln(m2);


m0[m2] = 10;                                                                  // hashing
m1 += m2;                                                                     // hashing





use IO;                                                                       // The serial and deserial is for file writing and reading

config const filename = "tempfile.txt";

proc R3.serialize(writer: fileWriter(?),
                 ref serializer: writer.serializerType) throws {
  writer.write("*", vals, "*");
}

{
  var fw = openWriter(filename);
  fw.writeln(r);
}

proc ref R3.deserialize(reader: fileReader(?),
                       ref deserializer: reader.deserializerType) throws {
  reader.readLiteral("*");
  reader.read(vals);
  reader.readLiteral("*");
}

{
  var fr = openReader(filename);
  var r2 = new R();
  fr.readln(r2);
  assert(r == r2);
}

{
  var fw = openWriter(filename);
  fw.writeln(r);
  fw.flush();

  writeln(r);
  var r2 = new R3();
  var fr = openReader(filename);
  fr.readln(r2);
  assert(r == r2);
}

{
  use FileSystem;
  if exists(filename) then
    remove(filename);
}