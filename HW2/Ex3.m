addpath('../HW1');

DEF_N = 200;
DEF_EPSILON = 10^-9;
DEF_NON_DIAG_UBOUND = 100;
DEF_SPARSITY = 0.65;
DEF_REPEAT = 10;

Y = zeros(4, 1);


for i = 1:DEF_REPEAT
  M = MatrixGen().genDiagDomRandomMatrix(DEF_N, DEF_SPARSITY, DEF_NON_DIAG_UBOUND);
  c = MSR().toCompact(M);
  b = MatrixGen().genRandomMatrix(DEF_N, DEF_SPARSITY, DEF_NON_DIAG_UBOUND);
  b = b(:,1);
  [x, y_1] = Jacobi(c, b, DEF_EPSILON, true, false);
  [x, y_2] = Jacobi(c, b, DEF_EPSILON, false, false);
  [x, y_3] = GaussSiedel(c, b, DEF_EPSILON, true);
  [x, y_4] = GaussSiedel(c, b, DEF_EPSILON, false);

  Y
  Y = Y + [y_1;y_2;y_3;y_4];
end

Y = Y / DEF_REPEAT;

barh([1], Y);
xlabel("Number of required iterations");
ylabel("Method applied");
legend({"E1J","E2J","E1GS","E2GS"});
