% Knight's Tour Program
% N and M are dimensions for the board

knightTour(N, M, T) :-
    N2 is N * M - 1,
    kT(N, M, N2, [m(0, 0)], T).

% Finished: no more knights to place; return accumulator as final tour
kT(_, _, 0, T, T).

kT(N, M, N2, [m(P1, P2) | Pt], T) :-
    moves(m(P1, P2), N, M, m(D1, D2)),
    D1 >= 0, D2 >= 0, D1 < N, D2 < M,
    \+ member(m(D1, D2), Pt),
    N3 is N2 - 1,
    kT(N, M, N3, [m(D1, D2), m(P1, P2) | Pt], T).

moves(m(X, Y), _, _, m(U, V)) :-
    member(m(A, B), [m(1, 2), m(1, -2), m(-1, 2), m(-1, -2), m(2, 1), m(2, -1), m(-2, 1), m(-2, -1)]),
    U is X + A,
    V is Y + B.

closedKnightsTour(N, M, T) :-
    knightTour(N, M, T),
    append(T, [H | _], ClosedTour), 
    H = m(X, Y),
    member(m(X, Y), ClosedTour).

% --Program test run--
%knightTour(6, 7, Tour)
%Tour = [m(1,6), m(0,4), m(2,5), m(0,6), m(1,4), m(2,6), m(0,5), m(1,3), m(0,1), m(2,0), m(4,1), 
%m(5,3), m(4,5), m(3,3), m(5,2), m(4,0), m(2,1), m(0,2), m(1,0), m(2,2), m(3,0), m(5,1), m(3,2), 
%m(1,1), m(0,3), m(1,5), m(2,3), m(3,1), m(5,0), m(4,2), m(5,4), m(4,6), m(3,4), m(5,5), m(4,3), 
%m(3,5), m(5,6), m(4,4), m(3,6), m(2,4), m(1,2), m(0,0)]

%knightTour(5, 5, Tour)
%Tour = [m(0,4), m(2,3), m(4,4), m(3,2), m(4,0), m(2,1), m(0,2), m(1,4), m(3,3), m(4,1), m(2,0),
% m(0,1), m(1,3), m(3,4), m(4,2), m(3,0), m(1,1), m(0,3), m(2,2), m(1,0), m(3,1), m(4,3), m(2,4), 
% m(1,2), m(0,0)]

%closedKnightsTour(5, 4, T)
%T = [m(0,3), m(1,1), m(3,0), m(4,2), m(2,3), m(0,2), m(1,0), m(3,1), m(4,3), m(2,2), m(0,1), 
%m(1,3), m(3,2), m(4,0), m(2,1), m(3,3), m(4,1), m(2,0), m(1,2), m(0,0)]

%closedKnightsTour(6, 7, T)
%T = [m(1,6), m(0,4), m(2,5), m(0,6), m(1,4), m(2,6), m(0,5), m(1,3), m(0,1), m(2,0), m(4,1),
% m(5,3), m(4,5), m(3,3), m(5,2), m(4,0), m(2,1), m(0,2), m(1,0), m(2,2), m(3,0), m(5,1), m(3,2), 
% m(1,1), m(0,3), m(1,5), m(2,3), m(3,1), m(5,0), m(4,2), m(5,4), m(4,6), m(3,4), m(5,5), m(4,3), 
% m(3,5), m(5,6), m(4,4), m(3,6), m(2,4), m(1,2), m(0,0)]