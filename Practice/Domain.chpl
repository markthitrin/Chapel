config var n = 10;

var RD: domain(3) = {1..n, 1..n, 1..n};
writeln(RD); // {1..10, 1..10, 1..10}



var RDexp = RD.expand((1,2,-2));
writeln(RDexp); // {0..11, -1..12, 3..8}


var RDext1 = RD.exterior((1,4,-4));
writeln(RDext1); // {11..11, 11..14, -3..0}
var RDext2 = RD.exterior((0,4,0));
writeln(RDext2); // {1..10, 11..14, 1..10}


var RDint = RD.interior((2,-5,1));
writeln(RDint); // {9..10, 1..5, 10..10}


var RDtrans1 = RD.translate((0,4,-4));
writeln(RDtrans1); // {1..10, 5..14, -3..6}


var RDtrans2 = RD.translate(4);                             // single argument, work with all four function(apply to all dimension)
writeln(RDtrans2); // {5..14, 5..14, 5..14}






var RSD1, RSD2 : subdomain(RD);

writeln("RSD1:", RSD1); // RSD1:{1..0, 1..0, 1..0}
writeln("RSD2:", RSD2); // RSD2:{1..0, 1..0, 1..0}


RSD1 = RD[..n/2, .., ..];   // This gives half of the domain,
RSD2 = RD[n/2+1.., .., ..]; // and this gives the other half.

writeln("RSD1:", RSD1); // RSD1:{1..5, 1..10, 1..10}
writeln("RSD2:", RSD2); // RSD2:{6..10, 1..10, 1..10}

// NOTE: checking if subdomain in the parent domain is not implemented




var SSD: sparse subdomain(RD);

writeln("SSD:", SSD); // Initially empty.


SSD += (1,2,3);
SSD += (4,5,6);
SSD += (7,8,9);
SSD += (9,10,1);

writeln("SSD:", SSD); // Now contains an unordered set of indices


