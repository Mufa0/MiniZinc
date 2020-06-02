% assignment 2
% select a set of raiding warrior
enum WARRIOR;
WARRIOR: dummy; 
enum CLAN; % the clan they belong too

int: l; % minimum raid party size
int: u; % maximum raid party size
int: m; % limit of hatreds

array[WARRIOR] of int: strength;
array[WARRIOR] of CLAN: clan;

array[CLAN,CLAN] of 0..1: hates;

array[1..u] of var WARRIOR: raid;

%Constraint: each warrior can occur only once
constraint forall([ raid[i] >= raid[i+1] + (raid[i] != dummy)| i in 1..u-1 ]);

%Constraint: minimum number of warriors is l
constraint forall([ raid[i] != dummy | i in 1..l ]);

%Constraint: maximum m pairs of warriors can be inside raid whose clans hate each other
constraint sum([ hates[clan[raid[i]], clan[raid[j]]] | i,j in 1..u where i<j]) <= m;

var int: obj;
constraint obj = sum([strength[raid[i]] | i in 1..u]);

solve maximize(obj);

output ["raid = {"] ++ [if fix(raid[u-i]) != dummy then show(raid[u-i])
++ if i < u /\ fix(raid[u-(i+1)]) != dummy then ", " else "" endif else "" endif | i in 0..u ] ++ ["};\nobj = \(obj)"]

