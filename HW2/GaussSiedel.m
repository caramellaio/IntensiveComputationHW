function [x, step] = GaussSiedel(A, b, epsilon, useExactCriteria)
  [x, step] = IterativeMethods(A, b, epsilon, useExactCriteria, false, false);
end
