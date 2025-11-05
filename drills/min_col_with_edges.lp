% the graph has 4 nodes.
node(a). node(b). node(c). node(d). node(e). node(f).
% there exist 3 colors.
color(red). color(blue). color(green).
% there are edges between some nodes.
edge(a,b). edge(e,f). edge(c, d).

% there must be a color assignment for each node.
1 { color_assignment(N, C) : color(C) } 1 :- node(N).

% two connected nodes cannot share a color.
:- edge(X, Y), color_assignment(X, C), color_assignment(Y, C).

% lets minimize the count of colors used.
% this grants a penalty of 1 for every tag of C.  Less C means less cost
:~ color_assignment(N, C). [1@1, C]

% should choose to color everything in just 2 colors.
#show color_assignment/2.