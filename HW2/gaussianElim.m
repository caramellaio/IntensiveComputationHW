function x = gaussianElim(A, b, getPivoting, show_spy, compute_graph, video_file)
  n = size(A, 2);

  if show_spy
    spy(A);
    drawnow;
    frames(1) = getframe(gcf);
  end

  step = 1;
  sp_vector = [];

  count = prod(size(A));

  % this vector keeps track of the swapping operations on b
  x_swap = zeros(1, n);

  for k = 1:n
    to_swap = getPivoting(A, b, k);

    swap([k, k], to_swap);
    % if the value is zero even with pivoting skip
    if A(k, k) == 0
      continue
    end
    if compute_graph
      sp_vec(step) = (count - nnz(A)) / count;
    end

    for i = k+1:n

      mul_i_k = A(i, k) / A(k, k);

      A(i, k:n) = A(i, k:n) - (mul_i_k * A(k, k:n));

      b(i) = b(i) - mul_i_k * b(k);

      if compute_graph
        sp_vec(step) = (count - nnz(A)) / count;
      end

      step = step + 1;

      if show_spy
        spy(A);
        if strlength(video_file) > 0
          drawnow;
          frames(step) = getframe(gcf);
        end
      end

    end
  end

  if compute_graph
    plot(1:length(sp_vec), sp_vec, 'DisplayName', 'Matrix Sparsity');
    xlabel("Iteration step");
    ylabel("Sparsity");
    legend;
  end
  x = backwardSub(A, b);
  adjust_x();
  if show_spy
    if strlength(video_file) > 0
      v = VideoWriter(video_file);
      open(v);
      writeVideo(v, frames);
      close(v);
    end
  end

  function swap(k0, k1)
    assert(sum(k1 >= k0) == 2);
    if ~isequal(k0, k1)
      % swap rows
      if compute_graph
        fprintf("Swapping %d %d with %d %d\n", k0(1), k0(2), k1(1), k1(2));
      end
      if k0(1) ~= k1(1)
        temp = A(k0(1),:);
        A(k0(1),:) = A(k1(1),:);
        A(k1(1),:) = temp;

        temp = b(k0(1));
        b(k0(1)) = b(k1(1));
        b(k1(1)) = temp;
      end

      % swap column
      if k0(2) ~= k1(2)
        temp = A(:,k0(2));
        A(:, k0(2)) = A(:, k1(2));
        A(:, k1(2)) = temp;

        % we need to swap the rows in the end
        x_swap(k0(2)) = k1(2);
      end
    end
  end

  function adjust_x
    % adjust result order
    for i = 1:length(x_swap)
      if 0 ~= x_swap(i)
        temp = x(i);
        x(i) = x(x_swap(i));
        x(x_swap(i)) = temp;
      end
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
