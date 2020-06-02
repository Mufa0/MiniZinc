% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

var set of NEGOTIATOR: party;

%Constrinted side of selected party
constraint card(party) >= l /\ card(party) <= u;
constraint  not(dummy in party);

%All pairs of negotiators has to be greater than m
constraint sum( [ joint[i, j] | i,j in party where i < j]) >= m;

var int: obj;
constraint obj = min( [ honor[ i ] | i in party ]);
%Maxminize minimum honor of party
solve maximize(obj);

output(["party = \(party);\nobj = \(obj);"]);