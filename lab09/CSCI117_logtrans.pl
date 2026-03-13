man(jeffery).
woman(mariah).
child(julio).
child(meagan).
loves(jeffery, mariah).
loves(mariah, meagan).
knows(jeffery, julio).
lives(jeffery).
runs(mariah).
runs(juilo).

exists(_, P) :- call(P), !.
all(_, P) :- \+ (call(P), fail).
imp(A, B) :- B, A.

determiner(_, every, S, P1, P2) :- all(S, imp(P1, P2)).
determiner(_, a, S, P1, P2) :- exists(S, and(P1, P2)).

nounPhrase(N, _, X, X) :- name(N, X).
nounPhrase(N, _, X0, X) :-
    determiner(N, X0, _, P2, _),
    relClause(N, P2, _, X).

transVerb(S, O) :- loves(S, O).
transVerb(S, O) :- knows(S, O).
intransVerb(S, lives(S)) :- lives(S).
intransVerb(S, runs(S)) :- runs(S).

sentence(X0, X) :-
    nounPhrase(N, _, X0, X1),
    verbPhrase(N, X1, X).

verbPhrase(S, X0, _) :-
    transVerb(S, X0).
   
verbPhrase(S, X0, _) :-
    intransVerb(S, X0).

relClause(S, P1, who, and(P1, P2)) :- verbPhrase(S, P2, _).
relClause(_, P1, _, P1).

name(jeffery, jeffery).
name(mariah, mariah).
name(julio, julio).
name(meagan, meagan).

%--testing--
% tranVerb(mariah, Verb)
% Verb = meagan
% transVerb(jeffery, Verb)
% Verb = mariah
% intransVerb(jeffery, lives(jeffery))
% true
% intransVerb(julio, lives(julio))
% false
% sentence([every, woman, who ,loves, jeffery, lives], X)
%false