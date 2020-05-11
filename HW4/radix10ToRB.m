function [N,R] = radix10ToRB(D)
  N = decToBin(D);
  R = zeros(1, length(N), 'int32');
end

function bin = decToBin(D)
  arr = [];

  val = double(D);

  while val >= 1
    arr = horzcat(arr, mod(val, 2));
    val = floor(val / 2);
  end

  bin = flip(arr);
end
