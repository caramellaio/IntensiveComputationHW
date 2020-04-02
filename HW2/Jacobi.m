function x = Jabobi(A, b, epsilon)
  addpath('../HW1');
  err = Inf;
  % usefull functions
  toFull = MSR().toFull;
  zeroPiv = Pivoting().getZeroPivoting;

  n = length(b);
  x = zeros(n, 1);
  new_x = zeros(n, 1);

  exact = gaussianElim(toFull(A), b, zeroPiv, false, false)

  [col_idxs, row_vals] = arrayfun(@(i) genCompRows(A, n, i), 1:n, 'UniformOutput', false);
  % diag values are stored as last element

  step = 0;
  while err > epsilon
    step = step + 1;
    for i = 1:n
      new_x(i) = b(i) / A.V(i) - dot(row_vals{i} / A.V(i), x(col_idxs{i}));
    end

    old_err = err;
    err = norm(exact - new_x, 1);
    assert(err <= old_err);
    x = new_x;
  end

  % WARNING: This function does not include diagonal elements.
  % ASSUMPTION: last element is diagonal
  function [col_idx, row_val] = genCompRows(A, n, i)
    [col_idx_tmp, row_val_tmp] = MSR().extrRowComp(A, n, i);

    % remove diagonal
    col_idx = col_idx_tmp(1:length(col_idx_tmp) - 1);
    row_val = row_val_tmp(1:length(row_val_tmp) - 1);

    assert(length(col_idx) == length(row_val));
  end
end
