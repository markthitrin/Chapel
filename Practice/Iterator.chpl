iter fibonacci(n : int) {
    var (current, next) = (0, 1);
    for i in 1..n {
        yield current;
        (current, next) = (next , current + next);
    }
}


for i in fibonacci(10) do
    writeln(i);


for (i,j) in zip(fibonacci(10), 1..) {                                                  // swaping place in zip are fine
    write("The ", j);

    select j { 
        when 1 do write("st");
        when 2 {
            write("en");
        }
        when 3 do write("rd");
        otherwise {
            write("th");
        }
    }

    writeln(" Fibonacci is number : ",i);
}






iter multiloop(n: int) {
    for i in 1..n do
        for j in 1..n do
            yield (i, j);
}
writeln("Multiloop Tuples");
writeln(multiloop(3));
writeln();







class Tree : writeSerializable {                                                    // example of post order iterator
    var data: string;
    var left, right: owned Tree?;
}

iter postorder(tree: borrowed Tree?): borrowed Tree {
    if tree {
        if tree!.left {
        // Call the iterator recursively on the left subtree and expand.
        for child in postorder(tree!.left) do
            yield child;
        }

        if tree!.right {
            // Call the iterator recursively on the right subtree and expand.
            for child in postorder(tree!.right) do
                yield child;
        }

        // Finally, yield the node itself.
        yield tree!;
    }
}

var tree = new Tree( "a",
    new Tree("b"),
    new Tree("c",
        new Tree("d"),
        new Tree("e")));

override proc Tree.serialize(writer, ref serializer)
{
    var first = true;

    for node in postorder(this) {
        if first then
            first = false;
        else
            writer.write(" ");

        writer.write(node.data);
    }
}

writeln("Tree Data");
writeln(tree);
writeln();