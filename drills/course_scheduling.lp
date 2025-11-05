course(math). course(physics). course(chemistry). course(biology).
slot(morning). slot(afternoon). slot(evening).

% each course needs to be scheduled once.
1 { schedule(C, S) : slot(S) } 1 :- course(C).

% the count of courses in each slot has a cost that is super linear.
:~ SC = #count{ C : schedule(C, S)}, slot(S), S != evening. [SC*SC, S]
:~ SC = #count{ C : schedule(C, evening)}. [SC*SC*SC, evening_penalty]

#show schedule/2.