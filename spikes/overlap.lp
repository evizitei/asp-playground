cell(0, 0, red). cell(1, 0, red).

cell(2, 0, grey).

cell(0, 1, yellow). cell(1, 1, yellow).

pair(PX, PY, PC) :- cell(PX, PY, PC), cell(PX+1,PY,PC).
trio(TX, TY, TC) :- cell(TX, TY, TC), cell(TX+1,TY,TC), cell(TX+2,TY,TC).
% cannot find trio because its occluded by pair

#show pair/3.
#show trio/3.