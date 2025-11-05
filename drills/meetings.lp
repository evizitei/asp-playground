person(alice). person(bob). person(carol). person(dave). person(eve).
meeting(budget). meeting(strategy). meeting(product).

% each person must attend 2 meetings.
2 { attends(P, M) : meeting(M) } 2 :- person(P).

attendance_count(M, C) :- meeting(M), C = #count{ P : attends(P, M) }.

% each meeting requires minimum 2 people.
:- attendance_count(M, C), C < 2.

% make attendance counts more equal.
:~ attendance_count(M, C1), attendance_count(N, C2), M != N, C2 > C1. [C2-C1, M, N]
% alice and bob clash. We should try to keep them apart.
:~ attends(alice, M), attends(bob, M). [5, alice, bob]

% dave really wants to be in the budget meeting.
:~ meeting(budget), not attends(dave, budget). [10, dave, budget]

#show attends/2.

