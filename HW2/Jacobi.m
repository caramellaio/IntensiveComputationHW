function x = Jacobi(A, b, epsilon, useExactCriteria)
  x = IterativeMethods(A, b, epsilon, useExactCriteria, true);
end
