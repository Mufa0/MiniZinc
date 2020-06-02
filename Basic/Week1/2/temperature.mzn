int: start;
array[int] of int: readings;

int: SIZE = length(readings);

set of int: HOURS = 1..SIZE;
set of int: HOURS0 = 0..SIZE;

array[HOURS0] of var int: temp;

constraint temp[0] = start;

array[HOURS] of var CHOICE: action;
array[HOURS] of var int: action_costs;

array[CHOICE] of int: CHOICE_COST = [1, 5, 3, 9, 0];
array[CHOICE] of int: CHOICE_VALUE = [+1, +4, -2, -5, 0];

constraint forall([temp[h] = (readings[h]+ temp[h-1]) div 2 + CHOICE_VALUE[action[h]] | h in HOURS]);

%Temp on each our is inside given range
constraint forall([temp[h] <= 30 | h in HOURS0]);
constraint forall([temp[h] >= 25 | h in HOURS0]);

var int: cost = sum([CHOICE_COST[action[h]]| h in HOURS]);

solve minimize(cost);

output ["temp = \(temp);\nchoice = \(action);\nsum = \(cost)"];
enum CHOICE = {heat, strongly_heat, cool, strongly_cool, do_nothing};