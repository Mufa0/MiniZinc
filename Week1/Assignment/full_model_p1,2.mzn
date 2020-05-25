enum LETTER;
array[int] of LETTER: problem;
int: n_rows;
array[int] of int: n_columns;
array[int] of int: first_indices;
array[LETTER] of var int: values;


%All first numbers must be in [1,9]
constraint forall([values[problem[i]] >= 1 /\ values[problem[i]] <= 9 | i in first_indices]);
constraint forall([values[problem[i]] >= 0 /\ values[problem[i]] <= 9 | i in 1..length(problem)]);

include "alldifferent.mzn";
constraint alldifferent(values);

%Sum of all rows except last one has to be equal to last
array[1..n_rows] of var int: rows_values = [sum([values[problem[first_indices[i]+j]]*10^(n_columns[i]-1-j) | j in 0..n_columns[i]-1]) | i in 1..n_rows ];

constraint (sum([rows_values[i] | i in 1..n_rows-1]) = rows_values[n_rows]);
output["\(rows_values);\n\(values)"];





