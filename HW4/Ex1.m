N = int32(6);
m = 2 ^N -1:2^N +1;
M = prod(m);
% (i) random values
X1 = int32(rand * M);
X2 = int32(rand * M);

fprintf("x1 = %d, x2 = %d\n", X1, X2);

% (ii)
% rns repr

fprintf("Considering the module set m = <%d, %d, %d>\n", m);

RNS_X1 = binaryToRNS(X1, N);
fprintf("RNS(x1, m) = < %d, %d, %d>\n", RNS_X1)

RNS_X2 = binaryToRNS(X2, N);
fprintf("RNS(x2, m) = < %d, %d, %d>\n", RNS_X2)

% show the sum
RNS_SUM = mod(RNS_X1 + RNS_X2, m);

fprintf("Normal RNS sum: <%d, %d, %d>\n", RNS_SUM);


% (iii)
% RB sums

fprintf("Converting RNS digits to RB format...\n");
SUM = zeros(1, 3);

for i=1:3

  nbits = 0;

  % the last element consider 1 more bit (2^n + 1)
  if i == 3
    nbits = N + 1;
  else
    nbits = N;
  end

  fprintf("converting RNS_X1(%d) to RB:\n", i);

  [xn1, xr1] = radix10ToRB(RNS_X1(i), nbits + 1)
  [xn2, xr2] = radix10ToRB(RNS_X2(i), nbits + 1)



  fprintf("Computing RBSum %d step:\n", i);

  [sn, sr] = RBSum(xn1, xr1, xn2, xr2);


  sRB = RBToRadix10(sn, sr);

  fprintf("RBToRadix10(sumRB): %d\n", sRB);

  res = mod(RBToRadix10(sn, sr), m(i));

  fprintf("RBToRadix10 mod m(%d) = %d\n", i, res);

  SUM(i) = res;
end

fprintf("The sum X1 + X2 = <%d, %d, %d>\n", SUM);

% Here I check that the representation is equal to the normal sum.
assert(isequal(SUM, mod(X1 + X2, m)));
