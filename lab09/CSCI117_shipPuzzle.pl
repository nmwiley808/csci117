/* 
Part 2 

Ships Logical Puzzle

1) The Greek ship leaves at six and carries coffee.
2) The ship in the middle has a black chimney.
3) The English ship leaves at nine.
4) The French ship with a blue chimney is to the left of a ship that carries coffee.
5) To the right of the ship carrying cocoa is a ship going to Marseille.
6) The Brazilian ship is heading for Manila.
7) Next to the ship carrying rice is a ship with a green chimney.
8) A ship going to Genoa leaves at five.
9) The Spanish ship leaves at seven and is to the right of the ship going to Marseille.
10) The ship with a red chimney goes to Hamburg.
11) Next to the ship leaving at seven is a ship with a white chimney.
12) The ship on the border carries corn.
13) The ship with a black chimney leaves at eight.
14) The ship carrying corn is anchored next to the ship carrying rice.
15) The ship to Hamburg leaves at six.

Which ship goes to Port Said? Which ship carries tea?
*/

:- use_rendering(table, 
                 [header(h('Ship', 'Leaves at', 'Carries', 'Chimney', 'Goes to'))]).

goes_PortSaid(Goes) :-
    ships(S),
    member(s(Goes,_,_,_,portSaid), S).

carries_tea(Carries) :-
    ships(S),
    member(s(Carries,_,tea,_,_), S).

ships(S) :-
    
    length(S,5),
    %Puzzle Rules/Facts
    member(s(greek, 6, coffee, _, _), S),
    S = [_, _, s(_, _, _, black, _), _, _],
    member(s(english, 9, _, _, _), S),
    left(s(french, _, _, blue, _), s(_, _, coffee, _, _), S),
    next(s(_, _, cocoa, _, _), s(_, _, _, _, marseille), S),
    member(s(brazilian, _, _, _, manila), S),
    next(s(_, _, rice, _, _), s(_, _, _, green, _), S); next(s(_, _, _, green, _), s(_, _, rice, _, _), S),
    member(s(_, 5, _, _, genoa), S),
    next(s(_, 7, _, _, _), s(_, _, _, _, marseille), S),
    member(s(_, _, _, red, hamburg), S),
    next(s(_, 7, _, _, _), s(_, _, _, white, _), S); next(s(_, _, _, white, _), s(_, 7, _, _, _), S),
    border(s(_, _, corn, _, _), S), %border condition
    S = [s(_, _, corn, _, _)|_]; reverse(S, [s(_, _, corn, _, _)|_]),
    member(s(_, 8, _, black, _), S),
    next(s(_, _, corn, _, _), s(_, _, rice, _, _), S),
    member(s(_, 6, _, _, hamburg), S),
    
	member(s(_,_,_,_,portSaid),S),   % forces some ship to go to Port Said
	member(s(_,_,tea,_,_),S).        % forces some ship to carry tea
    
% Predicates for connecting relationships in list of ships, Ls
next(A, B, Ls) :- append(_, [A, B|_], Ls).
next(A, B, Ls) :- append(_, [B, A|_], Ls).
     
left(A, B, Ls) :- next(A, B, Ls).
left(A, B, Ls) :- next(A, C, Ls), left(C, B, Ls).
             
border(A, [A|_]).
border(A, Ls) :- append(_, [A], Ls).

% --Output--
% ?- goes_PortSaid(Goes)
% Goes = greek
% ?- carries_tea(Carries)
% Carries = true