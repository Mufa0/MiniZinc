int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
array[HORSE] of int: beauty;
array[HORSE] of int: speed;

set of int: mHORSE = 0..m;
set of int: mCOURT = 0..n;

array[COURT,HORSE] of int: enjoy;

array[COURT] of var mHORSE: horse;
array[HORSE] of var mCOURT: court;

%INVERSE FUNCTION
constraint forall(i in COURT where horse[i] != 0)(court[horse[i]] = i);
constraint forall(i in HORSE where court[i] != 0)(horse[court[i]] = i);
%Emperor has to have biggest enjoy value
constraint forall(i in 2..n where horse[i] > 0)(enjoy[emperor, horse[emperor]] > enjoy[i, horse[i]]);

%Some horses cannot be assigned to some court members
constraint forall(i in COURT where horse[i] > 0)(enjoy[i, horse[i]] > -1);

%One horse can be assigned only to one court member and All court members must ride unless there is no horse left available
include "global_cardinality_low_up.mzn";
include "global_cardinality.mzn";
constraint if n >= m then global_cardinality(horse, HORSE, [1 | i in HORSE]) else global_cardinality_low_up(horse, HORSE, [0 | i in HORSE], [1 | i in HORSE]) endif;
constraint if m > n then global_cardinality(court, COURT, [1 | i in COURT]) else global_cardinality_low_up(court, COURT, [0 | i in COURT], [1 | i in COURT]) endif;
%If court member holds higher rank then either  beauty of  their horse can be no less then one of lower rank,
%lower rank must not ride  or both don't ride
constraint forall(i in 1..n, j in 1..n where i != j)(rank[i] > rank[j] -> (horse[j] = 0 \/ (horse[i] = 0 /\ horse[j] = 0) \/ beauty[horse[i]] >= beauty[horse[j]]));

%If horse is faster then another than member has no less riding expirience or faster horse has no rider, or both horses has no rider
var int: violations = sum(i in 1..m , j in 1..m where i != j)((speed[i] > speed[j] -> (court[i]=0 \/ (court[i]=0 /\ court[j] = 0) \/ ability[court[i]] >= ability[court[j]])) = false);
array[int] of var bool: tmp = [(speed[i] > speed[j] -> court[i]=0 \/ (court[i]=0 /\ court[j] = 0) \/ ability[court[i]] >= ability[court[j]]) = false | i in 1..m , j in 1..m where i != j];

var int: obj;
obj = sum(i in COURT where horse[i] != 0)(enjoy[i, horse[i]]) + -100*violations;

solve maximize(obj);
output["horse = \(horse);\nobj = \(obj);"];