function [logp, yhat, res] = tapas_bayes_optimal_categorical(r, infStates, ptrans)
% Calculates the log-probability of the inputs given the current predictions

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Weed irregular trials out from predictions
pred = squeeze(infStates(:,1,:,1));
pred(r.irr,:) = [];

% Weed irregular trials out from inputs
u = r.u(:,1);
u(r.irr) = [];

% Calculate probabilities of observed outcomes
for k = 1:length(u)
    p(k) = pred(k,u(k));
end

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = log(p);
yhat(reg) = p;
res(reg) = -log(p);

