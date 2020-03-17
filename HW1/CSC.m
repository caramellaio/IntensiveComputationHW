function funs = CSC
  funs.toCompact=@toCompactCSC;
  funs.extractCol=@extractColCSC;
  funs.extractRow=@extractRowCSC;
  funs.mul=@mulCSC;
  funs.toFull=@toFullCSC;
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

  range = C.J(j):C.J(j+1)-1;
  col_nz = C.A(range);
  i_idxs = C.I(range);

  % assign non zero elements
  for i = 1:length(i_idxs)
    col(i_idxs(i)) = col_nz(i);
  end
end

function row = extractRowCSC(M, i)
end

function b = mulCSC(A, B)
end

function M = toFullCSC(c)
end
