% red pair overlapping a grey horizontal trio, only one grey cell showing.
cell(0, 0, red). cell(1, 0, red).

cell(2, 0, grey).

% normal definitions for disjoint unrelated objects
pair(PX, PY, PC) :- cell(PX, PY, PC), cell(PX+1,PY,PC).
trio(TX, TY, TC) :- cell(TX, TY, TC), cell(TX+1,TY,TC), cell(TX+2,TY,TC).



% stack encoded as intermediate layer predicates each with its component
% on board
stack(P, T) :- stack_layer(1, P),
               stack_layer(2, T).

% one set of rules per layer in the declared stack.
% layer one lifts all cells as candidates.
stack_pair_cell(PX, PY, PC) :- cell(PX, PY, PC).
% this structure is exactly like the standard pair, but predicates specific to the layer.
stack_pair(PX, PY, PC) :- stack_pair_cell(PX, PY, PC), stack_pair_cell(PX+1,PY,PC).

% because the first layer is a pair, any valid pair could represent the
% top layer of the stack.  The stack will only be complete if _all_ layers
% are substantiated.
stack_layer(1, P) :- stack_pair(PX, PY, PC),
                     P = stack_pair(PX, PY, PC).

% because the structure of a pair is known, we can use the layer itself as a reason
% to consider all covered cells wild.  Note the layer annotation so we only consider
% cells that are covered by "higher" layers.
wild_cell(CX, CY, L) :- stack_layer(L, P), P = stack_pair(PX, PY, PC), CX = PX, CY = PY.
wild_cell(CX, CY, L) :- stack_layer(L, P), P = stack_pair(PX, PY, PC), CX = PX + 1, CY = PY.


% layer two is a trio, and it can use any valid cell, or any wild cell,
% so we take all the available wild cells and put facts for all colors into
% this layer of the stack aat those positions.
stack_trio_cell(TX, TY, TC) :- cell(TX, TY, TC).
stack_trio_cell(TX, TY, TC) :- wild_cell(TX, TY, L), L < 2, TC = (red; grey; yellow; black).

% the trio structure here is precisely the same as raw trios on raw cells.
stack_trio(TX, TY, TC) :- stack_trio_cell(TX, TY, TC),
                          stack_trio_cell(TX+1,TY,TC),
                          stack_trio_cell(TX+2,TY,TC).

stack_layer(2, T) :- stack_trio(TX, TY, TC), T = stack_trio(TX, TY, TC).

% each layer only creates new wild cell facts that are not already covered by a lower layer.
wild_cell(CX, CY, L) :- stack_layer(L, T), T = stack_trio(TX, TY, TC),
                        CX = TX, CY = TY.
wild_cell(CX, CY, L) :- stack_layer(L, T), T = stack_trio(TX, TY, TC),
                        CX = TX + 1, CY = TY.
wild_cell(CX, CY, L) :- stack_layer(L, T), T = stack_trio(TX, TY, TC),
                        CX = TX + 2, CY = TY.

#show stack_trio_cell/3.
% stack(stack_pair(0,0,red),stack_trio(0,0,grey))

              