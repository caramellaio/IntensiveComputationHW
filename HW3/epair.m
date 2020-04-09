function [x, eig_val] = epair(M, n)
  x = ones(size(M, 1), 1);
  y = zeros(size(M, 1), 1);
  eig_val = 0;

  for i = 1:n
    y = M * x;
    eig_val = max(y, [], 'all');
    x = y / eig_val;
  end
end
