function funs = CSC
  funs.toCompact=@toCompactCSC;
  funs.extractCol=@extractColCSC;
  funs.extractRow=@extractRowCSC;
  funs.mul=@mulCSC;
  funs.toFull=@toFullCSC;
  funs.extrColComp=@extractColCSCCompact;
  funs.extrRowComp=@extractRowCSCCompact;
end

function c = toCompactCSC(M)
  % we might apply a stronger compression on the format

  % assume square matrix
  n = size(M, 1);

  [I_tmp, foo, A] = find(M);

  % find returns double precision matrixes for indexes too
  I = int32(I_tmp);
  J = zeros(n + 1, 1, 'int32');

  % get count of nnz elems in each column
  nnz_J = sum(M~=0, 1)';

  % J is the cululative sum of the nnz elements of each column
  % we need to prepend once since cumsum otherwise each element would point to
  % the end of the column.
  J = int32(cumsum(vertcat(ones(1,1), nnz_J)));
  c = struct('A', A, 'I', I, 'J', J);
end

function col = extractColCSC(C, j)
  % this works with the assumption of square matrix
  n = length(C.J) -1;
  col = zeros(n, 1);

  [i_idxs, col_val] = extractColCSCCompact(C, j);

  col(i_idxs) = col_val;
end

% PRIVATE FUNCTION
function [r_idx, col_val] = extractColCSCCompact(C, j)
  range = C.J(j):C.J(j+1) -1;
  r_idx = C.I(range);
  col_val = C.A(range);
end

function row = extractRowCSC(C, i)
  % this works with the assumption of square matrix
  n = length(C.J) -1;
  row = zeros(1, n);

  [col_idx, row_val] = extractRowCSCCompact(C, i)

  row(col_idx) = row_val;
end

% PRIVATE FUNCTION
function [col_idx, row_val] = extractRowCSCCompact(C, i)
  % TODO: This implementation is not optimal
  idx = 1;

  range = find(C.I == i);
  row_val = C.A(range);
  col_idx = zeros(length(row_val), 1, 'int32');

  last_col = 1;

  for k = 1:length(range)
    lt_array = last_col + find(C.J(last_col:end) <= range(k)) -1;

    last_col = lt_array(end);
    col_idx(k) = last_col;
  end
end

function c = mulCSC(A, B)
  n = length(A.J) -1;

  % size of A and c_I are unknown
  C_A = [];
  C_I = [];
  C_J = zeros(n+1, 1);

  [a_idxs, row_vals] = arrayfun(@(i) extractRowCSCCompact(A, i), 1:n, 'UniformOutput', false);
  [b_idxs, col_vals] = arrayfun(@(j) extractColCSCCompact(B, j), 1:n, 'UniformOutput', false);

  next = 1;
  for j = 1:n
    b_col_row = b_idxs{j};
    b_col_val = col_vals{j};
    for i = 1:n
      a_row_col = a_idxs{i};
      a_row_val = row_vals{i};

      [elems, b_col_idxs, a_row_idxs] = intersect(b_col_row, a_row_col);

      if length(elems) > 0
        r = dot(b_col_val(b_col_idxs), a_row_val(a_row_idxs));
        if C_J(j) == 0
          C_J(j) = next;
        end
        C_A = horzcat(C_A, r);
        C_I = horzcat(C_I, i);
        next = next + 1;
      end
    end

    if (C_J(j) == 0)
      C_J(j) = next;
    end
  end

  C_J(n+1) = length(C_A) + 1;

  c = struct('A', C_A, 'I', C_I, 'J', C_J);
end

function M = toFullCSC(c)
  n = length(c.J) -1;

  M = zeros(n);

  for j = 1:n
    M(:,j) = extractColCSC(c, j);
  end
end
