
function funs = BSR
  funs.toCompact=@toCompactBSR;
  funs.extractCol=@extractColBSR;
  funs.extractRow=@extractRowBSR;
  funs.mul=@mulBSR;
  funs.toFull=@toFullBSR;
end

function c = toCompactBSR(M, nz_m)
end

function col = extractColBSR(C, j)
end

function row = extractRowBSR(C, i)
end

function C = mulBSR(A, B)
end

function M = toFullBSR(C)
end
