start = randperm(n);
fin = randperm(n);

%start = [0 1 2 3 4 5 6 7];
%fin =   [7 0 1 5 3 4 2 6];

[P, S] = selfRoutingButterfly(start, fin);

p = drawButterfly(log2(length(start)));
size_S = size(S);
resh_S = reshape(S, [1, prod(size_S)]);
cross_idxs = find(resh_S == 1);
conf_idxs = find(isnan(resh_S));
straight_idxs = find(resh_S == 0);
non_calc_idxs = find(resh_S == -1);

CROSS_COLOR = 'g';
CONF_COLOR = 'r';
STRAIGHT_COLOR = 'b';
NON_CALC_COLOR = [0.5, 0.5, 0.5];
highlight(p, cross_idxs, 'NodeColor', CROSS_COLOR)
highlight(p, conf_idxs, 'NodeColor', CONF_COLOR)
highlight(p, straight_idxs, 'NodeColor', STRAIGHT_COLOR)
highlight(p, non_calc_idxs, 'NodeColor', NON_CALC_COLOR)
