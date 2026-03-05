function u = tapas_datagen_categorical
% This function generates categorical input data for the hgf_categorical model

% First set of outcomes
u = mnrnd(1, [0.8, 0.1, 0.1], 64);

% Second set of outcomes
u = [u; mnrnd(1, [1/3, 1/3, 1/3], 64)];

% Third set of outcomes
u = [u; mnrnd(1, [0.1, 0.1, 0.8], 64)];

% Add next set of outcomes (...or don't)

% Turn u into a single column of natural numbers indicating outcome category
u = sum(u*diag([1 2 3]),2);
