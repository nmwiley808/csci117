% Part 1: Basic Structural Recursion

% --deal--
deal([],[],[]).
deal([X],[X],[]).
deal([X,Y|Xs], [X|Zs], [Y|Ys]) :-
    deal(Xs, Zs, Ys).

%test
% mode(+,-)
%deal([1,2,3,4,5,6,7,8], X, Y)
%X = [1, 3, 5, 7],
%Y = [2, 4, 6, 8]
%deal([2,4,6,8,10,12,14,16], X, Y) 
%X = [2, 6, 10, 14],
%Y = [4, 8, 12, 16]
%deal([], X, Y)
% X = Y, Y = []

% --merge--
% mode (+,+,-)
merge([],Ys, Ys).
merge(Xs, [], Xs).
merge([X|Xs], [Y|Ys], [X|Zs]) :-
    X =< Y,
    merge(Xs, [Y|Ys], Zs).
merge([X|Xs], [Y|Ys], [Y|Zs]) :-
    X > Y,
    merge([X|Xs], Ys, Zs).

% --Mergesort--
ms([], []).
ms([X], [X]).
ms(Xs, Solution) :-
    deal(Xs, Zs, Ys),
    ms(Zs, MsZs),
    ms(Ys, MsYs),
    merge(MsZs, MsYs, Solution).

%test
% mode (+,-)
%ms([4,2,2,1,3,7,10],X)
%X = [1, 2, 2, 3, 4, 7, 10]
%ms([10,4,8,9,2,3],X)
%X = [2, 3, 4, 8, 9, 10]
%ms([1,5,4,3,12,2],X)
%X = [1, 2, 3, 4, 5, 12]

% --backwards list data structure --
blist(nil).
blist(snoc(Xs, _)) :- blist(Xs).

cons(X, nil, snoc(nil, X)).
cons(X, snoc(Xs, Y), snoc(NewXs, Y)) :-
    cons(X, Xs, NewXs).

%test
% mode(+,+,-)
%cons(6, snoc(snoc(nil,2),3), X)
%X = snoc(snoc(snoc(nil,6),2),3)
%cons(10, snoc(snoc(snoc(nil,7),8),9), X)
%X = snoc(snoc(snoc(snoc(nil,10),7),8),9)
%cons(5, snoc(snoc(snoc(nil,2),3),4), X)
%X = snoc(snoc(snoc(snoc(nil,5),2),3),4)

% --Converting a usual list into a BList--
toBlist([], _).
toBlist([X|Xs], R) :-
    toBlist(Xs, BListXs),
    cons(X, BListXs, R).

%test
% mode(+,-)
%toBlist([1,2,3,4,5], X)
%X = snoc(snoc(snoc(snoc(snoc(nil,1),2),3),4),5)
%toBlist([2,4,6,8], X)
%X = snoc(snoc(snoc(snoc(nil,2),4),6),8)
%toBlist([], X)
%true

% --add element to end of an ordinary list--
snoc([], X, [X]).
snoc([Y|Xs], X, [Y|R]) :- snoc(Xs, X, R).

%test
% mode(+,+,-)
%snoc([1,2,3,4,5], 6, X)
%X = [1, 2, 3, 4, 5, 6]
%snoc([2,4,6,8], 10, X)
%X = [2, 4, 6, 8, 10]
%snoc([], 1, X)
%X = [1]

% --convert a BList into an ordinary list--
fromBlist(_, []).
fromBlist(snoc(Xs, X), R) :-
    fromBlist(Xs, ListXs),
    snoc(ListXs, X, R).

%test
% mode(+,-)
%fromBlist(snoc(snoc(snoc(nil, 1), 2), 3), X)
%X = []
%fromBlist(snoc(snoc(snoc(nil, 2), 6), 10), X)
%X = []
%fromBlist(snoc(snoc(nil, 1), 2), X)
%fromBlist(snoc(snoc(nil, 1), 2), X)

