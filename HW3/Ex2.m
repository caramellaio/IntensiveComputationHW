DEF_N = 50;
DEF_N_IT=100;
DEF_AVG_DEG = 15;
HIGHLIGHT_COL_1 = 'r';
HIGHLIGHT_COL_2 = 'g';

M = genRandomGraph(DEF_N, DEF_AVG_DEG);

% gen graphs
g = graph(M);

% part 1
[x1, l1] = epair(M, DEF_N_IT);
access_idx = find(x1==1);
fprintf("Most accessible town is town n: %d\n", access_idx);

% part 2
L = lapl(M);
[field_vec, field_val] = fielder(L);

% 2.1 pos neg
pos_idxs = find(field_vec >= 0);
neg_idxs = find(field_vec < 0);

% 2.2 mean
avg = mean(field_vec);
lt_mean_idxs = find(field_vec < avg);
ge_mean_idxs = find(field_vec >= avg);

% 2.3 median
med = median(field_vec);
lt_median_idxs = find(field_vec < med);
ge_median_idxs = find(field_vec >= med);


L
% plotting
subplot(2, 2, 1);
p1 = plot(g);
title("Gould index of Accessibility");
highlight(p1, access_idx, 'NodeColor', HIGHLIGHT_COL_1);

subplot(2, 2, 2);
p2 = plot(g);
title("pos/neg bipartition");
highlight(p2, neg_idxs, 'NodeColor', HIGHLIGHT_COL_1);
highlight(p2, pos_idxs, 'NodeColor', HIGHLIGHT_COL_2);

subplot(2, 2, 3);
p3 = plot(g);
title("mean bipartition");
highlight(p3, lt_mean_idxs, 'NodeColor', HIGHLIGHT_COL_1);
highlight(p3, ge_mean_idxs, 'NodeColor', HIGHLIGHT_COL_2);

subplot(2, 2, 4);
p4 = plot(g);
title("median bipartition");
highlight(p4, lt_median_idxs, 'NodeColor', HIGHLIGHT_COL_1);
highlight(p4, ge_median_idxs, 'NodeColor', HIGHLIGHT_COL_2);
