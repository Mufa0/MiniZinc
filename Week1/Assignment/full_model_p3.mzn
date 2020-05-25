%Enumeration of letters used in problem, given by .dzn
enum LETTER;
/*
* Problem represented by array of LETTER that are written sequentially
* e.g.  ABC
      + CBD
       -----
      = EFG
  This is written as [A,B,C,C,B,D,E,F,G] inside .dzn
*/
array[int] of LETTER: problem;

%Number of rows inside problem, in example abowe we have 3 rows
int: n_rows;

%This specific case has constraint regarding some letters, indices of these letters are given .dzn
int: z;
int: p;
int: o;

/*
* Since each row can have different number of letters we need 
* to provide information about number of letters inside each row
* example above has [ 3, 3, 3 ] since it has 3 letters in each row
*/
array[int] of int: n_columns;

/*
* Since we wrote problem as 1d array, we need to know information where each row starts
* Given that each row can have different number of columns we will provide this information inside .dzn
*/
array[int] of int: first_indices;

% End solution that will be represented
array[LETTER] of var int: values;


%All first numbers must be in [1,9]
constraint forall([values[problem[i]] >= 1 /\ values[problem[i]] <= 9 | i in first_indices]);
%Every other values can be between 0 and 9
constraint forall([values[problem[i]] >= 0 /\ values[problem[i]] <= 9 | i in 1..length(problem)]);

%All values needs to be different values
include "alldifferent.mzn";
constraint alldifferent(values);

/*
* Value of letter Z is 3*value of letter P
* Value of letter O is 0
*/
constraint values[to_enum(LETTER,z)] = 3*values[to_enum(LETTER,p)];
constraint values[to_enum(LETTER,o)] = 0;

%Sum of all rows except last one has to be equal to last
array[1..n_rows] of var int: rows_values = [sum([values[problem[first_indices[i]+j]]*10^(n_columns[i]-1-j) | j in 0..n_columns[i]-1]) | i in 1..n_rows ];
constraint (sum([rows_values[i] | i in 1..n_rows-1]) = rows_values[n_rows]);

output [
   show(to_enum(LETTER, i))++" = "++show(values[i])++";\n"
   | i in LETTER
];



