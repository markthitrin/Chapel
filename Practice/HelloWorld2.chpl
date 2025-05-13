module Hello {
    // Init
    config const message = "Hello World!";

    proc main () {
        writeln(message);
    }
}