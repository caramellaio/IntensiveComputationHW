function M = genRandomGraph(n_V, avg_deg)
  M = zeros(n_V);

  for i = 1:n_V
    for j = i+1:n_V
      M(i, j) = rand(1) <= (avg_deg / n_V) || i == j;
      M(j, i) = M(i, j);
    end
  end
end
