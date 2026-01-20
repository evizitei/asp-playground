unblocked_row(Anchor2, Anchor2).
unblocked_row(cell(X0, Y, 0, in), Anchor2) :-
  Anchor2 = cell(X1, Y, C, in),
  X2 = X0 + 1,
  NextCell = cell(X2, Y, C2, in),
  unblocked_row(NextCell, Anchor2).

unblocked_col(Anchor2, Anchor2).
unblocked_col(cell(X, Y0, 0, in), Anchor2) :-
  Anchor2 = cell(X, Y1, C, in),
  Y2 = Y0 + 1,
  NextCell = cell(X, Y2, C2, in),
  unblocked_col(NextCell, Anchor2).

same_row(Anchor1, Anchor2) :-
  Anchor1 = cell(X0, Y, C, in),
  Anchor2 = cell(X1, Y, C, in),
  X1 > X0,
  X2 = X0 + 1,
  NextCell = cell(X2, Y, C2, in),
  unblocked_row(NextCell, Anchor2).

same_col(Anchor1, Anchor2) :-
  Anchor1 = cell(X, Y0, C, in),
  Anchor2 = cell(X, Y1, C, in),
  Y1 > Y0,
  Y2 = Y0 + 1,
  NextCell = cell(X, Y2, C2, in),
  unblocked_col(NextCell, Anchor2).


% match on input cells with same x position.
model(cell(X0, Y0, C0, in), cell(X1, Y1, C1, in), cell(X2, Y2, C2, out)) :- 
    same_col(cell(X0, Y0, C0, in), cell(X1, Y1, C1, in)),
    cell(X2, Y2, C2, out),
    X2 = X0, Y2 < Y0, Y2 > Y1, C2 = C0.

% match on input cells with same y position.
model(cell(X0, Y0, C0, in), cell(X1, Y1, C1, in), cell(X2, Y2, C2, out)) :- 
    same_row(cell(X0, Y0, C0, in), cell(X1, Y1, C1, in)),
    cell(X2, Y2, C2, out),
    X2 < X0, X2 > X1, Y2 = Y0, C2 = C0.

% all input cells copied over by default
model(cell(X0, Y0, C0, in), cell(X2, Y2, C2, out)) :- cell(X0, Y0, C0, in), cell(X2, Y2, C2, out),
    X2 = X0, Y2 = Y0, C2 = C0.
