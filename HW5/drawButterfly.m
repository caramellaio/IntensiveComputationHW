function p = drawButterfly(n)
  sz = 2^n;

  nodes_per_level = sz / 2;
  X = zeros(1, nodes_per_level * n);
  Y = zeros(1, nodes_per_level * n);

  % setup nodes positions
  for i = 1: length(X)
    X(i) = floor((i - 1)/ nodes_per_level);
    Y(i) = mod(i, nodes_per_level);

    if Y(i) == 0
      Y(i) = nodes_per_level;
    end
  end

  Y = nodes_per_level - Y;

  g = graph(genAdjMatrix(nodes_per_level, n, X, Y));
  p = plot(g, 'XData', X, 'YData', Y);
end

function M = genAdjMatrix(v_per_level, levels, X, Y)
  sz = v_per_level * levels;
  M = zeros(sz);
  UP_CONN = 2;
  DOWN_CONN = 1;

  for i = 1:sz- v_per_level
    pos_x = X(i);
    pos_y = Y(i);

    pos = [pos_x, pos_y];

    block_size = 2 ^ (levels - pos_x - 1);
    is_upper_part = mod(pos_y, block_size) >= block_size / 2;

    if is_upper_part
      M(i, i + v_per_level) = UP_CONN;
      v_per_level + block_size / 2;
      M(i, i + int32(v_per_level + block_size / 2)) = DOWN_CONN;
      M(i + v_per_level, i) = UP_CONN;
      M(i + int32(v_per_level + block_size / 2), i) = DOWN_CONN;
    else
      M(i, i + v_per_level) = DOWN_CONN;
      M(i, i + int32(v_per_level - block_size / 2)) = UP_CONN;

      M(i + v_per_level, i) = DOWN_CONN;
      M(i + int32(v_per_level - block_size / 2), i) = UP_CONN;
    end
  end

  M = logical(M);
end
