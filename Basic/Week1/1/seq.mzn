int: n;

set of int: BOUNDS = 0..3;
set of int: LENGTH = 1..n;
array[LENGTH] of var BOUNDS: tmp;

constraint tmp[1] = 0;
constraint tmp[n] = 3;

constraint forall([tmp[i] + tmp[i+1] <= 3 | i in 1..n-1]);
constraint forall([tmp[i] >= 2 | i in 1..n-1 where i mod 3 = 0]);


solve maximize(sum(tmp));
output["\(sum(tmp)) = \(tmp)"]

