function x = Jacobi(A, b, epsilon, useExactCriteria, pworkers)
  x = IterativeMethods(A, b, epsilon, useExactCriteria, true, pworkers);
end
