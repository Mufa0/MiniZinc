% Beauty Trap
% Create the most magnificient feast 
enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};
%int: ndish;
%set of int: DISH = 1..ndish;
%set of int: TASTE = 1..6;
%int: spicy = 1; int: sour = 2; int: salty = 3; int: sweet = 4; int: umame = 5; int: bland = 6;
%set of int: TEMP = 1..3;
%int: hot = 1; int: cold = 2; int: warm = 3;


array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;

array[COURSE] of var DISH: dish;

%Each meal can be served only once
include "alldifferent.mzn";
constraint alldifferent(dish);

%No two dishes of same taste in a row
array[1..len] of var bool: taste_diff;
constraint  forall(i in 1..len-1)(taste[dish[i]] != taste[dish[i+1]]);

%First should be salty and last should be sweet
constraint taste[dish[1]] == salty /\ taste[dish[len]] == sweet;

%After spicy comes bland or sweet
constraint forall(i in 1..len-1)(taste[dish[i]] = spicy -> taste[dish[i+1]] in {bland, sweet});

%After sour comes bland or umami
constraint forall(i in 1..len-1)(taste[dish[i]] = sour -> taste[dish[i+1]] in {bland, umame});

%No spicy or umame after sweet
constraint forall(i in 1..len-1)(taste[dish[i]] = sweet -> taste[dish[i+1]] in {salty, sour, bland});

%Between hot and cold must be warm dish
constraint forall(i in 1..len-1)( temp[dish[i]] = hot -> forall(j in i+1..len)(temp[dish[j]] = cold
                                    -> exists(k in i+1..j-1)(temp[dish[k]] = warm) ) );
%No tow heavy dishes in a row
constraint forall(i in 1..len-2)(heavy[dish[i]] /\ heavy[dish[i+1]] -> not heavy[dish[i+2]]);

%Calculation of changes in dish

%Objective function (sum of value of dishes + number of changes in taste, temperature and weight between each pair of consecutive dishes )
%Needs to be maximized
var int: obj;
obj = sum(i in dish)(value[i]) + sum(i in 1..len-1)(taste[dish[i]] != taste[dish[i+1]]) + sum(i in 1..len-1)(temp[dish[i]] != temp[dish[i+1]]) + sum(i in 1..len-1)(heavy[dish[i]] != heavy[dish[i+1]]);

solve maximize(obj);

output["dish = \(dish);\nobj = \(obj);"]