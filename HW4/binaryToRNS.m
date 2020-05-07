function [x, dyn_range] = binaryToRNS(X, n)
  % m1, m2, m3
  m = 2^n -1:2^n + 1;
  dyn_range = [0,(prod(m)-1)];

  x = mod(X,m);
end
