proc fac(x: int) : int {
    if x < 0 {                                      // if statement is exactly like c/cpp/python, it need {} or "then"
        halt("Error x < 0");                        // bool expression is the same with &&,||,!
    }

    return if x == 0 then 1 else x * fac(x - 1);
}


proc fac(x : int(32)) : int(32) {                   // overloading proceudre of the factorial
    if x < 1 then
    halt("factorial -- Invalid operand.");

    if x < 3 then return x;

    return x * (x-1) * fac(x-2);
}


writeln(fac(6));
writeln(fac(33));
writeln(fac(33:int(32)));                           // call the int(32) version

record Point : writeSerializable {var x, y: real;}

operator Point.+(p1:Point,p2:Point) {
    return new Point(p1.x + p2.x,p1.y + p2.y);
}


proc Point.serialize(writer, ref serializer) throws // overload the write function called by the writeln
{
    writer.write("(");
    writer.write(this.x);
    writer.write(", ");
    writer.write(this.y);
    writer.write(")");
}

writeln("Using operator overloading");
var down = new Point(10.0, 0.0);
var over = new Point(0.0, -5.0);
writeln("down + over = ", down + over);
writeln();



class Circle {
    var center : Point;
    var radius : real;
}


proc create_circle(x = 0.0, y = 0.0, diameter = 0.0) { // It provide the default argument which aso specify that type(reak(64))
    var result = new Circle();

    result.radius = diameter / 2;
    result.center.x = x;
    result.center.y = y;

    return result;
}

proc func1(b= 0.0, g = 9.0, a = 8.0) {
    writeln("b : ",b);
    writeln("g : ",g);
    writeln("a : ",a);
}

func1(g = -1,-2,-3);                                    // The unknown  variable are assigned according to the order in the function

var c = create_circle(diameter=3.0,2.0);                // x=2.0, y=0.0, diameter=3.0 The remaning unnamed variable are assigned




proc unknownArg(x) {                                    // argument with unknown type, generic procedures.
    writeln(x);
  if x.type == int then
    writeln("I see you've passed me an integer!");
  else if x.type == string {
    writeln("I liked that last variable so much, I'll write it again!");
    writeln(x);
  }
}

var intArg = 5;
var strArg = "Greetings, procedure unknownArg!";
var boolArg = false;
writeln("Using generic arguments");
unknownArg(intArg);
unknownArg(strArg);
unknownArg(boolArg);
writeln();




proc func2(a :int ) {
    //a = 3;                                             // Error a is const when passing to func2
}

func2(4);
var aa = 90;
func2(aa);

proc func3(in a: int) {                                 // "in" keyword allow the argument to be changed
    a = 1000;
}
func3(23);              
func3(aa);              
writeln("The value of aa is ",aa);                      // aa is still 90 the same


proc func4(inout a:int) {                               // "inout" keyword tell the function to writeback when it finishs.
    a = 1000000;                                        // ** Note that this inout copy the value at the beginning and write it back at the end
}

// func4(78);                                           // error : const actual is passed to 'inout' formal
func4(aa);
writeln("The value of aa is ",aa);                      // The value of the aa changed to 1000000



proc func5(ref a:int) {                                 // like inout but instead of copying, it takes affteced imemdiately
    a = 1000000000;
}

func5(aa);
writeln("The value of aa is ", aa);



proc func6(out a:int) {                                 // "out" keyword tell the function to ignore the passed actual value but write
                                                        // the result back when the function is finish;
    writeln("The value of a inside the function6 is : ",a);// get 0
    a = 89;
}

func6(aa);

writeln("The value of aa is now : ",aa);






proc ffff(a : int) {
    writeln("Hey");
    writeln(gggg(a));                                   // Calling the function that is declared later is allowed. but not for variable
}

ffff(8989);

proc gggg(a : int) {
    return a * 22;
}




proc hh(a : int) {
    writeln("Called from hh(a:int)");
}

proc hh(a) {
    writeln("Called from hh(a)");
}

hh(3);                                                      // hh(a:int)
hh(3.0);                                                    // hh(a)
hh("hi");                                                   // hh(a)
                                                            // resolve like c++