addpath ../HW1
DEF_MUL = 25;
DEF_NUM = 4;
DEF_STEPS = 100;
DEF_UBOUND = 20;

error_epair = zeros(DEF_NUM, 1);
error_epair_min = zeros(DEF_NUM, 1);
error_epair_max = zeros(DEF_NUM, 1);
error_defl = zeros(DEF_NUM, 1);
error_defl_min = zeros(DEF_NUM, 1);
error_defl_max = zeros(DEF_NUM, 1);

for i = 1:DEF_NUM
  n = i * DEF_MUL;

  for j =1:DEF_STEPS
    M = MatrixGen().genRandomMatrix(n, 0.3, DEF_UBOUND);
    t = cputime;
    [x1, lambda1] = epair(M, 100);
    eig_val = abs(eig(M));
    [correct, max_idx] = max(eig_val);
    err = abs(correct - lambda1);
    error_epair(i) = error_epair(i) + err;
    fprintf("err epair: %f\n", err);
    error_epair_min(i) = min(error_epair_min(i), err);
    error_epair_max(i) = max(error_epair_max(i), err);

    [x2, lambda2] = deflation(M, x1, lambda1);

    % get the second greatest correct
    eig_val(max_idx) = 0;
    correct = max(abs(eig_val));
    err = abs(correct - lambda2);
    fprintf("err defl: %f\n", err);
    error_defl(i) = error_defl(i) + err;
    error_defl_min(i) = min(error_defl_min(i), err);
    error_defl_max(i) = max(error_defl_max(i), err);
  end

end

% divide to get average
error_epair = error_epair / DEF_STEPS
error_defl = error_defl / DEF_STEPS

error_defl_min
error_defl_max


% plot

% epair

subplot(1, 2, 1);
X = (1:DEF_NUM) * DEF_MUL;
bar(X, error_epair);
hold on
er = errorbar(X, error_epair, error_epair_min, error_epair_max);
er.Color = [0, 0, 0];
er.LineStyle = 'none'

% deflation
subplot(1, 2, 2);
X = (1:DEF_NUM) * DEF_MUL;
bar(X, error_defl);
hold on
er = errorbar(X, error_defl, error_defl_min, error_defl_max);
er.Color = [0, 0, 0];
er.LineStyle = 'none'

hold off
