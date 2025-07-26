% at least all the input cells are also in the output
out_cell(X,Y,C) :- cell(X,Y,C).

% detect conditions where cells are in the right configuration
% to have cells between.
in_row(out_cell(X1,Y,C), out_cell(X2,Y,C)) :- out_cell(X1,Y,C),
                                          out_cell(X2,Y,C),
                                          X1 < X2.
in_column(out_cell(X,Y1,C), out_cell(X,Y2,C)) :- out_cell(X,Y1,C),
                                          out_cell(X,Y2,C),
                                          Y1 < Y2.

% generate the cells in rows and columns to connect
out_cell(Xnew,Y,C) :- in_row(out_cell(X1,Y,C), out_cell(X2,Y,C)), Xnew = X1 + 1, Xnew < X2.
out_cell(X,Ynew,C) :- in_column(out_cell(X,Y1,C), out_cell(X,Y2,C)), Ynew = Y1 + 1, Ynew < Y2.

                                

#show out_cell/3.