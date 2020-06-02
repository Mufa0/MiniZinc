%Number of notes in sequence - each note is expresed as 1..n
int: n;

%Order that represents each note
array[1..n] of var 1..n: order;

%Position of note i
array[1..n] of var 1..n: posn;

%Difference between each adjacent note
array[1..n-1] of var 1..n-1: diffs;

%Posidion of difference i
array[1..n-1] of var 1..n-1: dposn; 
%Difference between each adjacent note has to be different
constraint forall(i in 1..n-1)(diffs[i] = abs(order[i] - order[i+1]));

include "alldifferent.mzn";
constraint alldifferent(order);
constraint alldifferent(diffs);

include "inverse.mzn";
constraint inverse(posn, order);

constraint abs(posn[1] - posn[n]) = 1;


constraint inverse(dposn, diffs);
constraint dposn[n-1] = min(posn[1], posn[n]);

solve satisfy;

output["order = \(order);\ndiffs = \(diffs);\nposn = \(posn);\ndposn = \(dposn);"]
