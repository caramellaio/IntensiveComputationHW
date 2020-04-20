function [x2, l2] = fielder(M)
  [x1, l1] = epair(inv(M), 100);
  [x2, l2] = deflation(inv(M), x1, l1);

  l2 = 1 / l2;
end
