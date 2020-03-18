function funs = EllLt
  funs.toCompact=@toCompactEllLt;
  %funs.extractCol=@extractColEllLt;
  %funs.extractRow=@extractRowEllLt;
  %funs.mul=@mulEllLt;
  %funs.toFull=@toFullEllLt;
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
