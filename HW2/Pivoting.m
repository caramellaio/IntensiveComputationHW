function funcs = Pivoting
  funcs.getZeroPivoting = @zeroPivoting;
end

function new_row_idx = zeroPivoting(A, b, k, b_swap)

  % if none, swap k with k
  new_row_idx = k;

  if A(k, k) == 0
    % find the next non zero element of the kth column
    nnz_pos = find(A(k+1:end,k)) + k

    if length(nnz_pos) == 0
      % this matrix cannot be triangular
      fprintf("WARINING: All rows elements of column %d are 0\n", k);
    else
      new_row_idx = nnz_pos(1);
      %{
      temp = A(nnz_pos(1), :);
      temp_b = b(nnz_pos(1));
      b(nnz_pos(1)) = b(k);
      b(k) = temp_b;
      A(nnz_pos(1), :) = A(k,:);
      A(k,:) = temp;
      b_swap(k) = nnz_pos(1);
      fprintf("Row %d swapped with row %d\n", k, nnz_pos(1));
      %}
    end

  end
end
