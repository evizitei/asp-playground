% uses constants that must be defined by parameters when invoking
row(1..n).
col(1..n).

n { queen(I,J) : col(I), row(J) } n.

:- queen(I,J), queen(I,J2), J != J2.
:- queen(I,J), queen(I2, J), I != I2.
:- queen(I1, J1), queen(I2, J2), (I1,J1) != (I2, J2), I1 - J1 == I2 - J2.
:- queen(I1, J1), queen(I2, J2), (I1,J1) != (I2, J2), I1 + J1 == I2 + J2.

#show queen/2.