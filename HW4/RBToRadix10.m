function decVal = RBToRadix10(AN, AR)
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
    error("Error: overflow!\n");
    X = NaN;
    decVal = NaN;
  else
    decVal = binToDec(X);
  end
end

function result = binToDec(X)
  n = length(X);

  assert(n > 0);

  result = sum(arrayfun(@(i, j) j * 2^(i-1), n:-1:1, X));
end
