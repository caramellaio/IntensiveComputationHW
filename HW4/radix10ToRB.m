function [N,R] = radix10ToRB(D, n)
  N = decToBin(D, n);
  R = zeros(1, length(N), 'int32');
end

function bin = decToBin(D, n)
  arr = zeros(1, n);

  val = double(D);

  for i=n:-1:1
    if val >= 1
      arr(i) = mod(val, 2);
      val = floor(val / 2);
    else
      break;
    end
  end

  if val > 0
    fprintf("Error calling dec2bin: overflow!!\n");
  end

  bin = int32(arr);
end
