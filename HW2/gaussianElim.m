function x = gaussianElim(A, b, applyPivoting, show_spy, compute_graph)
  n = size(A, 2);

  spy(A);

  step = 1;
  sp_vector = [];

  count = prod(size(A));

  % this vector keeps track of the swapping operations on b
  b_swap = zeros(1, n);

  for k = 1:n
    [A, b] = applyPivoting(A, b, k, b_swap);

    % if the value is zero even with pivoting skip
    if A(k, k) == 0
      continue
    end
    if compute_graph
      sp_vec(step) = (count - nnz(A)) / count;
    end

    if show_spy
      pause(0.1);
      spy(A);
    end
    for i = k+1:n

      mul_i_k = A(i, k) / A(k, k);

      for j = k:n
        A(i, j) = A(i, j) - (mul_i_k * A(k, j));
      end

      b(i) = b(i) - mul_i_k * b(k);
      if show_spy
        pause(0.1);
        spy(A);
      end

      if compute_graph
        sp_vec(step) = (count - nnz(A)) / count;
      end
      step = step + 1;
    end
  end

  if compute_graph
    plot(1:length(sp_vec), sp_vec, 'DisplayName', 'Matrix Sparsity');
    xlabel("Iteration step");
    ylabel("Sparsity");
    legend;
  end
  x = backwardSub(A, b);

  %{ adjust result order
  for i = 1:length(b_swap)
    if 0 ~= b_swap(i)
      temp = x(i);
      x(i) = x(b_swap(i));
      x(b_swap(i)) = temp;
    end
  end%}
end

function x = backwardSub(A, b)
  n = size(A, 2);
  x = zeros(n, 1);

  x(n) = b(n) / A(n, n);

  for i = n-1:-1:1
    x(i) = (1 / A(i, i)) * (b(i) - dot(A(i, i+1:end), x(i+1:end)));
  end
end
