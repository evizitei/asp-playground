col(r).
col(g).
col(b).

1 { color(X, C) : col(C) } 1 :- node(X).
:- edge(X, Y), color(X, C), color(Y, C).

#show color/2.