% --count the number of empty nodes in a tree--
num_nodes(empty, 0).
num_nodes(node(_, Tree1, Tree2), Count) :-
    num_nodes(Tree1, Count1),
    num_nodes(Tree2, Count2),
    Count is Count1 + Count2 + 1.

%test
% mode(+,-)
%num_nodes(empty, Count)
%Count = 0
%num_nodes(node(a, empty, empty), Count)
%Count = 1

% --inserting a new node in leftmost part of a tree--
insert_left(X, empty, node(X, empty, empty)).
insert_left(X, node(Y, Tree1, Tree2), node(Y, NewTree1, Tree2)) :-
    insert_left(X, Tree1, NewTree1).

%test
% mode(+,+,-)
%insert_left(n, empty, L)
%L = node(n,empty,empty)


% --inserting a new node in rightmost part of a tree--
insert_right(X, empty, node(X, empty, empty)).
insert_right(X, node(Y, Tree1, Tree2), node(Y, Tree1, NewTree2)) :-
    insert_right(X, Tree2, NewTree2).

%test
% mode(+,+,-)
%insert_right(n, empty, R)
%R = node(n,empty,empty)

% --Add up values of nodes in a tree--
sum_nodes(empty, 0).
sum_nodes(node(X, Tree1, Tree2), Sum) :-
    sum_nodes(Tree1, Sum1),
    sum_nodes(Tree2, Sum2),
    Sum is X + Sum1 + Sum2.

%test
% mode(+,-)
%sum_nodes(node(10, empty, empty), Result)
%Result = 10
%sum_nodes(node(10, node(5, empty, empty), empty), Result)
%Result = 15
%sum_nodes(node(10, node(5, empty, empty), node(6, empty, empty)), Result)
%Result = 21

% --Create a list of node values in a tree using inorder traversal--
inorder(empty, []).
inorder(node(X, Tree1, Tree2), R) :-
    inorder(Tree1, R1),
    inorder(Tree2, R2),
    append(R1, [X|R2], R).

%test
% mode(+,-)
%inorder(node(10, empty, empty), Result)
%Result = [10]
%inorder(node(10, node(5, empty, empty), empty), Result)
%Result = [5, 10]
%inorder(node(10, node(5, empty, empty), node(6, empty, empty)), Result)
%Result = [5, 10, 6]


% --count the number of elements (leaf or node) in a tree--
num_elts(leaf(_), 1).
num_elts(node2(_, Left, Right), Count) :-
    num_elts(Left, Count1),
    num_elts(Right, Count2),
    Count is Count1 + Count2 + 1.

%test
% mode(+,-)
%num_elts(node2(7, leaf(4), leaf(3)), Result)
%Result = 3
%num_elts(node2(7, node2(18, leaf(1), leaf(2)), leaf(3)), Result)
%Result = 5
%num_elts(node2(7, node2(18, leaf(1), leaf(2)), node2(15, leaf(11), leaf(3))), Result)
%Result = 7


% --Add up all the elements in a tree--
sum_nodes2(leaf(X), X).
sum_nodes2(node2(X, Left, Right), Sum) :-
    sum_nodes2(Left, Sum1),
    sum_nodes2(Right, Sum2),
    Sum is X + Sum1 + Sum2.

%test
% mode(+,-)
%sum_nodes2(node2(7, leaf(4), leaf(3)), Result)
%Result = 14
%sum_nodes2(node2(7, node2(18, leaf(1), leaf(2)), leaf(3)), Result)
%Result = 31
%sum_nodes2(node2(7, node2(18, leaf(1), leaf(2)), node2(15, leaf(11), leaf(3))), Result)
%Result = 57

% --Inorder v2--
inorder2(leaf(X), [X]).
inorder2(node2(X, Left, Right), R) :-
    inorder2(Left, R1),
    inorder2(Right, R2),
    append(R1, [X|R2], R).

