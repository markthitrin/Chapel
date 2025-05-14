class TypeAliasField {
  type t;
  var a, b: t;
}

class ParamField {
  param p: int;
  var tup: p*int;
}

record UntypedField {
  var a;
}

                                                                                        // passing the unknown type/variable is required
var taf  = new TypeAliasField(real, 1.0, 2.0);
var taf2 = new TypeAliasField(int, 3, 4);
var taf3  = new TypeAliasField(real, 1.0);
var taf4  = new TypeAliasField(real);
var taf5  = new TypeAliasField(t = real, a = 10.0, b=0.0);
// var taf6  = new TypeAliasField(a=0.0);                                               // error this candidate did not match: TypeAliasField.init(type t, a: t, b: a.type
// var taf6  = new TypeAliasField(b=0.0);                                               // error this candidate did not match: TypeAliasField.init(type t, a: t, b: a.type 
// var taf6  = new TypeAliasField(real, 0.0, real);                                     // error this candidate did not match: TypeAliasField.init(type t, a: t, b: a.type
// var taf6  = new TypeAliasField(a = 0.0, b = 0.0);                                    // error this candidate did not match: TypeAliasField.init(type t, a: t, b: a.type
writeln("taf = ", taf, ", taf2 = ", taf2);

var pf  = new ParamField(3);
var pf2 = new ParamField(2);
writeln("pf = ", pf, ", pf2 = ", pf2);

var uf  = new UntypedField(3.14 + 2.72i);
var uf2 = new UntypedField(new ParamField(2));
writeln("uf = ", uf, ", uf2 = ", uf2);






var taf3: borrowed TypeAliasField(real)?;
var pf3: borrowed ParamField(3)?;
var uf3: UntypedField(complex);                                                         // use type instead of value to specify generic variable

taf3 = taf;
pf3 = pf;
uf3 = uf;

writeln("taf3 = ", taf3);
writeln("pf3 = ", pf3);
writeln("uf3 = ", uf3);