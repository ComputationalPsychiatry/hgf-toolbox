function [logp, yhat, res] = bayes_optimal_binary(r, infStates, ptrans)
% Calculates the log-probabilities of the inputs given the current prediction

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Weed irregular trials out from inputs and predictions
% Inputs
u = r.u(:,1);
u(r.irr) = [];

% Predictions
x = infStates(:,1,1);
x(r.irr) = [];

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = u.*log(x) + (1-u).*log(1-x);
yhat(reg) = x;
res(reg) = (u-x)./sqrt(x.*(1-x));

