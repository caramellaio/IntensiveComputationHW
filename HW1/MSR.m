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

  [J, I_tmp, A] = find(M');

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
  n = getN(C);

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
  n = getN(C);
  if i <= n
    row = zeros(1, n);
    [pos, vals] = extractRowMSRCompact(C, n, i);
    row(pos) = vals;
  else
    row = NaN;
  end
end

% PRIVATE FUNCTION
function [c_idx, row_val] = extractRowMSRCompact(C, n, i)
  % extr row from diag and C.B
  assert(i <= n);
  row_range = horzcat(C.B(i) : C.B(i+1)-1, i);
  row_val = C.V(row_range);

  % get col id using C.B + append diag index
  c_idx = vertcat(C.B(row_range(1:length(row_range)-1)), i);
end


function c = mulMSR(A, B)
  n = getN(C);
  n2 = find(B.B == length(B.V)+1) - 1;

  assert(n == n2);

  [a_idxs, row_vals] = arrayfun(@(i) extractRowMSRCompact(A, n, i), 1:n, 'UniformOutput', false);
  [b_idxs, col_vals] = arrayfun(@(j) extractColMSRCompact(B, n, j), 1:n, 'UniformOutput', false);

  next = n + 2;

  % min size of the fields
  C_B = zeros(n + 1, 1, 'int32');
  C_V = zeros(n + 1, 1);

  for i = 1:n
    a_row_col = a_idxs{i};
    a_row_val = row_vals{i};
    for j = 1:n
      b_col_row = b_idxs{j};
      b_col_val = col_vals{j};

      [elems, b_col_idxs, a_row_idxs] = intersect(b_col_row, a_row_col);

      if length(elems) > 0
        r = dot(b_col_val(b_col_idxs), a_row_val(a_row_idxs));
      else
        r = 0;
      end

      if i == j
        C_V(i) = r;
      elseif 0 ~= r
        % case new row
        if C_B(i) == 0%j == 1
          % store new row information
          C_B(i) = next;
        end
        C_V(next) = r;
        C_B(next) = j;
        next = next + 1;
      end
    end

    if C_B(i) == 0
      % case of empty row
      C_B(i) = next;
    end
  end

  % set END delimiter for rows
  C_B(n+1) = length(C_V) + 1;
  C_V(n+1) = NaN;

  c = struct('B', C_B, 'V', C_V);
end

function M = toFullMSR(C)
  n = getN(C);

  M = zeros(n);

  for i = 1:n
    M(i,:) = extractRowMSR(C, i);
  end
end

function n = getN(C)
  n_arr = find(C.B == length(C.V)+1) -1;

  n = n_arr(end)
end
