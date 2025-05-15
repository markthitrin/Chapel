module ModToUse {
    var foo = 12;
    var bar: int = 2;

    module inside {
        // allow
    }

    private var hiddenFoo = false;                                      // private variable, belong to this module only
    

    proc baz (x, y) {
        return x * (x + y);
    }
    private proc hiddenBaz(a) {                                         // private function, belong to this module only
        writeln(a);
        return a + 3;
    }
    // Note that private type/class/enums/records is not allowed.


    record Rec {
        var field: int;

        proc method1 () {
           writeln("In Rec.method1()");
        }

        // private proc func1() {                                       // private method not allowed
        //     ;
        // }   
    }
    proc Rec.method2() {
        writeln("In Rec.method2()");
    }

}







module AnotherModule {
    var a = false;
}

module ThirdModule {
    var b = -13.0;
}


module Conflict {                                                                                       // same variable name to ModToUse
    var bar = 5;

    var other = 5.0 + 3i;

    var another = false;
}


module DifferentArguments {                                                                             // same function anem but different arguments to ModtoUse 
    proc baz(x) {
        return x - 2;
    }
} 

module RecMoreMethods { 
    private use ModToUse;
    proc Rec.method3() {
        writeln("In Rec.method3()");                                                                    // tertiary method
    }
}


module MainModule {
  proc main() {
    writeln("Access from outside a module");
    {
        use ModToUse;                                                                                   // The use is only works in the scope

        var bazBarFoo = baz(bar, foo);
        writeln(bazBarFoo);
    }
    {
        import ModToUse;                                                                                // The import enable access through module prerfix
                                                                                                        // Note that this is only work in the scope
        var bazBarFoo = ModToUse.baz(ModToUse.bar, ModToUse.foo);
        writeln(bazBarFoo);
        // writeln(foo);                                                                                // not visible
    }
    {
        import ModToUse.bar;

        writeln(bar);                                                           
    }
    {
        var bazBarFoo = baz(bar, foo);

        use ModToUse;                                                                                   // "use" apply to all scope, no need order

        writeln(bazBarFoo);
    }
    {
        var bazBarFoo = ModToUse.baz(ModToUse.bar, ModToUse.foo);

        import ModToUse;                                                                                // so as impoort

        writeln(bazBarFoo);
    }
    {
        use ModToUse as other;                                                                          // Given can be assigned, but not it need prefix

        writeln(other.bar);
        // writeln(ModToUse.bar);                                                                       // error, ModToUse not visible                
        writeln(bar);
    }
    {
        import ModToUse as other;                                                                       // so as the import

        writeln(other.bar);
        // writeln(ModToUse.bar);                                                                       // error, ModToUse not visible
    }
    {
        var bar = 4.0;                                                                                  // This bar is used

        use ModToUse;

        writeln(bar);
    }
    {
        import ModToUse.bar;                                                                            // import bought the same way as definition does
        // var bar = 4.0;                                                                               // multiple definition error
    }
    {
        var bar = false;
        {

            use ModToUse;
            writeln(bar);
            // Will output the value of ModToUse.bar (which is '2'), rather
            // than the value of the bar defined outside of this scope (which
            // is 'false')
        }
    }
    {
        var bar = false;
        {

            import ModToUse.bar;                                                                        // same
            writeln(bar);
            // Will output the value of ModToUse.bar (which is '2'), rather
            // than the value of the bar defined outside of this scope (which
            // is 'false')
        }
    }
    {
        use ModToUse, AnotherModule, ThirdModule;                                                       // use multiple module at the same time

        if (a || b < 0) {
            // Refers to AnotherModule.a (which is 'false') and ThirdModule.b (which
            // is '-13.0')
            writeln(foo); // Refers to ModToUse.foo
        } else {
            writeln(bar); // Refers to ModToUse.bar
        } // Will output ModToUse.foo (which is '12')
    }
    {
        import ModToUse, AnotherModule, ThirdModule;                                                    // import multiple module at the same time

        if (AnotherModule.a || ThirdModule.b < 0) {
            writeln(ModToUse.foo);
        } else {
            writeln(ModToUse.bar);
        } // Will output ModToUse.foo (which is '12')
    }
    {
        import ModToUse.{foo, bar}, AnotherModule, ThirdModule.b;                                       // import multiple thing at the same time

        if (AnotherModule.a || b < 0) {
            // Refers to ThirdModule.b (which is '-13.0')
            writeln(foo); // Refers to ModToUse.foo
        } else {
            writeln(bar); // Refers to ModToUse.bar
        } // Will output ModToUse.foo (which is '12')
    }
    {
        use ModToUse;                                                                                   // multiple use
        use AnotherModule, ThirdModule;

        writeln(a && foo > 15);
        // outputs false (because AnotherModule.a is 'false' and ModToUse.foo is
        // '12')
    }
    {
        import ModToUse.foo;                                                                            // multiple module
        import AnotherModule.a;

        writeln(a && foo > 15);
        // outputs false (because AnotherModule.a is 'false' and ModToUse.foo is
        // '12')
    }
    {
        use ModToUse;                                                                                   // mixed
        import AnotherModule.a;

        writeln(a && foo > 15);
        // outputs false (because AnotherModule.a is 'false' and ModToUse.foo is
        // '12')
    }
    {
        use ModToUse, Conflict;

        writeln(foo); // Outputs ModToUse.foo ('12')
        // writeln(bar);                                                                                // error : the name refer to two thing from different module
        writeln(other); // Outputs Conflict.other ('5.0 + 3.0i')
    }
    {

        use ModToUse, DifferentArguments;

        writeln(baz(2, 3));                                                                             // function ok
        // Accesses the function ModToUse.baz using the two arguments.  Should
        // output 2 * (2 + 3) or '10'
        writeln(baz(3));
        // Access the function DifferentArguments.baz using the single argument.
        // Should output 3 - 2, or '1'
    }
    {
        use ModToUse;
        use Conflict only other, another;                                                               // use only to limit what "use" import 

        writeln(foo); // Outputs ModToUse.foo ('12')
        writeln(bar); // Outputs ModToUse.bar ('2')
        writeln(other); // Outputs Conflict.other ('5.0 + 3.0i')
    }

    {
        use Conflict;
        use ModToUse except bar;                                                                        // use except to exclude what "use" imports

        writeln(foo); // Outputs ModToUse.foo ('12')
        writeln(bar); // Outputs Conflict.bar ('5')
        writeln(other); // Outputs Conflict.other ('5.0 + 3.0i')
    }
    {
        use ModToUse;
        use Conflict only bar as boop;                                                                  // rename
        writeln(bar); // Outputs ModToUse.bar ('2')
        writeln(boop); // Outputs Conflict.bar ('5')
    }
    {
        use ModToUse;
        import Conflict.{bar as boop};                                                                  // rename of imports
        writeln(bar); // Outputs ModToUse.bar ('2')
        writeln(boop); // Outputs Conflict.bar ('5')
    }
    {
        use ModToUse only;
        var rec = new ModToUse.Rec(4); // Only accessible via the module prefix
        writeln(rec.field);            // Accessible because we have an instance
        rec.method1();                 // Ditto to the field case
        rec.method2();

        use RecMoreMethods only Rec;                                                                    // import only the tertiary method
        rec.method3();                 // Enabled by previous use statement
    }
    {

        enum color {red, blue, yellow};

        {
            // Normally you must prefix the constant with the name of the enum
            var aColor = color.blue;
            writeln(aColor);
        }

        {
            use color;

            // The 'use' statement allows you to access an enum's symbols without
            // the prefix
            var anotherColor = yellow; // color.yellow                                                  // Access enum directly
            writeln(anotherColor);
        }
    }
  }
}

