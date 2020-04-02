function func = MatrixGen
  func.genRandomMatrix=@genRandomMatrix;
  func.genDiagDomRandomMatrix=@genDiagDomMatrix;
end

function M = genRandomMatrix(n, sparsity, ubound)
  M = full(sprand(n,n, 1 - sparsity) * ubound);
end

function M = genDiagDomMatrix(n, sparsity, ubound)
  M = genRandomMatrix(n, sparsity, ubound);

  d = sum(M') * 2 + 1;

  M = M + diag(d);
end
