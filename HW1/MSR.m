function funs = MSR
  funs.toCompact=@toCompactMSR;
  funs.extractCol=@extractColMSR;
  funs.extractRow=@extractRowMSR;
  funs.mul=@mulMSR;
  funs.toFull=@toFullMSR;
end

function c = toCompactMSR(M)
end

function col = extractColMSR(C, j)
end

function row = extractRowMSR(C, i)
end

function c = mulMSR(A, B)
end

function M = toFullMSR(c)
end
