function funs = CSR
  funs.toCompact=@toCompactCSR;
  funs.extractCol=@extractColCSR;
  funs.extractRow=@extractRowCSR;
  funs.mul=@mulCSR;
  funs.toFull=@toFullCSR;
  funs.extrRowComp=@extractRowCSRCompact;
  funs.extrColComp=@extractColCSRCompact;
end

function c = toCompactCSR(M)
  % CSR is CSC(M')

  c_tmp = CSC().toCompact(M');

  c = struct('A', c_tmp.A, 'I', c_tmp.J, 'J', c_tmp.I);
end

function col = extractColCSR(C, j)
  % this works with the assumption of square matrix
  n = length(C.I) -1;
  col = zeros(n, 1);

  [i_idxs, col_val] = extractColCSRCompact(C, j);

  col(i_idxs) = col_val;
end


function row = extractRowCSR(C, i)
  % this works with the assumption of square matrix
  n = length(C.I) -1;
  row = zeros(1, n);

  [col_idx, row_val] = extractRowCSRCompact(C, i);

  row(col_idx) = row_val;
end

% PRIVATE FUNCTION
function [r_idx, col_val] = extractColCSRCompact(C, j)
  [r_idx, col_val] = CSC().extrRowComp(toCSCTrans(C), j);
end

% PRIVATE FUNCTION
function [col_idx, row_val] = extractRowCSRCompact(C, i)
  [col_idx, row_val] = CSC().extrColComp(toCSCTrans(C), i);
end

function c = mulCSR(A, B)
  n = length(A.I) -1;

  % size of A and J are unknown
  C_A = [];
  C_J = [];
  C_I = zeros(n+1, 1, 'int32');

  [a_idxs, row_vals] = arrayfun(@(i) extractRowCSRCompact(A, i), 1:n, 'UniformOutput', false);
  [b_idxs, col_vals] = arrayfun(@(j) extractColCSRCompact(B, j), 1:n, 'UniformOutput', false);

  next = 1;
  for i = 1:n
    a_row_col = a_idxs{i};
    a_row_val = row_vals{i};

    C_I(i) = next;

    for j = 1:n
      b_col_row = b_idxs{j};
      b_col_val = col_vals{j};

      [elems, b_col_idxs, a_row_idxs] = intersect(b_col_row, a_row_col);

      if length(elems) > 0
        r = dot(b_col_val(b_col_idxs), a_row_val(a_row_idxs));
        C_A = horzcat(C_A, r);
        C_J = horzcat(C_J, j);
        next = next +1;
      end
    end
  end

  C_I(n+1) = next;
  c = struct('A', C_A, 'I', C_I, 'J', C_J);
end

function M = toFullCSR(c)
  n = length(c.I) -1;

  M = zeros(n);

  for i = 1:n
    M(i,:) = extractRowCSR(c, i);
  end
end

function csc = toCSCTrans(c)
  csc = struct('A', c.A, 'I', c.J, 'J', c.I);
end
