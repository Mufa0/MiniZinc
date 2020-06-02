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

%SET of warrirs choosen

var set of WARRIOR: raid;
constraint (card(raid) >= l /\ card(raid) <= u );

constraint not(dummy in raid);
%Sum of hatered must be below or equal to m

constraint sum( [hates[clan[i], clan[j]] | i,j in raid where i < j ]) <= m;

var int: obj;

constraint obj = sum([ strength[i] | i in raid ]);

solve maximize(obj);

output["raid = \(raid);\nobj = \(obj);"]


