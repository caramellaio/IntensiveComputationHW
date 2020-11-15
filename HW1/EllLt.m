

function funs = EllLt
  funs.toCompact=@toCompactEllLt;
  funs.extractCol=@extractColEllLt;
  funs.extractRow=@extractRowEllLt;
  funs.mul=@mulEllLt;
  funs.toFull=@toFullEllLt;
  funs.extrColComp=@foo;
  funs.extrRowComp=@foo;
end

function a = foo()
  a = NaN;
end

function c = toCompactEllLt(M)
  M_T = M';

  n = size(M,1);
  nz_m = int16(n / 5);

  % we swap I and J since M_T is transposed
  [J, I, A] = find(M_T);

  % find uses double precision even if it is not required
  J = int32(J);

  COEF = zeros(n, nz_m);
  JCOEF = zeros(n, nz_m, 'int32');
  for i = 1:n
    % get all rows indexes
    idxs = find(I == i);
    COEF(i, 1:length(idxs)) = A(idxs);
    JCOEF(i, 1:length(idxs)) = J(idxs);
  end
  c = struct('COEF', COEF, 'JCOEF', JCOEF);
end

function col = extractColEllLt(C, j)
  n = size(C.COEF, 1);
  col = zeros(n, 1);

  [c_rows, c_vals] = extractColEllLtCompact(C, j);
  col(c_rows) = c_vals;
end

function [r_idx, col_val] = extractColEllLtCompact(C, j)
  col_val = C.COEF(find(C.JCOEF == j));
  [r_idx, foo, bar] = find(C.JCOEF == j);
end

function row = extractRowEllLt(C, i)
  n = size(C.COEF, 1);
  row = zeros(1, n);

  [col_idx, row_val] = extractRowEllLtCompact(C, i);
  row(col_idx) = row_val;

  % store row i elems in correct col position
end

function [col_idx, row_val] = extractRowEllLtCompact(C, i)
  % get non zero elements of row i
  nnz_i = find(C.COEF(i,:));
  % get non zero elements indexes of row i
  col_idx = C.JCOEF(i,1: length(nnz_i));
  row_val = C.COEF(i, nnz_i);
end

function C = mulEllLt(A, B)
  n = size(A.COEF, 1);
  nz_m = size(A.COEF, 2);

  C_COEF = zeros(n, nz_m);
  C_JCOEF = zeros(n, nz_m, 'int32');

  [a_idxs, row_vals] = arrayfun(@(i) extractRowEllLtCompact(A, i), 1:n, 'UniformOutput', false);
  [b_idxs, col_vals] = arrayfun(@(j) extractColEllLtCompact(B, j), 1:n, 'UniformOutput', false);

  for i = 1:n
    a_row_cols = a_idxs{i};
    a_row_vals = row_vals{i};

    % actual index inside ith row
    idx = 1;
    for j = 1:n
      b_col_rows = b_idxs{j};
      b_col_vals = col_vals{j};

      [elems, b_idxs_int, a_idxs_int] = intersect(b_col_rows, a_row_cols);
      if length(elems) > 0
        C_COEF(i, idx) = dot(a_row_vals(a_idxs_int), b_col_vals(b_idxs_int));
        C_JCOEF(i, idx) = j;

        idx = idx + 1;
      end

    end
  end
  C = struct('COEF', C_COEF, 'JCOEF', C_JCOEF);
end

function M = toFullEllLt(C)
  n = size(C.COEF, 1);
  M = zeros(n);
  for i = 1:n
    M(i,:) = extractRowEllLt(C, i);
  end
end
