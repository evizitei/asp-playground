% the graph has 4 nodes.
node(a). node(b). node(c). node(d).
% there exist 3 colors.
color(red). color(blue). color(green).

% there must be a color assignment for each node.
1 { color_assignment(N, C) : color(C) } 1 :- node(N).

% lets minimize the count of colors used.
% this grants a penalty of 1 for every tag of C.  Less C means less cost
:~ color_assignment(N, C). [1@1, C]

#show color_assignment/2.