addpath('../HW1')

M = MatrixGen().genRandomMatrix(25, 0.2, 100);
b = MatrixGen().genRandomMatrix(25, 0.1, 100);
b = b(:, 1);
res = linsolve(M, b);
res2 = gaussianElim(M, b, Pivoting().getZeroPivoting, true, true, "out.avi");

assert(sum(abs(res -res2)) < 0.1);

