
function funs = BSR
  funs.toCompact=@toCompactBSR;
  funs.extractCol=@extractColBSR;
  funs.extractRow=@extractRowBSR;
  funs.mul=@mulBSR;
  funs.toFull=@toFullBSR;
end

function c = toCompactBSR(M, block_size)
  n = size(M, 1);

  % assume square matrix
  assert(n == size(M, 2));

  % block size must be compatible
  assert(mod(n, block_size) == 0);

  % blocks per row
  bpr = n / block_size;

  PB = zeros(1, bpr, 'int32');
  PE = zeros(1, bpr, 'int32');
  V = [];

  Cols = [];

  next = 1;
  % other element size is not known a priori
  for i = 1:bpr
    b_range_row = (i-1)*block_size +1:i*block_size;
    PB(i) = next;
    for j = 1:bpr
      b_range_col = block_size * ((j-1)*block_size+1:j*block_size);
      block = M(b_range_row, b_range_col);

      if nnz(block) > 0
        V = horzcat(V, reshape(block, [1, block_size*block_size]));
        Cols = horzcat(Cols, j);
        next = next+1;
      end
    end
    PE(i) = next;
  end
  c = struct('V', V,'Cols', int32(Cols), 'PB', PB, 'PE', PE);
end

function col = extractColBSR(C, j)
  b_size = getBlockSize(C)
  bl_j = int32(j / b_size) + 1;

end

% PRIVATE FUNCTION
function [row_bl_idxs, vals] = extractColBlcs(C, bl_j)
  % get indexes of blocks related to column j
  col_idxs = find(C.Cols == bl_j);
  % map indexes to real values range
  col_ranges = arrayfun(@(j) (j-1) * b_size:j*b_size, col_idxs);
  col_vals_vec = C.V(col_ranges);
  col_bl_j = reshape(col_vals_vec, [b_size, length(col_idxs)*b_size]);
  row_bl_idxs = 
end
function row = extractRowBSR(C, i)
end

function blockSize = getBlockSize(C)
  blockSize = length(C.V) / length(C.Cols);
end
function C = mulBSR(A, B)
end

function M = toFullBSR(C)
end
