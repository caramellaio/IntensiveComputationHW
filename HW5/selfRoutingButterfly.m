function [P, S] = selfRoutingButterfly(vals_start, vals_dest)
  N = length(vals_start)
  n = log2(N)
  P = zeros(N, 2 * n);
  S = zeros(N / 2, n);

  % unset = -1
  S = S -1;
  P = P -1;

  max_n = n;

  for i = 1:N
    start = vals_start(i);
    bin_dest = decToBin(vals_dest(i), n);

    actual_y = i;
    assert(actual_y <= N);
    for j = 1:max_n
      assert(actual_y > 0 && actual_y <= N);
      P(actual_y, (2 * j) -1) = start


      % If I am up and I want to go down (1) 
      % or if I am down and I want to go up (2)
      if (bin_dest(j) && mod(actual_y, 2) == 1 || ~bin_dest(j) && mod(actual_y, 2) == 0)
        flip = 1;
      else
        flip = 0;
      end
      if -1 == S(int32(actual_y / 2), j)
        S(int32(actual_y/ 2), j) = flip;
      elseif flip ~= S(int32(actual_y / 2), j)
        % CONFLICT!!!
        S(int32(actual_y / 2), j) = NaN;
        % update new n and exit
        max_n = j - 1;
      else
        assert(S(int32(actual_y / 2), j) == flip);
      end

      aaa = actual_y;
      if S(int32(actual_y / 2), j) == 1
        % cross: change y value
        if (mod(actual_y, 2)) == 0
          actual_y = actual_y - 1;
        else
          actual_y = actual_y + 1;
        end
      end

      assert(actual_y <= N);
      P(actual_y, 2*j) = start;
      if j < max_n
        actual_y = get_next_pos(S, j, actual_y);
      end
    end

  end
end

function bin = decToBin(D, bits)
  arr = [];

  val = double(D);

  while val >= 1
    arr = horzcat(arr, mod(val, 2));
    val = floor(val / 2);
  end

  bin = flip(arr);

  while length(bin) < bits
    bin = horzcat([0], bin);
  end
end

function p = get_next_pos(S, j, actual_y)
  n = size(S, 2);

  assert(j < n);

  start_up = mod(actual_y, 2) == 1;

  goes_up = start_up;

  block_size = 2 ^ (n - j);
  block_pos = mod(int32(actual_y / 2), block_size);

  if block_pos == 0
    block_pos = block_size;
  end

  is_block_upper_part = block_pos <= block_size /2;

  if goes_up == is_block_upper_part
    p = actual_y;
  else
    if is_block_upper_part
      p = actual_y + block_size - 1;
    else
      p = actual_y - block_size + 1;
    end
  end
  
  actual_y
  p
  assert(p > 0 && p <= 2 * size(S, 1));
end
