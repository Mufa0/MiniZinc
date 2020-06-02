int: n;
set of int: LENGTH = 1..n;
set of int: BOUNDS = 1..9;
array[LENGTH] of var BOUNDS: tmp;

var int: c1 = sum(tmp);
var int: c2 = product(tmp);

constraint c1 = c2;
%constraint forall([tmp[i] != tmp[i+1] | i in 1..n-1 ]);
constraint forall([tmp[i] <= tmp[i+1] | i in 1..n-1 ]);
solve satisfy;
output ["\(tmp)"]
 
