function X = RBToRadix10(AN, AR, max_v)
  n = length(AN);

  assert(n == length(AR));

  X = zeros(1, n, 'int32');

  carry = 0;
  for i = n:-1:1
    X(i) = AN(i) + AR(i) + carry;

    if (X(i) >= 2)
      carry = 1;
    else
      carry = 0;
    end

    X(i) = mod(X(i), 2);
  end

  if carry == 1
    fprintf("Error: overflow");
    X = NaN;
  end
end