module OuterNested {
    var foo = 12;
    var bar: int = 2;
    private var hiddenFoo = false;

    proc baz (x, y) {
        return x * (x + y);
    }

    private proc hiddenBaz(a) {
        writeln(a);
        return a + 3;
    }

    module Inner1 {
        use OuterNested;

        var foobar = foo + bar;
    }

    module Inner2 {
        use OuterNested;

    private var innerOnly = -17;
        var canSeeHidden = !hiddenFoo;
    }

    module Inner3 {
        var x: int = 11;
    }

    {
        writeln("Executing OuterNested's module-level code");
        use OuterNested.Inner3;                                                                             // import inner module

        writeln(x);
    }
    {
        use Inner3;                                                                                         // inner3 is in this scope

        writeln(x);
    }

    module Inner4 {
        import super.Inner3;                                                                                // super for outer module

        writeln(Inner3.x);
    }
}


module ModuleThatIsUsed {
  proc publiclyAvailableProc() {
    writeln("This function is accessible!");
  }
}

module UserModule {
  use ModuleThatIsUsed;                                                                                     // or `private use ModuleThatIsUsed`
                                                                                                            // if you want the function below to work, type
                                                                                                            // public use ModuleThatIsUsed
}

module UsesTheUser {
  proc func1() {
    use UserModule;
    // publiclyAvailableProc();                                                                             // error : use in the useModule is private         
  }

  // These lines are to ensure everything gets tested regularly
  writeln("Start of UsesTheUser's module-level code");
  func1();
  {
    use UsesTheUser2;
  }
  writeln("End of UsesTheUser's module-level code");
}

module UserModule2 {
  public use ModuleThatIsUsed;
}

module UsesTheUser2 {
  proc func2() {
    use UserModule2;
    publiclyAvailableProc(); // available due to ``use`` of ``ModuleThatIsUsed``
  }

  // These lines are to ensure everything gets tested regularly
  writeln("Start of UsesTheUser2's module-level code");
  func2();
  {
    use UsesTheUser3;
  }
  writeln("End of UsesTheUser2's module-level code");
}

module UsesTheUser3 {
  proc func3() {
    use UserModule2;
    UserModule2.publiclyAvailableProc();
    // The above is available due to the ``public use`` of ``ModuleThatIsUsed``
    // in ``UserModule2``.
  }

  // These lines are to ensure everything gets tested regularly
  writeln("Start of UsesTheUser3's module-level code");
  func3();
  {
    use UsesTheImporter;
  }
  writeln("End of UsesTheUser3's module-level code");

}





module ImporterModule {
  public import ModuleThatIsUsed;                                                                           // public can be used with impot too
}
module UsesTheImporter {
  use ImporterModule;

  // Possible due to re-export of ModuleThatIsUsed
  ModuleThatIsUsed.publiclyAvailableProc();

  // These lines are to ensure everything gets tested regularly
  {
    use NoMiddleMan;
  }
}
module NoMiddleMan {
  use ModuleThatIsUsed;

  publiclyAvailableProc();

  // These lines are to ensure everything gets tested regularly
  {
    use UsesTheImporter2;
  }
}

module ImporterModule2 {
  public import ModuleThatIsUsed.publiclyAvailableProc;
}

module UsesTheImporter2 {
  use ImporterModule2;

  writeln("Start of reverse file-order output");
  // Possible due to re-export of ModuleThatIsUsed.publiclyAvailableProc
  ImporterModule2.publiclyAvailableProc();
}
