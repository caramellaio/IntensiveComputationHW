function x = IterativeMethods(A, b, epsilon, useExactCriteria, jacobi, par)
  addpath('../HW1');
  err = Inf;
  % usefull functions
  toFull = MSR().toFull;
  zeroPiv = Pivoting().getZeroPivoting;

  n = length(b);
  x = zeros(n, 1);
  new_x = zeros(n, 1);

  if useExactCriteria
    exact = gaussianElim(toFull(A), b, zeroPiv, false, false)
  else
    exact = [];
  end

  [col_idxs, row_vals] = arrayfun(@(i) genCompRows(A, n, i), 1:n, 'UniformOutput', false);
  % diag values are stored as last element

  step = 0;

  % divide only once
  used_b = b ./ A.V(1:n);

  while err > epsilon
    step = step + 1;

    if par
      parfor i = 1:n
        row_val = row_vals{i};
        col_idx = col_idxs{i};
        new_x(i) = used_b(i) -dot(row_val, x(col_idx));
      end
    else
      for i = 1:n
        % case GaussSiedel: use already computed value at step i
        x_vals = new_x(col_idxs{i});
        if jacobi
          % case Jacobi
          x_vals = x(col_idxs{i});
        end
        new_x(i) = used_b(i) - dot(row_vals{i}, x_vals);
      end
    end

    old_err = err;
    if useExactCriteria
      err = norm(exact - new_x, 1);
    else
      err = norm(new_x - x);
    end
    assert(err <= old_err);
    x = new_x;
  end

  % WARNING: This function does not include diagonal elements.
  % ASSUMPTION: last element is diagonal
  function [col_idx, row_val] = genCompRows(A, n, i)
    [col_idx_tmp, row_val_tmp] = MSR().extrRowComp(A, n, i);

    % remove diagonal
    col_idx = col_idx_tmp(1:length(col_idx_tmp) - 1);
    row_val = row_val_tmp(1:length(row_val_tmp) - 1) / A.V(i);

    % we divide by the diagonal (avoid multiple calculation inside core jacobi)
    assert(length(col_idx) == length(row_val));
  end
end
