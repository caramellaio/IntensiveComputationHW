function x = gaussianElim(A, b)
  n = size(A, 2);

  for k = 1:n
    for i = k+1:n
      mul_i_k = A(i, k) / A(k, k);
      for j = k:n
        A(i, j) = A(i, j) - (mul_i_k * A(k, j));
      end

      b(i) = b(i) - mul_i_k * b(k);
    end
  end
  x = backwardSub(A, b);
end

function x = backwardSub(A, b)
  n = size(A, 2);
  x = zeros(n, 1);

  x(n) = b(n) / A(n, n);

  for i = n-1:-1:1
    x(i) = (1 / A(i, i)) * (b(i) - dot(A(i, i+1:end), x(i+1:end)));
  end
end
