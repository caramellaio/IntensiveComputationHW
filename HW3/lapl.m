function lapl_m = lapl(M)
  % we add 1 since M diagonal is 1
  deg_diag = diag(sum(M) + 1);
  lapl_m = deg_diag - M;
end
