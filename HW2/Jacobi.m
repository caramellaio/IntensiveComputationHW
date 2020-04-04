function x = Jacobi(A, b, epsilon, useExactCriteria, parallel)
  x = IterativeMethods(A, b, epsilon, useExactCriteria, true, parallel);
end