%test
% mode(+,-)
%inorder2(node2(7, leaf(4), leaf(3)), Result)
%Result = [4,7,3]
%inorder2(node2(7, node2(18, leaf(1), leaf(2)), leaf(3)), Result)
%Result = [1, 18, 2, 7, 3]
%inorder2(node2(7, node2(18, leaf(1), leaf(2)), node2(15, leaf(11), leaf(3))), Result)
%Result = [1, 18, 2, 7, 11, 15, 3]

% Part 2: Iteration and Accumulators

% --Convert a usual list into a BList using iterative helper function--
toBList2(Xs, BList) :- toBL_it(Xs, [], BList).
toBL_it([], BList, BList).
toBL_it([X|Xs], Accum, BList) :- snoc(Accum, X, NewAccum), toBL_it(Xs, NewAccum, BList).
toBList(Xs, BList) :- toBList2(Xs, BList).

%test
% mode(+,-)
%toBList2([2,4,6], BList)
%BList = [2, 4, 6]
%toBList2([1,2,3,4,5], BList)
%BList = [1, 2, 3, 4, 5]
%toBList2([1,2,3,4,5,6,7], BList)
%BList = [1, 2, 3, 4, 5, 6, 7]

% --Find sum of nodes in a tree using iterative helper function--
sum_nodes_it(T, N) :- sum_help([T], 0, N).
sum_help([], A, A).
sum_help([empty|Ts], A, N) :- sum_help(Ts, A, N).
sum_help([node(E,L,R)|Ts], A, N) :- AE is A + E, sum_help([L,R|Ts], AE, N).

%test
% mode(+,-)
%sum_nodes_it(node(7, node(8, empty, empty), node(5, empty, empty)), Result)
%Result = 20
%sum_nodes_it(node(7, empty, node(5, empty, empty)), Result)
%Result = 12
%sum_nodes_it(node(7, node(3, empty, empty), node(5, empty, empty)), Result)
%Result = 15

% --Count number of Empty Nodes in a tree using iterative helper function--
num_empties_it(Tree, Count) :- num_help([Tree], 0, Count).
num_help([], Count, Count).
num_help([_|Ts], Accum, Count) :- num_help(Ts, Accum, Count).
num_help([node(_, L, R)|Ts], Accum, Count) :- num_help([R, L|Ts], Accum, Count).
num_help(Tree, Count) :- num_help([Tree], 0, Count).

%test
% mode(+,-)
%num_empties_it([node(_, empty, empty)],Result)
%Result = 0
%num_empties_it([node(5, node(3, empty, empty), empty)],Result)
%Result = 0


% --Count number of "Node" nodes in a tree using iterative helper function--
num_nodes_it(Tree, Count) :- num_help([Tree], 0, Count).
num_nodes_help([], Count, Count).
num_nodes_help([_|Ts], Accum, Count) :- num_nodes_help(Ts, Accum, Count).
num_nodes_help([node(_, L, R)|Ts], Accum, Count) :- NewAccum is Accum + 1, num_help([R, L|Ts], NewAccum, Count).
num_nodes_help(Tree, Count) :- num_nodes_help([Tree], 0, Count).

%test
% mode(+,-)
%num_nodes_it(node(5, empty, empty),Result)
%Result = 0
%num_nodes_it([node(5, node(3, empty, empty), empty)],Result)
%Result = 0   ...

% --Find the sum of nodes of a Tree2 using iterative helper function--
sum_nodes2_it(Tree2, Sum) :- sum_nodes2_help([Tree2], 0, Sum).
sum_nodes2_help([], A, A).
sum_nodes2_help([leaf(X)|Ts], A, Sum) :-
    NewA is X + A,
    sum_nodes2_help(Ts, NewA, Sum).
sum_nodes2_help([node2(X, L, R)|Ts], A, Sum) :-
    NewA is X + A,
    sum_nodes2_help([L,R|Ts], NewA, Sum).

