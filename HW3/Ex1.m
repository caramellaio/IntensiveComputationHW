addpath ../HW1
M = MatrixGen().genRandomMatrix(5, 0.3, 100);
[x1, lambda1] = epair(M, 100);
[x2, lambda2] = deflation(M, x1, lambda1);
