function [P, S] = selfRoutingButterfly(vals_start, vals_dest)
  N = length(vals_start);
  n = log2(N);
  P = zeros(N, 2 * n);
  S = zeros(N / 2, n);

  % unset = -1
  S = S -1;
  P = P + NaN;

  max_n = n;

  % assign initial values
  P(:,1) = 1:N;

  % gen bin vals

  bin_dest = zeros(N, n) - 1;

  for i =1:N
    bin = decToBin(vals_dest(i), n);
    bin_dest(i, :) = bin;
  end

  for i = 1:n
    % case there was a conflict and we surpass the conflict level! 
    if i > n
      break;
    end

    % nominal internal iteration
    for j = 1:N
      % 2 * i - 1 because we consider the entrance in that level:
      % - 2 * i - 1 = entrance
      % - 2 * i     = exit
      actual_val = P(j, 2 * i - 1)

      bit = bin_dest(actual_val, i)
      % choose if we need to apply flip
      % flip if I am up and I want to go down and viceversa
      bit
      if bit && mod(j, 2) == 1 || ~bit && mod(j, 2) == 0
        flip = 1;
      else
        flip = 0;
      end

      fprintf("Flip = %d\n", flip);

      % Assign S

      if -1 == S(int32(j / 2), i)
        % case where the value is not assigned yet: assign it now.
        S(int32(j / 2), i) = flip;
      elseif flip == S(int32(j / 2), i)
        % nothing to do, value is OK :)
      else
        % CONFLICT
        S(int32(j / 2), i) = NaN;
        fprintf("Conflict at: %d %d", i, j);
        S
        % let the inner cycle continue the stop on this level for the remaining values...
        n = i
        continue
      end

      % assign exit P
      % I use actual_y / 2 to consider the block y in the current position
      % (divide 2 because actual_y refers to one of the 2 input per matrix

      % assign new y index
      new_j = j;

      % if we find a cross S then we have to update the index
      if S(int32(j / 2), i) == 1
        % cross: change y value
        if (mod(j, 2)) == 0
          new_j = j - 1;
        else
          new_j = j + 1;
        end
      end

      % assign actual value to the exit part
      P(new_j, 2 * i) = actual_val;

      % if we are at the last level we do not have to calculate a new j!
      if i ~= n
        % get the new y position for the entrance
        new_j
        %assert(i <= n);

        new_j = get_next_pos(S, i, new_j)

        % set value for the new entrance...

        P(new_j, 2 * (i + 1) - 1) = actual_val;
      end
    end
  end

  % replace index representation with effective start values...
  for i=1:N
    idxs = find(P == i);

    P(idxs) = vals_start(i);
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
  
  assert(p > 0 && p <= 2 * size(S, 1));
end
