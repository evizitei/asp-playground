stack(pair(0,0,red),vtrio(0,0,green),square3(0,0,yellow),hquad(0,0,grey)).

% going the other way, the only fact we have is that there is a stack
% with a configuration of known functors that specify what's in the stack.
% Probably we can run the same structure top to bottom to infer the actual
% rendered cells.

stack_layer(1, P) :- stack(P, T, S, Q).
stack_layer(2, T) :- stack(P, T, S, Q).
stack_layer(3, S) :- stack(P, T, S, Q).
stack_layer(4, Q) :- stack(P, T, S, Q).

% layer 1 is trivial, we should just produce the structure of the object.
% as inference rules.
layer_cell(CX, CY, CC, 1) :- stack_layer(1, P), P = pair(X, Y, C),
                             CX = X, CY = Y, CC = C.
layer_cell(CX, CY, CC, 1) :- stack_layer(1, P), P = pair(X, Y, C),
                             CX = X + 1, CY = Y, CC = C.

% layer 2 is a trio.  It should replicate its structure, but negate any cells on the level above.
layer_cell(CX, CY, CC, 2) :- stack_layer(2, T), T = vtrio(X,Y,C),
                             CX=X, CY=Y, CC=C, not layer_cell(CX, CY, _, 1).
layer_cell(CX, CY, CC, 2) :- stack_layer(2, T), T = vtrio(X,Y,C),
                             CX=X, CY=Y+1, CC=C, not layer_cell(CX, CY, _, 1).
layer_cell(CX, CY, CC, 2) :- stack_layer(2, T), T = vtrio(X,Y,C),
                             CX=X, CY=Y+2, CC=C, not layer_cell(CX, CY, _, 1).
% hoist all cells from higher layers.
layer_cell(CX, CY, CC, 2) :- layer_cell(CX, CY, CC, 1).

% layer 3 is a square.  Again, line for each substructure element, but negate cells on higher
% level.
layer_cell(CX, CY, CC, 3) :- stack_layer(3, S), S = square3(X,Y,C),
                             CX=X, CY=Y, CC=C, not layer_cell(CX, CY, _, 2).
layer_cell(CX, CY, CC, 3) :- stack_layer(3, S), S = square3(X,Y,C),
                             CX=X+1, CY=Y, CC=C, not layer_cell(CX, CY, _, 2).
layer_cell(CX, CY, CC, 3) :- stack_layer(3, S), S = square3(X,Y,C),
                             CX=X+2, CY=Y, CC=C, not layer_cell(CX, CY, _, 2).
layer_cell(CX, CY, CC, 3) :- stack_layer(3, S), S = square3(X,Y,C),
                             CX=X, CY=Y+1, CC=C, not layer_cell(CX, CY, _, 2).
layer_cell(CX, CY, CC, 3) :- stack_layer(3, S), S = square3(X,Y,C),
                             CX=X+1, CY=Y+1, CC=C, not layer_cell(CX, CY, _, 2).
layer_cell(CX, CY, CC, 3) :- stack_layer(3, S), S = square3(X,Y,C),
                             CX=X+2, CY=Y+1, CC=C, not layer_cell(CX, CY, _, 2).
layer_cell(CX, CY, CC, 3) :- stack_layer(3, S), S = square3(X,Y,C),
                             CX=X, CY=Y+2, CC=C, not layer_cell(CX, CY, _, 2).
layer_cell(CX, CY, CC, 3) :- stack_layer(3, S), S = square3(X,Y,C),
                             CX=X+1, CY=Y+2, CC=C, not layer_cell(CX, CY, _, 2).
layer_cell(CX, CY, CC, 3) :- stack_layer(3, S), S = square3(X,Y,C),
                             CX=X+2, CY=Y+2, CC=C, not layer_cell(CX, CY, _, 2).
% hoist all cells from higher layers.
layer_cell(CX, CY, CC, 3) :- layer_cell(CX, CY, CC, 2).


% layer 4 is an hquad.  same rules as above.
layer_cell(CX, CY, CC, 4) :- stack_layer(4, Q), Q = hquad(X,Y,C),
                             CX=X, CY=Y, CC=C, not layer_cell(CX, CY, _, 3).
layer_cell(CX, CY, CC, 4) :- stack_layer(4, Q), Q = hquad(X,Y,C),
                             CX=X+1, CY=Y, CC=C, not layer_cell(CX, CY, _, 3).
layer_cell(CX, CY, CC, 4) :- stack_layer(4, Q), Q = hquad(X,Y,C),
                             CX=X+2, CY=Y, CC=C, not layer_cell(CX, CY, _, 3).
layer_cell(CX, CY, CC, 4) :- stack_layer(4, Q), Q = hquad(X,Y,C),
                             CX=X+3, CY=Y, CC=C, not layer_cell(CX, CY, _, 3).
% hoist all cells from higher layers.
layer_cell(CX, CY, CC, 4) :- layer_cell(CX, CY, CC, 3).

cell(X, Y, C) :- layer_cell(X, Y, C, 4).
#show cell/3.