function funs = MSR
  funs.toCompact=@toCompactMSR;
  funs.extractCol=@extractColMSR;
  funs.extractRow=@extractRowMSR;
  funs.mul=@mulMSR;
  funs.toFull=@toFullMSR;
end

function c = toCompactMSR(M)
  % assume square matrix
  n = size(M, 1);
  d =diag(M);

  % remove the diagonal
  M(logical(eye(size(M)))) = 0;

  [J, I_tmp, A] = find(M')

  V = zeros(n + 1 + length(A), 1);
  B = zeros(n + 1 + length(A), 1, 'int32');
  V(1:n) = d;
  % just to have a graphic division
  V(n+1) = NaN;
  V(n+2:n+2+length(A)-1) = A;
  B(n+2:n+2+length(A)-1) = J;
  % get count of nnz elems in each column
  nnz_rows = sum(M'~=0, 1);
  B(1:n+1) = int32(cumsum(horzcat([n+2], nnz_rows)));
  c = struct('B', B, 'V', V);
end

function col = extractColMSR(C, j)
  n = find(C.B == length(C.V)+1) - 1;
  col = zeros(n,1);

  col(j) = C.V(j);

  nnz_col_V = n + 1 + find(C.B(n + 2:length(C.B)) == j);
  col_vals = C.V(nnz_col_V);

  last_row = 1;

  for i = 1:length(nnz_col_V)
    lt_array = find(C.B(last_row:n) <= nnz_col_V(i));
    % get the latest row which is <= to col index
    last_row = lt_array(length(lt_array));
    assert(length(lt_array) > 0);
    col(last_row) = col_vals(i);
  end
end

function row = extractRowMSR(C, i)
  % at the 'n + 1'th position the end of the array + 1 is stored
  n = find(C.B == length(C.V)+1) - 1;
  if i <= n
    row = zeros(1, n);

    % get diag element
    row(i) = C.V(i);
    row_range = C.B(i) : C.B(i+1)-1;
    row(C.B(row_range)) = C.V(row_range);
  else
    row = NaN;
  end
end

function c = mulMSR(A, B)
  
  c = struct('B', C_B, 'V', C_V);
end

function M = toFullMSR(C)
  n = find(C.B == length(C.V)+1) -1;

  M = zeros(n);

  for i = 1:n
    M(i,:) = extractRowMSR(C, i);
  end
end
