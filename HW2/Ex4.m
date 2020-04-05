addpath('../HW1');
% Experiment constants
DEF_MUL = 2500;
DEF_STEPS = 8;
DEF_REPEAT = 5;
DEF_NON_DIAG_UBOUND = 100;
DEF_EPSILON = 10^-5;
% my machine supports at most 2 workers
DEF_WORKERS = 2;
DEF_SPARSITY = 0.01;
% NOTE: exact = true creates overhead which is not good for exp. eval.
DEF_USE_EXACT = false;

% res variables initialization
Y_sequential = zeros(1, DEF_STEPS);
Y_parallel = zeros(1, DEF_STEPS);

% Calculation of times

% time for par overhead
% calculate once since it does not depend on any step

step = 0;

t = cputime;
pool = parpool(DEF_WORKERS);
y_o = cputime - t;
Y_overhead = ones(1, DEF_STEPS) * y_o

% jacobi time calc
for i = 1:DEF_STEPS
  n = i * DEF_MUL;

  n
  for j = 1:DEF_REPEAT
    M = MatrixGen().genDiagDomRandomMatrix(n, DEF_SPARSITY, DEF_NON_DIAG_UBOUND);
    c = MSR().toCompact(M);
    b = MatrixGen().genRandomMatrix(n, DEF_SPARSITY, DEF_NON_DIAG_UBOUND);
    b = b(:,1);


    % time for par jacobi
    t = cputime;
    Jacobi(c, b, DEF_EPSILON, false, true);
    y_pj = cputime - t;
    Y_parallel(i) = Y_parallel(i) + y_pj;
    fprintf("Parallel time %f\n", y_pj);

    % time for seq jacobi
    t = cputime;
    Jacobi(c, b, DEF_EPSILON, false, false);
    y_sj = cputime - t;
    Y_sequential(i) = Y_sequential(i) + y_sj;
    fprintf("Sequential time %f\n", y_pj);

  end

  % get the mean
  Y_parallel(i) = Y_parallel(i) / DEF_REPEAT;
  fprintf("Average parallel time with n = %d %f\n", n, Y_parallel(i));
  Y_sequential(i) = Y_sequential(i) / DEF_REPEAT;
  fprintf("Average Sequential time with n = %d %f\n", n, Y_sequential(i));
end

Y_sequential
Y_parallel
t = cputime;
delete(pool);
ov_close = cputime - t;
Y_overhead = Y_overhead + ov_close

% plot constants
DEF_SEQ_LABEL = "Sequential Execution";
DEF_PAR_LABEL = "Parallel Execution (without overhead)";
DEF_PAR_LABEL_WITH_OVERHEAD = "Parallel Execution (with overhead)";
X_LABEL_NAME = "size of matrix (count of rows)";
Y_LABEL_NAME = "execution time (sec)"
X = (1:DEF_STEPS) * DEF_MUL;
% plot of results
plot(X, Y_sequential, 'DisplayName', DEF_SEQ_LABEL);
hold on;
plot(X, Y_parallel, 'DisplayName', DEF_PAR_LABEL);
hold on;
plot(X, Y_parallel + Y_overhead, 'DisplayName', DEF_PAR_LABEL_WITH_OVERHEAD);

% print labels
xlabel(X_LABEL_NAME);
ylabel(Y_LABEL_NAME);
legend;
