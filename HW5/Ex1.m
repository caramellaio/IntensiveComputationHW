n = 16;
n=8;
start = randperm(n) - 1;
fin = randperm(n) - 1;
start = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
fin = [7 13 2 12 15 4 9 3 10 1 14 5 11 8 16 6];
fin = fin - 1;

%start = [0 1 2 3 4 5 6 7];
%fin =   [7 0 1 5 3 4 2 6];
%n = 8;

%fin = fin - 1;
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

%annotation('textbox', [0.75, 0.1, 0.1, 0.1, 0.1], 'String', "Red=error, Straight=blue, cross=green");
start
fin
annotation('textbox',[.9 .5 .1 .2],'String','Blue=straight, green = cross','EdgeColor','none')
