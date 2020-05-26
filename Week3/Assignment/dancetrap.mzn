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

%It must end with stand, neutral and blank
constraint legs[len] = stand /\ arms[len] = neutral /\ face[len] = blank;

%Prep goes before leap
constraint forall(i in 2..len)(legs[i] = leap -> legs[i-1] = prep);
%After spin goes curtsey, prep or stand
constraint forall(i in 1..len-1)(legs[i] = spin -> legs[i+1] in {curtsey, prep, stand});
%After leap goes spin, waltz or stand
constraint forall(i in 1..len-1)(legs[i] = leap -> legs[i+1] in {spin, waltz, stand});
%Waltz can go max three times in row
constraint forall(i in 1..len-3)(legs[i] = waltz /\ legs[i+1] = waltz /\ legs[i+2] = waltz -> legs[i+3] in {spin, leap, curtsey, prep, stand});
%Acter curtsey no prep
constraint forall(i in 1..len-1)(legs[i] = curtsey -> legs[i+1] in {spin, leap, waltz, curtsey, stand}); 

%Between waltz and curtsey there must be a stand
constraint forall(i in 1..len-1)(legs[i] = waltz -> forall(j in i+1..len)(legs[j] = curtsey -> exists(k in i+1..j-1)(legs[k] = stand)));

/*------------------------------------------------------------------------------*/
%Hand becom move only after out or up
constraint forall(i in 2..len)(arms[i] = beckon -> arms[i-1] in {out, up});

%Wrapped can only be after beckon or neutral ( wrapped can be first since before first is neutral )
constraint forall(i in 2..len)(arms[i] = wrapped -> arms[i-1] in {beckon, neutral} \/ i = 2);

%Only neutral can go two times in row
constraint forall(i in 1..len-1)(arms[i] != neutral -> arms[i] != arms[i+1]);
constraint forall(i in 1..len-2)(arms[i] = neutral /\ arms[i+1] = neutral -> arms[i+2] != neutral);

/*------------------------------------------------------------------------------*/
%Only blank can go two time in row
constraint forall(i in 1..len-1)(face[i] != blank -> face[i] != face[i+1]);
constraint forall(i in 1..len-2)(face[i] = blank /\ face[i+1] = blank -> face[i+2] != blank);

%No think after smile or bat
constraint forall(i in 2..len)(face[i] = think -> face[i-1] in {smile, batt});

/*------------------------------------------------------------------------------*/
var int: value;
value = sum(i in 1..len)(dance_value[legs[i],arms[i]]);
var int: enticement;
enticement = sum(i in 1..len)(entice_value[arms[i],face[i]]);
var int: boredom_value = boredom*len;
var int: obj = value + enticement - boredom_value;

solve maximize(obj);
output["len = \(len);\nlegs = \(legs);\narms = \(arms);\nface = \(face);\nobj = \(obj);"];