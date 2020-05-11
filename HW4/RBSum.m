function [N, R] = RBSum(AN, AR, BN, BR)

  A = joinRBS(AN, AR);
  B = joinRBS(BN, BR);


  if length(A) ~= length(B)
    [A, B] = fix_sizes(A, B);
  end

  n = max(length(A), length(B));

  [zer_vec, sum_vec] = apply_sum(A, B, n)
  [zer_vec2, sum_vec2] = apply_sum(zer_vec, sum_vec, n);

  [N, R] = compactToNR(sum_vec2);
end

function A = joinRBS(AN, AR)
  A = zeros(1, length(AN) + length(AR), 'int32');

  assert(length(A) == 2 * length(AN));

  for i = 1:length(AN)
    A(2*i - 1) = AN(i);
    A(2*i) = AR(i);
  end
end

function [A_fixed, B_fixed] = fix_sizes(A, B)
  A_fixed = A;
  B_fixed = B;

  if (length(A) > length(B))
    diff = length(A) - length(B);

    B_fixed = horzcat(zeros(1, diff), B);
  else
    assert(length(B) > length(A));

    diff = length(B) - length(A);
    A_fixed = horzcat(zeros(1, diff), A);
  end
end

function [N, R] = compactToNR(A)
  n = length(A);
  assert(mod(n, 2) == 0);
  N = zeros(1, n / 2, 'int32');
  R = zeros(1, n / 2, 'int32');

  N = A(1:2:n-1);
  R = A(2:2:n);

end

function [zer_vec, sum_vec] = apply_sum(A, B, n)
  % assume that n is even
  assert(mod(n,2) == 0);

  zer_vec = zeros(1, n);
  sum_vec = zeros(1, n);
  for i = 1:2:n-1
    [zer_val, sum_val] = comp_table(A(i), A(i+1), B(i), B(i+1));
    zer_vec(i:i+1) = zer_val;

    if i == 1
      % overflow not handled!!
      sum_vec(1) = sum_val(2);
    else
      sum_vec(i-1:i) = sum_val;
    end
  end

end

function [zer_val, sum_val] = comp_table(b11,b12,b21,b22)
  if b11 && b12
    % case 11

    if b21 && b22
      zer_val = [1 0];
      sum_val = [1 1];
    elseif b21
      zer_val = [1 0];
      sum_val = [1 0];
    elseif b22
      zer_val = [1 0];
      sum_val = [1 0];
    else
      zer_val = [1 0];
      sum_val = [0 1];
    end
  elseif b11
    % case 10

    if b21 && b22
      zer_val = [0 0];
      sum_val = [1 1];
    elseif b21
      zer_val = [0 0];
      sum_val = [1 0];
    elseif b22
      zer_val = [0 0];
      sum_val = [1 0];
    else
      zer_val = [0 0];
      sum_val = [0 1];
    end
  elseif b12
    % case 01

    if b21 && b22
      zer_val = [1 0];
      sum_val = [1 0];
    elseif b21
      zer_val = [1 0];
      sum_val = [0 1];
    elseif b22
      zer_val = [1 0];
      sum_val = [0 1];
    else
      zer_val = [1 0];
      sum_val = [0 0];
    end
  else
    % case 00

    if b21 && b22
      zer_val = [0 0];
      sum_val = [1 0];
    elseif b21
      zer_val = [0 0];
      sum_val = [0 1];
    elseif b22
      zer_val = [0 0];
      sum_val = [0 1];
    else
      zer_val = [0 0];
      sum_val = [0 0];
    end
  end
end
