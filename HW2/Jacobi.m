function [x, step] = Jacobi(A, b, epsilon, useExactCriteria, parallel)
  [x, step] = IterativeMethods(A, b, epsilon, useExactCriteria, true, parallel);
end
