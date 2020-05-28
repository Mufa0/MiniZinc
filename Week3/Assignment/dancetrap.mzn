% Beauty Trap
% Perform the most seductive dance

enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
set of int: STEP = 1..maxlen;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;

constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");

array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;

constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");

int: boredom; % how bored each step make the viewer

var STEP: len;
array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;


%Each action can not go more then n number of times
include "global_cardinality_low_up_closed.mzn";
constraint global_cardinality_low_up_closed(legs, [i | i in LEGS], [0 | i in LEGS], maxlegs);
constraint global_cardinality_low_up_closed(arms, [i | i in ARMS], [0 | i in ARMS], maxarms);
constraint global_cardinality_low_up_closed(face, [i | i in FACE], [0 | i in FACE], maxface);

constraint forall(i in len+1..maxlen)(legs[STEP[i]]=stand);
constraint forall(i in len+1..maxlen)(arms[STEP[i]]=neutral);
constraint forall(i in len+1..maxlen)(face[STEP[i]]=blank);

include "regular.mzn";
constraint regular(legs, 6, 6, ld, 6, {6});
constraint regular(arms, 5, 5, ad, 5, {5});
%constraint regular(face, 6, 6, fd, 6, {6});
constraint regular(face, 11, 6, fd, 6, {6});
array[1..6, LEGS] of 0..6: ld =
[| 0,0,0,4,5,6
 | 1,0,3,0,0,6
 | 1,0,3,4,5,6
 | 1,0,3,4,0,6
 | 1,2,3,4,5,6
 | 1,0,2,4,5,6
|];


array[1..5, ARMS] of 0..5: ad =
[| 0,2,3,4,5
 | 1,0,3,0,5
 | 1,2,0,0,5
 | 0,2,3,0,5
 | 0,2,3,4,5
|];

array[1..11, FACE] of 0..11: fd =
[| 7,2,3,0,5,6
 | 1,8,3,4,5,6
 | 1,2,9,0,5,6
 | 1,2,3,10,5,6
 | 1,2,3,4,11,6
 | 1,2,3,4,5,6
 | 0,2,3,0,5,6
 | 1,0,3,4,5,6
 | 1,2,0,0,5,6
 | 1,2,3,0,5,6
 | 1,2,3,4,0,6
|];

%Between waltz and curtsey there must be a stand
constraint forall(i in 1..len-1)(legs[i] = waltz -> forall(j in i+1..len)(legs[j] = curtsey -> exists(k in i+1..j-1)(legs[k] = stand)));

/*------------------------------------------------------------------------------*/
%Waltz can go only three times in a row
constraint forall(i in 1..len-3)(legs[i] = waltz /\ legs[i+1] = waltz /\ legs[i+2] = waltz -> legs[i+3] != waltz);

%Only neutral can go two times in row
constraint forall(i in 1..len-2)(arms[i] = neutral /\ arms[i+1] = neutral -> arms[i+2] != neutral);

/*------------------------------------------------------------------------------*/
%Kick out all -1 pairs for them not to lower objective function
constraint forall(i in 1..len)(dance_value[legs[i], arms[i]] >= 0);
constraint forall(i in 1..len)(entice_value[arms[i], face[i]] >= 0);




var int: value;
value = sum(i in 1..len)(dance_value[legs[i],arms[i]]);
var int: enticement;
enticement = sum(i in 1..len)(entice_value[arms[i],face[i]]);
var int: boredom_value = boredom*(len);
var int: obj = value + enticement - boredom_value;

solve maximize(obj);
output["len = \(len);\nlegs = \(legs);\narms = \(arms);\nface = \(face);\nobj = \(obj);"]
%\nentice_table = \([entice_value[arms[i],face[i]] | i in STEP]);\ndance_value = \([dance_value[legs[i],arms[i]] | i in STEP])"]
%\nvalue = \(value);\nenticement = \(enticement);\nboredom = \(boredom_value);"];