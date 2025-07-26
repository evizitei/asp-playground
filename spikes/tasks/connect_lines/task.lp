% at least all the input cells are also in the output
out_cell(X,Y,C) :- in_cell(X,Y,C).

% detect conditions where cells are in the right configuration
% to have cells between.
in_row(in_cell(X1,Y,C), in_cell(X2,Y,C)) :- in_cell(X1,Y,C),
                                          in_cell(X2,Y,C),
                                          X1 < X2.
in_column(in_cell(X,Y1,C), in_cell(X,Y2,C)) :- in_cell(X,Y1,C),
                                          in_cell(X,Y2,C),
                                          Y1 < Y2.

% base case for cells filling out rows
between_cell(Cell1, Cell2, X,Y,C) :- in_row(Cell1, Cell2), 
                                      Cell1 = in_cell(X,Y,C).
% generate the cells in rows
between_cell(Cell1, Cell2, Xnew, Y, C) :- 
  in_row(Cell1, Cell2),
  between_cell(Cell1, Cell2, Xprev, Y, C),
  Cell2 = in_cell(X2, Y, C),
  Xnew = Xprev + 1, Xnew < X2.


% base case for cells in columns
between_cell(Cell1, Cell2, X, Y, C) :- in_column(Cell1, Cell2),
                                       Cell1 = in_cell(X,Y,C).
% generate the cells in columns
between_cell(Cell1, Cell2, X, Ynew, C) :- 
  in_column(Cell1, Cell2),
  between_cell(Cell1, Cell2, X, Yprev, C),
  Cell2 = in_cell(X, Y2, C),
  Ynew = Yprev + 1, Ynew < Y2.

out_cell(X,Y,C) :- between_cell(_, _, X, Y, C).
                                

#show out_cell/3.
#show in_cell/3.