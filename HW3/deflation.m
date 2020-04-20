function [x, eig_val] = deflation(A, eig_vec, eig_val)
  %B = A - eig_vec*A(1,:)
  [eig_vecs, eig_vals] = eig(A);
  [tmp, tmp_i] = max(abs(eig_vals));

  B = A - eig_val* ((eig_vec*eig_vec') / (eig_vec'*eig_vec));
  [x, eig_val] = epair(B, 100);
end
