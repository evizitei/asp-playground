% red pair overlapping a 
%   green v-triad overlapping a
%     yellow square3 overlapping a 
%       grey h-quad
cell(0, 0, red).   cell(1, 0, red).    cell(2, 0, yellow). cell(3, 0, grey).
cell(0, 1, green). cell(1, 1, yellow). cell(2, 1, yellow). cell(3, 1, black).
cell(0, 2, green). cell(1, 2, yellow). cell(2, 2, yellow). cell(3, 2, black).
cell(0, 3, black). cell(1, 3, black).  cell(2, 3, black).  cell(3, 3, black).

% normal definitions for disjoint unrelated objects
% which will not work parsing here (except layer 1).
pair(PX, PY, PC) :- cell(PX, PY, PC), cell(PX+1,PY,PC).
vtrio(TX, TY, TC) :- cell(TX, TY, TC),
                     cell(TX, TY+1, TC),
                     cell(TX, TY+2, TC).
square3(SX, SY, SC) :- cell(SX, SY, SC), cell(SX+1, SY, SC), cell(SX+2, SY, SC),
                    cell(SX, SY+1, SC), cell(SX+1, SY+1, SC), cell(SX+2, SY+1, SC),
                    cell(SX, SY+2, SC), cell(SX+1, SY+2, SC), cell(SX+2, SY+2, SC).
hquad(QX, QY, QC) :- cell(QX,  QY,QC), 
                     cell(QX+1,QY,QC), 
                     cell(QX+2,QY,QC),
                     cell(QX+3,QY,QC).


% stack encoded as intermediate layer predicates each with its component
% on board.  This stack is conjectured, we assume we are specifying what is there,
% and then can check whether it parses or not.
stack(pair(PX, PY, PC), vtrio(TX, TY, TC), 
      square3(SX, SY, SC), hquad(QX, QY, QC)) :- stack_layer(4, Q), 
                            Q = stack_hquad(QX, QY, QC, S), 
                            S = stack_square3(SX, SY, SC, T),
                            T = stack_vtrio(TX, TY, TC, P),
                            P = stack_pair(PX, PY, PC).

% one set of rules per layer in the declared stack.
% layer one lifts all cells as candidates.
stack_pair_cell(PX, PY, PC) :- cell(PX, PY, PC), PC != black.
% this structure is exactly like the standard pair, but predicates specific to the layer.
stack_pair(PX, PY, PC) :- stack_pair_cell(PX, PY, PC), stack_pair_cell(PX+1,PY,PC).

% layer 1 only exists if you can find a pair.
% ALL layers are required for the whole stack 
% (see stack(P, Q, S, T) above)
stack_layer(1, P) :- stack_pair(PX, PY, PC),
                     P = stack_pair(PX, PY, PC).

% because the structure of a pair is known, we can use the layer itself as a reason
% to consider all covered cells wild.  Note the layer annotation so we only consider
% cells that are covered by "higher" layers.
%
% NOTE: it's actully important that we carry along the stack so far for these wild cells
% because that prevents collisions with other possible layer 1 pairs.
wild_cell(CX, CY, L, P) :- stack_layer(L, P), P = stack_pair(PX, PY, PC), CX = PX, CY = PY.
wild_cell(CX, CY, L, P) :- stack_layer(L, P), P = stack_pair(PX, PY, PC), CX = PX + 1, CY = PY.

% layer two is a vertical_trio, and it can use any valid cell, or any wild cell,
% so we take all the available wild cells and put facts for all colors into
% this layer of the stack aat those positions.
stack_vtrio_cell(TX, TY, TC, P) :- cell(TX, TY, TC), stack_layer(1, P), TC != black.
stack_vtrio_cell(TX, TY, TC, P) :- wild_cell(TX, TY, L, P), L = 1, TC = (red; grey; yellow; green).

