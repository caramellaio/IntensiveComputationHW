genRandomMatrix(10, 0.95, 100)

function M = genRandomMatrix(n, sparsity, ubound)
  %{M = zeros(n);
  for i = 1:n
    for j = 1:n
      if rand(1) > sparsity
        M(i, j) = rand(1,1) * ubound;
      end
    end
  end%}
  M = full(sprand(n,n, 1 - sparsity));
end
