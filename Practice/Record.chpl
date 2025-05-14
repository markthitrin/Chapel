// not like class as
// NO inheritance
// NO refer to same instance
// copy-init and  assignement can be implemented
// Stack allocation


record Color {
    var red: uint(8);
    var green: uint(8);
    var blue: uint(8);
}

var t = new Color(3,4,5);
writeln(t);

var t2 : Color;                                                     // empty init is allow
writeln(t2);

proc Color.luminance() {
  return 0.2126*red + 0.7152*green + 0.0722*blue;
}
writeln(t.luminance());



record Point {
    var x : real;
    var y : real;
    var z : real;


    proc init() {
        writeln("Empty init");
        x = 0.0;
        y = 0.0;
        z = 0.0;
    }

    proc init(x : real, y:real, z:real) {
        writeln("normal init");
        this.x = x;
        this.y = y;
        this.z = z;
    }

    proc init=(from: Point) {
        writeln("copy init");
        this.x = from.x;
        this.y = from.y;
        this.z = from.z;
    }

    proc mag() {
        return sqrt(x*x + y*y + z*z);
    }
}



var a0 : Point;                                                     // empty init
var a1 = new Point(3,4,5);                                          // normal init
var a2 : Point = new Point(3,4,5);                                  // normal init
var a3 = a0;                                                        // copy init
writeln(a0.mag());

a3.x = 10;
writeln(a0);                                                        // remain the same as a3 is other storage



operator Point.= (ref lhs: Point, rhs: Point) {                     // operator whhen assigning value to a Pointvariable
    writeln("assigment");
    lhs.x = rhs.x;
    lhs.y = rhs.y;
    lhs.z = rhs.z;
}

a2 = a3;                                                            // Point assigment
writeln(a2);




proc Point.deinit() {                                               // when the object is out of scope or deleted
    writeln("out");
}

{   
    var ll : Point;
}                                                                   // When the ll get out of scope "out" was printed
                                                                    // Note that at this point, if the program ends, "out" of every point is printed.



proc Point.this(i : int): real {                                    // Point.this make the record behave like a process
    if i == 1 then
        return x;
    if i == 2 then
        return y;
    if i == 3 then
        return z;

    return 0.0;
}

writeln(a3(1));
writeln(a3[1]);                                                     // The this method enable both () and []






iter Point.these() {                                                // Thet these method allow to loop in the record
    yield x;
    yield y;
    yield z;
}

for i in a2 {
    writeln("HI ",i);
}
