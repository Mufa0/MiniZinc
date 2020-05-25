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
/*
var set of WARRIOR: result;
constraint (card(result) >= l /\ card(result) <= u );
*/

%Array of warrors choosen. Size of this array is number of possible warriors and value is 0-1, which represents if warrior on index i is choosen or not

array[WARRIOR] of var 0..1: result;
constraint (sum(result) >= l /\ sum(result) <= u);





%Hatred constraint: no more then m pairs can exists that hates each other
/*TODO: create matrix of connections and multiply with matrix of hates between warriors ( we will be left with only 1 values on choosen wariors that hate each other )
* transfer to 1d array and sum values
*/


