function Ex2(N, n)

  r = N / n;





  % strictly non blocking
  m = 2*n -1;

  fprintf("Case strictly non blocking:\n");
  fprintf("stage 1: modules switches: %d of type %d X %d\n", r, n, m);
  fprintf("stage 2: modules switches: %d of type %d X %d\n", m, r, r);
  fprintf("stage 3: modules switches: %d of type %d X %d\n", r, m, n);

  Cnb = (r * 2 * ceil(m / n) + m * ceil(r / n) ^ 2 ) * n * n;

  % rearrangiable non blocking
  m = n;


  fprintf("Case rearrangiable non blocking:\n");
  fprintf("stage 1: modules switches: %d of type %d X %d\n", r, n, m);
  fprintf("stage 2: modules switches: %d of type %d X %d\n", m, r, r);
  fprintf("stage 3: modules switches: %d of type %d X %d\n", r, m, n);

  Crn = (r * 2 * ceil(m / n) + m * ceil(r / n) ^ 2) * n * n;

  % gain
  Ccr = N * N;

  fprintf("Calculating the gain wrt crossbar %d X %d:\n", N, N);
  fprintf("Cost of crossbar = %f\n", Ccr);
  fprintf("Cost of non blocking = %f\n", Cnb);
  fprintf("Cost of rearrangialbe non blocking = %f\n", Crn);
  fprintf("Gain of non blocking = %f\n", Ccr / Cnb);
  fprintf("Gain of rearrangiable non blocking = %f\n", Ccr / Crn);

end
