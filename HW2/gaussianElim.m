function x = gaussianElim(A, b, show_spy, compute_graph)
  n = size(A, 2);

  spy(A);

  step = 1;
  sp_vector = [];

  count = prod(size(A));

  for k = 1:n
    if A(k, k) == 0
      % find the next non zero element of the kth column
      nnz_pos = find(A(k+1:end,k)) + k

      fprintf("found null diagonal element at row %d\n", k);
      if length(nnz_pos) == 0
        % this matrix cannot be triangular
        continue
      else
        % apply zero pivoting
        temp = A(nnz_pos(1), :);
        temp_b = b(nnz_pos(1));
        b(nnz_pos(1)) = b(k);
        b(k) = temp_b;
        A(nnz_pos(1), :) = A(k,:);
        A(k,:) = temp;
        b_swap(k) = nnz_pos(1);
        fprintf("row %d swapped with row %d\n", k, nnz_pos(1));
        if show_spy
          pause(5);
          spy(A);
        end

        if compute_graph
          sp_vec(step) = (count - nnz(A)) / count;
        end
      end
    end
    for i = k+1:n

      mul_i_k = A(i, k) / A(k, k);

      for j = k:n
        A(i, j) = A(i, j) - (mul_i_k * A(k, j));
      end

      b(i) = b(i) - mul_i_k * b(k);
      if show_spy
        pause(1.3);
        spy(A)
      end

      if compute_graph
        sp_vec(step) = (count - nnz(A)) / count;
      end
      step = step + 1;
    end
  end

  pause(.9);
  if compute_graph
    plot(1:length(sp_vec), sp_vec, 'DisplayName', 'Matrix Sparsity');
    xlabel("Iteration step");
    ylabel("Sparsity");
    legend;
  end
  x = backwardSub(A, b);

  A
  % adjust result order
  for i = 1:length(b_swap)
    if 0 ~= b_swap(i)
      temp = x(i);
      x(i) = x(b_swap(i));
      x(b_swap(i)) = temp;
    end
  end
end

function x = backwardSub(A, b)
  n = size(A, 2);
  x = zeros(n, 1);

  x(n) = b(n) / A(n, n);

  for i = n-1:-1:1
    x(i) = (1 / A(i, i)) * (b(i) - dot(A(i, i+1:end), x(i+1:end)));
  end
end
