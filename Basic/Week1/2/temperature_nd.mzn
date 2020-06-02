array[int] of int: readings;

int: start;
int: n = length(readings);
set of int: HOUR = 1..n;
set of int: HOUR0 = 0..n;

array[HOUR0] of var int: temp;

constraint temp[0] = start;

constraint forall([ temp[h] = (readings[h]+ temp[h-1]) div 2 | h in HOUR ]);



enum CHOICE = {heat, strongly_heat, cool, strongly_cool, do_nothing};
solve satisfy;

output ["temp = \(temp);\n"];
