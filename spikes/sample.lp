int(-64..64).
cell(0..30, 0..30, 0..9).

add_rel_1(A, B, C) :- int(A), int(B), int(C), A + B = C.
add_rel_2(A, B) :- int(A), int(B), A > B.

1 { composed_add_rel(A, B, C) : add_rel_1(A, B, C), add_rel_2(A, B) } 5.

1 { cell_rel_1(cell(X, Y, C)) : cell(X, Y, C), C = 1 } 5.

#show cell_rel_1/1.
#show composed_add_rel/3.

sample_rel_composed_add_rel(A, B, C) :- composed_add_rel(A, B, C).
sample_rel_cell_rel_1(X, Y, C) :- cell_rel_1(cell(X, Y, C)).

% this blows up the grounder because the grounder is required to compute the herbrand base before discarding.
%  Even though we only select a few of the intermediate relations, the grounder has to get all of them.
%  The space is dramatically decreased if we place constraints on this relation, but since they're actually
% independent in the underlying relation, the space is big.
%
%  This yields an interesting strategy: if you can determine elements of a relation are actually independent,
% you can solve for sampling them separately (and should!).
% 1 { sample_rel(A, B, Ci, c(X, Y, Clr)) : composed_add_rel(A, B, Ci), cell_rel_1(cell(X, Y, Clr))} 5.
#show sample_rel/4.