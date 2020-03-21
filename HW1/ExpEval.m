
funcs = [MSR(), EllLt(), CSC(), CSR(), fullFuncs()];
genM = MatrixGen().genRandomMatrix;
labels = ["MSR", "EllLt", "CSC", "CSR", "full"];
ExpEvals(funcs, genM, labels);

function funs = fullFuncs

  funs.toCompact=@id;
  funs.extractCol=0;
  funs.extractRow=0;
  funs.mul=@fullMul;
  funs.toFull=@id;
  funs.extrColComp=0;
  funs.extrRowComp=0;
end

function ExpEvals(funcs, genMFunc, method_labels)

  % we perform 5 iterations and then we get the avg.
  iters = 10;
  n_configs = 1:8;

  n_configs = n_configs * 25;
  Y_time_comp = zeros(1, length(n_configs));
  Y_space_comp = zeros(1, length(n_configs));

  space = zeros(length(funcs), length(n_configs));
  time = zeros(length(funcs), length(n_configs));
  for k = 1:length(n_configs)
    n = n_configs(k)

    M1 = genMFunc(n, 0.8, 100);
    M2 = genMFunc(n, 0.8, 100);

    for a = 1:length(funcs)
      method_labels(a)
      func = funcs(a);
      mul_t = 0;
      space_i = 0;
      for i = 1:iters
        A = func.toCompact(M1);
        B = func.toCompact(M2);
        t = cputime;
        C = func.mul(A, B);
        mul_t = mul_t + cputime - t;

        tmp = func.toFull(C);
        assert(abs(sum(M1*M2 - tmp, 'all')) < 0.0005);
        space_i = space_i + whos('A').bytes;
      end
      mul_t = mul_t / iters;
      space(a, k) = space_i / iters;
      time(a, k) = mul_t;
    end
  end

  tiledlayout(1,2);

  ax1=nexttile;
  % time

  for i = 1:size(time, 1)
    plot(ax1, n_configs, time(i, :), 'DisplayName', method_labels(i));
    hold on
  end

  xlabel('square matrix size');
  ylabel('time (seconds)');
  legend(ax1);

  ax2=nexttile;
  %space 

  for i = 1:size(space, 1)
    space(i, :)
    plot(ax2, n_configs, space(i, :), 'DisplayName', method_labels(i));
    hold on
  end

  xlabel('square matrix size');
  ylabel('space (byte)');
  legend(ax2);


end

function MM = id(M)
  MM = M;
end

function MM = fullMul(M1, M2)
  MM = M1*M2;
end
