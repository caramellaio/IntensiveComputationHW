N = int32(3);
m = 2 ^N -1:2^N +1;
M = prod(m);
% (i) random values
X1 = int32(rand * M)
X2 = int32(rand * M)

% (ii)
% rns repr
RNS_X1 = binaryToRNS(X1, N)
RNS_X2 = binaryToRNS(X2, N)

% sum modulo m
RNS_SUM = mod(RNS_X1 + RNS_X2, m);

% (iii)
% RB sums
[RB_X11N, RB_X11R] = radix10ToRB(RNS_X1(1));
[RB_X12N, RB_X12R] = radix10ToRB(RNS_X1(2));
[RB_X13N, RB_X13R] = radix10ToRB(RNS_X1(3));

[RB_X21N, RB_X21R] = radix10ToRB(RNS_X2(1));
[RB_X22N, RB_X22R] = radix10ToRB(RNS_X2(2));
[RB_X23N, RB_X23R] = radix10ToRB(RNS_X2(3));

[RB_SUM1N, RB_SUM1R] = RBSum(RB_X11N, RB_X11R, RB_X21N, RB_X21R)
[RB_SUM2N, RB_SUM2R] = RBSum(RB_X12N, RB_X12R, RB_X22N, RB_X22R)
[RB_SUM3N, RB_SUM3R] = RBSum(RB_X13N, RB_X13R, RB_X23N, RB_X23R)
