%Number of notes in sequence - each note is expresed as 1..n
int: n;

%Order that represents each note
array[1..n] of var 1..n: order;

%Difference between each adjacent note
array[1..n-1] of var 1..n-1: diffs;

%Difference between each adjacent note has to be different
constraint forall(i in 1..n-1)(diffs[i] = abs(order[i] - order[i+1]));

include "alldifferent.mzn";
constraint alldifferent(order);
constraint alldifferent(diffs);



solve satisfy;
int:d =  ceil(ln(n+1) / ln(10.0));
output [show_int(d,i)++" " | i in order] ++["\n"]++ [" "++show_int(d,i) | i in diffs];
