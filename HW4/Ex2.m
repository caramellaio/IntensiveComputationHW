% full adder / half adder constants

global TFA;
global THA;
global AFA;
global AHA;

TFA = 4;
THA = 2;
AFA = 7;
AHA = 3;

N_VALS = 3:5;
K_VALS = [100 500 1000 2000];

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
for i = 1:length(K_VALS)
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
  global TFA;
  global THA;
  global AFA;
  global AHA;

  M = prod(2^n -1:2^n + 1);

  % number of bits
  nn = floor(log2(M - 1)) + 1;

  % first we compute ripple carry adder values
  [tRca, sRca] = RCACost(k, n);


  % the time = number of bits + k - 1 all multiplied by the half adder time
  timePipeline = (nn + k - 1) * THA;
  spacePipeline = nn * (nn + 1) / 2 * AHA;

  t = tRca / timePipeline;
  s = sRca / spacePipeline;
end

function [t, s] = RNSSumSpeedup(k, n)
  global TFA;
  global THA;
  global AFA;
  global AHA;

  M = prod(2^n -1:2^n + 1);


  % first we compute ripple carry adder values
  [tRca, sRca] = RCACost(k, n);

  % here the time is the max number of bits * k times * time of full adder
  tRNS = k * (n + 1) * TFA;
  % as area we use n bits 2 times + the last time n + 1. All considering the space of a full adder
  sRNS = AFA * (n + n + n + 1);

  t = tRca / tRNS;
  s = sRca / sRNS;
end

function [t, s] = RNSRBSumSpeedup(k, n)
  global TFA;
  global THA;
  global AFA;
  global AHA;

  % first we compute ripple carry adder values
  [tRca, sRca] = RCACost(k, n);

  % we use TFA k times * 2 because RB sum has 2 steps
  tRNSRB = TFA  * 2;

  % 2 elements have n bits, the last n + 1 bits
  sRNSRB = AFA * (n + n + n + 1) * 2;

  t = tRca / tRNSRB;
  s = sRca / sRNSRB;
end

function [t, s] = RCACost(k, n)
  global TFA;
  global THA;
  global AFA;
  global AHA;

  M = prod(2^n -1:2^n + 1);

  % number of bits
  nn = floor(log2(M - 1)) + 1;

  % number of bits * k * time of a full adder
  t = nn * k * TFA;
  % and ripple carry adder space (number of bits * full adder space)
  s = nn * AFA;
end