% the trio structure here is precisely the same as raw trios on raw cells.
% P in this encoding is the chosen atom for the FIRST layer.
stack_vtrio(TX, TY, TC, P) :- stack_layer(1, P),
                          stack_vtrio_cell(TX, TY, TC, P),
                          stack_vtrio_cell(TX,TY+1,TC, P),
                          stack_vtrio_cell(TX,TY+2,TC, P).

stack_layer(2, T) :- stack_vtrio(TX, TY, TC, P), T = stack_vtrio(TX, TY, TC, P).

% each layer uses all wilds from the level below, plus any implied by this new layer
% coverage
wild_cell(CX, CY, 2, T) :- stack_layer(2, T), T = stack_vtrio(TX, TY, TC, P), 
                        wild_cell(CX, CY, 1, P).
wild_cell(CX, CY, 2, T) :- stack_layer(2, T), T = stack_vtrio(TX, TY, TC, P),
                        CX = TX, CY = TY.
wild_cell(CX, CY, 2, T) :- stack_layer(2, T), T = stack_vtrio(TX, TY, TC, P),
                        CX = TX, CY = TY + 1.
wild_cell(CX, CY, 2, T) :- stack_layer(2, T), T = stack_vtrio(TX, TY, TC, P),
                        CX = TX, CY = TY + 2.

% layer three is a square (3x3), and it can use any valid cell, or any wild cell.
stack_square3_cell(SX, SY, SC, T) :- cell(SX, SY, SC), stack_layer(2, T), SC != black.
stack_square3_cell(SX, SY, SC, T) :- wild_cell(SX, SY, 2, T), SC = (red; grey; yellow; green).

% square structure is exactly like standard square, but can use wild cells.
stack_square3(SX, SY, SC, T) :- stack_layer(2, T),
  stack_square3_cell(SX, SY, SC, T), stack_square3_cell(SX+1, SY, SC, T), stack_square3_cell(SX+2, SY, SC, T),
  stack_square3_cell(SX, SY+1, SC, T), stack_square3_cell(SX+1, SY+1, SC, T), stack_square3_cell(SX+2, SY+1, SC, T),
  stack_square3_cell(SX, SY+2, SC, T), stack_square3_cell(SX+1, SY+2, SC, T), stack_square3_cell(SX+2, SY+2, SC, T).

stack_layer(3, S) :- stack_layer(2, T), stack_square3(SX, SY, SC, T), S = stack_square3(SX, SY, SC, T).

% each layer uses all wilds from the level below, plus any implied by this new layer
% coverage (there are a lot for a 3x3 square)
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T), 
                        wild_cell(CX, CY, 2, T).
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T),
                        CX = SX, CY = SY.
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T),
                        CX = SX + 1, CY = SY.
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T),
                        CX = SX + 2, CY = SY.
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T),
                        CX = SX, CY = SY + 1.
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T),
                        CX = SX + 1, CY = SY + 1.
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T),
                        CX = SX + 2, CY = SY + 1.
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T),
                        CX = SX, CY = SY + 2.
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T),
                        CX = SX + 1, CY = SY + 2.
wild_cell(CX, CY, 3, S) :- stack_layer(3, S), S = stack_square3(SX, SY, SC, T),
                        CX = SX + 2, CY = SY + 2.

% layer four is a horizontal quad, and it can use any valid cell, or any wild cell.
stack_hquad_cell(QX, QY, QC, S) :- cell(QX, QY, QC), stack_layer(3, S), QC != black.
stack_hquad_cell(QX, QY, QC, S) :- wild_cell(QX, QY, 3, S), QC = (red; grey; yellow; green).

% HQuad structure is exactly like standard hquad, but can use wild cells.
stack_hquad(QX, QY, QC, S) :- stack_layer(3, S),
                              stack_hquad_cell(QX, QY, QC, S),
                              stack_hquad_cell(QX+1, QY, QC, S),
                              stack_hquad_cell(QX+2, QY, QC, S),
                              stack_hquad_cell(QX+3, QY, QC, S).

stack_layer(4, Q) :- stack_hquad(QX, QY, QC, S), Q = stack_hquad(QX, QY, QC, S).

#show stack_square3/4.
#show stack/4.