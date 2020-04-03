function x = GaussSiedel(A, b, epsilon, useExactCriteria)
  x = IterativeMethods(A, b, epsilon, useExactCriteria, false);
end
