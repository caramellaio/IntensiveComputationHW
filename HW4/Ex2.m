

N_VALS = 3:5;
K_VALS = [100 500 1000];

pipeline_n_time = zeros(1, length(N_VALS));
pipeline_k_time = zeros(1, length(K_VALS));

RNS_n_time = zeros(1, length(N_VALS));
RNS_k_time = zeros(1, length(K_VALS));

RB_n_time = zeros(1, length(N_VALS));
RB_k_time = zeros(1, length(K_VALS));

pipeline_n_space = zeros(1, length(N_VALS));
pipeline_k_space = zeros(1, length(K_VALS));

RNS_n_space = zeros(1, length(N_VALS));
RNS_k_space = zeros(1, length(K_VALS));

RB_n_space = zeros(1, length(N_VALS));
RB_k_space = zeros(1, length(K_VALS));
% computing n vals
for i = 1:length(N_VALS)
  [p_n_t, p_n_s] = pipelinedAdditionSpeedup(K_VALS(1), N_VALS(i));
  [rns_n_t, rns_n_s] = RNSSumSpeedup(K_VALS(1), N_VALS(i));
  [rb_n_t, rb_n_s] = RNSRBSumSpeedup(K_VALS(1), N_VALS(i));

  pipeline_n_time(i) = p_n_t;
  pipeline_n_space(i) = p_n_s;

  RNS_n_time(i) = rns_n_t;
  RNS_n_space(i) = rns_n_s;

  RB_n_time(i) = rb_n_t;
  RB_n_space(i) = rb_n_s;
end

% computing K vals
for i = 1:length(N_VALS)
  [p_k_t, p_k_s] = pipelinedAdditionSpeedup(K_VALS(i), N_VALS(1));
  [rns_k_t, rns_k_s] = RNSSumSpeedup(K_VALS(i), N_VALS(1));
  [rb_k_t, rb_k_s] = RNSRBSumSpeedup(K_VALS(i), N_VALS(1));

  pipeline_k_time(i) = p_k_t;
  pipeline_k_space(i) = p_k_s;

  RNS_k_time(i) = rns_k_t;
  RNS_k_space(i) = rns_k_s;

  RB_k_time(i) = rb_k_t;
  RB_k_space(i) = rb_k_s;
end

% graphs 
tiledlayout(2,2);

% graph N

axn_time = nexttile;

pipeline_n_time
RNS_n_time
% time
plot(axn_time, N_VALS, pipeline_n_time, 'DisplayName', "PipelineTimeSpeedup");
hold on
plot(axn_time, N_VALS, RNS_n_time, 'DisplayName', "RNSTimeSpeedup");
hold on
plot(axn_time, N_VALS, RB_n_time, 'DisplayName', "RNSRBTimeSpeedup");
xlabel('N config');
ylabel('time speedup');
legend(axn_time);

axn_space = nexttile;
% space
plot(axn_space, N_VALS, pipeline_n_space, 'DisplayName', "PipelineSpaceSpeedup");
hold on
plot(axn_space, N_VALS, RNS_n_space, 'DisplayName', "RNSSpaceSpeedup");
hold on
plot(axn_space, N_VALS, RB_n_space, 'DisplayName', "RNSRBSpaceSpeedup");

xlabel('N config');
ylabel('area speedup');
legend(axn_space);
% graph k

% time
axk_time = nexttile;

plot(axk_time, K_VALS, pipeline_k_time, 'DisplayName', "PipelineTimeSpeedup");
hold on
plot(axk_time, K_VALS, RNS_k_time, 'DisplayName', "RNSTimeSpeedup");
hold on
plot(axk_time, K_VALS, RB_k_time, 'DisplayName', "RNSRBTimeSpeedup");
xlabel('K config');
ylabel('time speedup');
legend(axk_time);

axk_space = nexttile;
% space
plot(axk_space, K_VALS, pipeline_k_space, 'DisplayName', "PipelineSpaceSpeedup");
hold on
plot(axk_space, K_VALS, RNS_k_space, 'DisplayName', "RNSSpaceSpeedup");
hold on
plot(axk_space, K_VALS, RB_k_space, 'DisplayName', "RNSRBSpaceSpeedup");

xlabel('K config');
ylabel('area speedup');
legend(axk_space);

% COMPUTING FUNCTIONS
function [t, s] = pipelinedAdditionSpeedup(k, n)
  M = prod(2^n -1:2^n + 1);

  nn = ceil(log2(M - 1));
  t = nn * k;
  s = t;

  time_in_FA = 0;
  space_in_FA = 0;

  for i =1:k
    val1 = int32(rand*(M-1));
    val2 = int32(rand*(M-1));

    % n -1 half adder time = n - 1 /2 full adder time
    time_in_FA = time_in_FA + (nn - 1) / 2;
    % 3 / 7 to pass from HA to FA. N^2/2 HA_circuits
    space_in_FA = space_in_FA + (3 / 7) *(nn ^ 2) / 2;
  end

  t = t / time_in_FA;
  s = s / space_in_FA;
end

function [t, s] = RNSSumSpeedup(k, n)

  M = prod(2^n -1:2^n + 1);
  t = k * ceil(log2(M - 1));
  s = t;

  time_in_FA = 0;
  space_in_FA = 0;
  for i = 1:k
    val1 = int32(rand*(M-1));
    val2 = int32(rand*(M-1));

    % it tooks n for mod1 and mod2, it tooks n + 1 for mod3
    time_in_FA = time_in_FA + 3 * (n + 1);
    % we need n FA for mod1 and mod2 + we need n + 1 FA for mod3
    space_in_FA = space_in_FA + 3 * (n * n * (n + 1));
  end

  t = t / time_in_FA;
  s = s / space_in_FA;
end

function [t, s] = RNSRBSumSpeedup(k, n)
  M = prod(2^n -1:2^n + 1);
  t = k * ceil(log2(M - 1));
  s = t;

  time_in_FA = 0;
  space_in_FA = 0;
  for i = 1:k
    val1 = int32(rand*(M-1));
    val2 = int32(rand*(M-1));
    % case 3
    % time is constant. It is 2 because RB sum has 2 steps
    time_in_FA = time_in_FA + 2 * 3; 
    % every bit couple has 2 FA.
    % 2 couples have n bits, the last couple has n + 1 bits
    space_in_FA = space_in_FA + 2 * n * n * (n + 1) * 3;
  end

  t = t / time_in_FA;
  s = s / space_in_FA;
end

