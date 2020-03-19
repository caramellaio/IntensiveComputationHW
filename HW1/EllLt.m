function funs = EllLt
  funs.toCompact=@toCompactEllLt;
  funs.extractCol=@extractColEllLt;
  funs.extractRow=@extractRowEllLt;
  funs.mul=@mulEllLt;
  funs.toFull=@toFullEllLt;
end

function c = toCompactEllLt(M, nz_m)
  M_T = M';

  n = size(M,1);

  % we swap I and J since M_T is transposed
  [J, I, A] = find(M_T)

  % find uses double precision even if it is not required
  J = int32(J);

  COEF = zeros(n, nz_m);
  JCOEF = zeros(n, nz_m, 'int32');
  for i = 1:n
    % get all rows indexes
    idxs = find(I == i)
    COEF(i, 1:length(idxs)) = A(idxs);
    JCOEF(i, 1:length(idxs)) = J(idxs);
  end
  c = struct('COEF', COEF, 'JCOEF', JCOEF);
end

function col = extractColEllLt(C, j)
  n = size(C.COEF, 1);
  col = zeros(n, 1);

  c_vals = C.COEF(find(C.JCOEF == j));
  % TODO: find a way to compute value just once
  [c_rows, foo, bar] = find(C.JCOEF == j);

  col(c_rows) = c_vals;
end

function row = extractRowEllLt(C, i)
  n = size(C.COEF, 1)
  row = zeros(1, n);

  % get non zero elements of row i
  nnz_i = find(C.COEF(i,:))
  % get non zero elements indexes of row i
  nnz_col_i = C.JCOEF(i,1: length(nnz_i));
  row(nnz_col_i) = C.COEF(i, nnz_i);

  % store row i elems in correct col position
end

function C = mulEllLt(A, B)
  n = size(A.COEF, 1);
  nz_m = size(A.COEF, 2);

  C_COEF = zeros(n, nz_m);
  C_JCOEF = zeros(n, nz_m, 'int32');

  for i = 1:n
    nnz_i = nnz(A.COEF(i,:));
    a_row_cols = A.JCOEF(i, 1:nnz_i);
    a_row_vals = A.COEF(i, 1:nnz_i);

    % actual index inside ith row
    idx = 1;
    for j = 1:n
      b_col_vals = B.COEF(find(B.JCOEF == j));
      % TODO: find a way to compute value just once
      [b_col_rows, foo, bar] = find(B.JCOEF == j);

      [elems, b_idxs, a_idxs] = intersect(b_col_rows, a_row_cols);
      if length(elems) > 0
        C_COEF(i, idx) = dot(a_row_vals(a_idxs), b_col_vals(b_idxs));
        C_JCOEF(i, idx) = j;

        idx = idx + 1;
      end

    end
  end
  C = struct('COEF', C_COEF, 'JCOEF', C_JCOEF);
end

function M = toFullEllLt(C)
  n = size(C.COEF, 1)
  M = zeros(n);
  for i = 1:n
    M(i,:) = extractRowEllLt(C, i);
  end
end
