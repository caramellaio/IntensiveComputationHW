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

  if j <= n
    col = zeros(n,1);

    [r_idx, col_vals] = extractColMSRCompact(C, n, j);

    col(r_idx) = col_vals;
  else
    col = NaN;
  end
end

% PRIVATE FUNCTION
function [r_idx, col_val] = extractColMSRCompact(C, n, j)
  assert(j <= n);

  nnz_col_V = n + 1 + find(C.B(n + 2:length(C.B)) == j);
  col_range = vertcat(nnz_col_V, j);

  col_val = C.V(col_range);

  r_idx = zeros(length(col_val), 1, 'int32');

  % diag entry
  r_idx(length(col_val)) = j;

  last_row = 1;

  % populate the index vector
  for i = 1:length(nnz_col_V)
    lt_array = find(C.B(last_row:n) <= nnz_col_V(i));
    % get the latest row which is <= to col index
    last_row = lt_array(length(lt_array));
    assert(length(lt_array) > 0);
    r_idx(i) = last_row;
  end
end

function row = extractRowMSR(C, i)
  % at the 'n + 1'th position the end of the array + 1 is stored
  n = find(C.B == length(C.V)+1) - 1;
  if i <= n
    row = zeros(1, n);
    [pos, vals] = extractRowMSRCompact(C, n, i)
    row(pos) = vals;
  else
    row = NaN;
  end
end

% PRIVATE FUNCTION
function [c_idx, row_val] = extractRowMSRCompact(C, n, i)
  % extr row from diag and C.B
  assert(i <= n);
  row_range = vertcat(C.B(i) : C.B(i+1)-1, i)
  row_val = C.V(row_range);

  % get col id using C.B + append diag index
  c_idx = vertcat(C.B(row_range(1:length(row_range)-1)), i);
end


function c = mulMSR(A, B)
  n = find(A.B == length(A.V)+1) - 1;
  n2 = find(B.B == length(B.V)+1) - 1;

  assert(n == n2);

  for i = 1:n
    for j = 1:n
    end
  end
  %a_rows_idx = 
  c = struct('B', C_B, 'V', C_V);
end

function M = toFullMSR(C)
  n = find(C.B == length(C.V)+1) -1;

  M = zeros(n);

  for i = 1:n
    M(i,:) = extractRowMSR(C, i);
  end
end
