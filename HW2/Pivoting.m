function funcs = Pivoting
  funcs.getZeroPivoting = @zeroPivoting;
  funcs.getGEEPPartialPivoting = @GEEPPartialPivoting;
  funcs.getGECPCompletePivoting = @GECPCompletePivoting;
end

function new_row_idx = zeroPivoting(A, b, k)

  % if none, swap k with k
  new_row_idx = [k, k];

  if A(k, k) == 0
    % find the next non zero element of the kth column
    nnz_pos = find(A(k+1:end,k))+ k;

    if length(nnz_pos) == 0
      % this matrix cannot be triangular
      fprintf("WARINING: All rows elements of column %d are 0\n", k);
    else
      new_row_idx(1) = nnz_pos(1);
    end

  end
end

function new_swap = GEEPPartialPivoting(A, b, k)

  % we do not use 'all' to be sure we kept a single col
  [foo, new_row_idx] = max(abs(A(k+1:end, k)));

  % adjust index
  assert(length(new_row_idx) <= 1);

  if length(new_row_idx) == 1 && foo(1) > abs(A(k,k))
    new_row_idx = new_row_idx + k;
    new_row_idx = new_row_idx(1);
  else
    new_row_idx = k;
  end

  new_swap = [new_row_idx k];
end

function new_swap = GECPCompletePivoting(A, b, k)
  abs_m = abs(A(k:end, k:end));
  lst = abs_m(:);
  [val, tmp_idx] = max(lst);

  % parse index into the result
  [x, y] = ind2sub(size(abs_m), tmp_idx);
  new_swap = [x, y] + k - 1;
end
