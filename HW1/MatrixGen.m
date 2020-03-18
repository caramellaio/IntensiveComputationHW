function func = MatrixGen
  func.genRandomMatrix=@genRandomMatrix;
  func.genBandedRandomMatrix=@genBandedRandomMatrix;
end

function M = genRandomMatrix(n, sparsity, ubound)
  M = full(sprand(n,n, 1 - sparsity) * ubound);
end

function M = genBandedRandomMatrix(n, sparsity, ubound)
end