%test
% mode(+,-)
%sum_nodes2_it(node2(7, leaf(3), leaf(2)), Result)
%Result = 12
%sum_nodes2_it(node2(7, node2(5, leaf(1), leaf(6)), leaf(2)), Result)
%Result = 21
%sum_nodes2_it(node2(7, node2(5, leaf(1), leaf(6)), node2(9, leaf(12), leaf(11))), Result)
%Result = 51

% --Traverse through a Tree2 using iterative helper function--
% --Define the predicate for inorder traversal--
inorder2_it(Tree, List) :- inorder2_helper(Tree, List).
inorder2_helper([], []).
inorder2_helper(leaf(X), [X]).
inorder2_helper(node2(X, Left, Right), R) :-
    inorder2_helper(Left, LeftL),
    inorder2_helper(Right, RightL),
    append(LeftL, [X|RightL], R).

%test
% mode(+,-)
%inorder2_it(node2(7, leaf(3), leaf(2)), Result)
%Result = [3, 7, 2]
%inorder2_it(node2(7, node2(5, leaf(1), leaf(6)), leaf(2)), Result)
%Result = [1, 5, 6, 7, 2]
%inorder2_it(node2(7, node2(5, leaf(1), leaf(6)), node2(9, leaf(12), leaf(11))), Result)
%Result = [1, 5, 6, 7, 12, 9, 11]


% --Convert a Tree2 into an equivalent Tree1 with same elements--
conv21(leaf(X), node(X, empty, empty)).
conv21(node2(X, Left, Right), node(X, ConvL, ConvR)) :-
    conv21(Left, ConvL),
    conv21(Right, ConvR).

%test
% mode(+,-)
%conv21(node2(7, leaf(3), leaf(2)), Result)
%Result = node(7,node(3,empty,empty),node(2,empty,empty))
%conv21(node2(7, node2(5, leaf(1), leaf(6)), leaf(2)), Result)
%Result = node(7,node(5,node(1,empty,empty),node(6,empty,empty)),node(2,empty,empty))
%conv21(node2(7, node2(5, leaf(1), leaf(6)), node2(9, leaf(12), leaf(11))), Result)
%Result = node(7,node(5,node(1,empty,empty),node(6,empty,empty)),node(9,node(12,empty,empty),node(11,empty,empty)))

% Part 4: Iteration and Accumulators

% --conv21 func--
conv12(empty, nothing).
conv12(node(X, Left, Right), R) :-
    conv12(Left, LeftR),
    conv12(Right, RightR),
    R = node2(X, LeftR, RightR).
conv12(Tree, nothing) :- var(Tree), !.
conv12(empty, Leaf) :- Leaf = leaf(_).
conv12(node(Value, Left, Right), Node2) :-
    conv12(Left, LeftR),
    conv12(Right, RightR),
    Node2 = node2(Value, LeftR, RightR).

%test
% mode(+, -)
%conv12(node(10, empty, empty), X)
%X = node2(10,nothing,nothing)
%conv12(node(10, node(5, empty, empty), empty), X)
%X = node2(10,node2(5,nothing,nothing),nothing)
%conv12(node(10, node(5, empty, empty), node(7, empty, empty)), X)
%X = node2(10,node2(5,nothing,nothing),node2(7,nothing,nothing))

% --BST func--
bst(Tree) :- is_bst(Tree, -inf, inf).
is_bst(empty, _, _).
is_bst(node(X, Left, Right), Low, High) :-
    X > Low,
    X < High,
    is_bst(Left, Low, X),
    is_bst(Right, X, High).

%test
% mode(+)
%bst(node(10, node(5, empty, empty), node(7, empty, empty)))
%false
%bst(node(10, node(5, empty, empty), node(17, empty, empty)))
%true
%bst(node(10, empty, node(17, empty, empty)))
%true