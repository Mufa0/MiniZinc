% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

array[1..u] of var NEGOTIATOR: party;

%Each negotiator can be selected only once
constraint ( forall( [party[i] >= party[i+1] + ( party[i] != dummy ) | i in 1..u-1 ]) );

%Constraint for minimum size of party
constraint forall([party[i] != dummy | i in 1..l]);

%All pairs of negotiators has to be greater than m
constraint sum( [ joint[party[i], party[j]] | i,j in 1..u where i < j]) >= m;

var int: obj;
constraint obj = min( [ honor[ party[i] ] | i in 1..u ]);
%Maxminize minimum honor of party
solve maximize(obj);

output(["party = \(party);\nobj = \(obj);"]);