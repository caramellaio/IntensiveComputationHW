function Ex2(N, n)

  % strictly non blocking
  m = 2*n -1;

  r = N / n;

  s1_nb_sw = r;
  s1_nb_t = [n, m];

  s2_nb_sw = m;
  s2_nb_t = [r, r];

  s3_nb_sw = r;
  s3_nb_t = [m, n];

  % rearrangiable non blocking
  m = n;

  s1_rn_sw = r;
  s1_rn_t = [n, m];

  s2_rn_sw = m;
  s2_rn_t = [r, r];

  s3_rn_sw = r;
  s3_rn_t = [m, n];

  fprintf("Case strictly non blocking:\n");
  fprintf("stage 1: modules switches: %d of type %d X %d\n", s1_nb_sw, s1_nb_t);
  fprintf("stage 2: modules switches: %d of type %d X %d\n", s2_nb_sw, s2_nb_t);
  fprintf("stage 3: modules switches: %d of type %d X %d\n", s3_nb_sw, s3_nb_t);

  fprintf("Case rearrangiable non blocking:\n");
  fprintf("stage 1: modules switches: %d of type %d X %d\n", s1_rn_sw, s1_rn_t);
  fprintf("stage 2: modules switches: %d of type %d X %d\n", s2_rn_sw, s2_rn_t);
  fprintf("stage 3: modules switches: %d of type %d X %d\n", s3_rn_sw, s3_rn_t);


  % gain
  Ccr = N * N;

  %Cnb = (s1_nb_sw * 2 + % 2 because m = 2*n -1
  %       s2_nb_sw * ceil(r / n)+ % here we build switch using nXn
  %       s2_nb_sw * 2 ) *
  %       n * n; % crossbar n*n cost

  Cnb = (s1_nb_sw * 2 + s2_nb_sw * ceil(r / n) + s3_nb_sw * 2 ) * n * n;

  %Crn = (s1_rn_sw + % 2 because m = 2*n -1
  %       s2_rn_sw * ceil(r / n)+ % here we build switch using nXn
  %       s2_rn_sw) *
  %       n * n; % crossbar n*n cost

  Crn = (s1_rn_sw + s2_rn_sw * ceil(r / n) + s3_rn_sw) * n * n;

  fprintf("Calculating the gain wrt crossbar %d X %d:\n", N, N);
  fprintf("Cost of crossbar = %f\n", Ccr);
  fprintf("Cost of non blocking = %f\n", Cnb);
  fprintf("Cost of rearrangialbe non blocking = %f\n", Crn);
  fprintf("Gain of non blocking = %f\n", Ccr / Cnb);
  fprintf("Gain of rearrangiable non blocking = %f\n", Ccr / Crn);

end
