// Error handling mostly for IO error handle


use IO;

const f1 = "input.txt";
const f2 = "backup_input.txt";

var f: file;
    // f = try! open(f1, ioMode.r);                                                         // halt the error and not handle with "try!"

try {
    f = open(f1, ioMode.r);
    writeln("everything is fine");
} catch {
    writeln("an error occurred");
}

try {
    f = open(f1, ioMode.r);
} catch e: FileNotFoundError {
                                                                                            // catch block can be directed to only handle certain errors
                                                                                            // the error caught will be `owned FileNotFoundError` in this case
    writeln("Warning: ", f1, " does not exist");
    try! {
        f = open(f2, ioMode.r);
    } catch e: FileNotFoundError {
        writeln("Warning: ", f2, " does not exist");
    }
                                                                                            // halts if a different error is returned
} catch {
    // catchall is needed because main() does not throw
    writeln("unknown error");
}






class EmptyFilenameError : Error {
    proc init() {

    }
}

proc checkFilename(f_name: string) throws {                                                 // Need the keyword throw
    if f_name.isEmpty() then
        throw new EmptyFilenameError();
}

proc openFilename(f_name: string) throws {
    var f: file;

    try {
        f = open(f, ioMode.r);
    } catch e: FileNotFoundError {
        writeln("Warning: ", f, " does not exist");
    }   // throws all other errors

  return f;
}




                                                                                            // implicit module i.e. no module scope, will halt the error
checkFilename(f1); // halts on error

proc doesNotThrow() {
  checkFilename(f2); // halts on error
}

proc throwOn() throws {
  checkFilename(f2); // throws on error
}





prototype module P {                                                                         // prototype module, will halt the error
  checkFilename(f1); // halts on error

  proc doesNotThrow() {
    checkFilename(f2); // halts on error
  }

  proc throwOn() throws {
    checkFilename(f2); // throws on error
  }
}




module R {                                                                                  // normal module, error should be handled
  // not permitted, error must be handled completely
  // checkFilename(f1);
  try! checkFilename(f1);

  proc doesNotThrow() {
    // not permitted, error must be handled completely
    try {
      checkFilename(f2);
    } catch {
      writeln("handled completely");
    }
  }

  proc throwOnExplicit() throws {                                                           // except the function that has throws keywords
    checkFilename(f2); // still works, throws on error
  }
}