enum Color {red, green, blue}

var c : Color;
writeln(c);                                             // red
var c2 = Color.green;

for c in Color do
    writeln(c);

var g = c2:string;
writeln(g, g.type:string);                              // g is string which is "green"


//writeln(c:int)                                        // error



enum Color2 {black = 0, white};

var c3 = Color2.black;
writeln(c3:int);                                        // ok get 0
writeln(Color2.white:int);                              // ok get 1




enum Color3 {light, dark = 3};

// writeln(Color3.light:int);                           // exception
writeln(Color3.dark:int);



enum Color4 {thank = 9, you = 8, next = 8}
writeln(Color4.thank:int);                              // ok get 9
writeln(Color4.you:int);                                // ok get 8
writeln(Color4.next:int);                               // ok get 8

