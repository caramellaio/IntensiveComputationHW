function [x, eig_val] = deflation(A, eig_vec, eig_val)
  %B = A - eig_vec*A(1,:)
  B = A - eig_val* ((eig_vec*eig_vec') / (eig_vec'*eig_vec));
  [x, eig_val] = epair(B, 100);
end
