function [logp, yhat, res] = tapas_bayes_optimal_whatworld(r, infStates, ptrans)
% Calculates the log-probability of the inputs given the current predictions

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Number of states whose contingencies have to be learned
ns = r.c_prc.n_states;

% Number of elements of the transition matrix
ntr = ns^2;

% Weed irregular trials out from predictions and inputs
% States
pred = squeeze(infStates(:,1,:,:,1,1));
pred(r.irr,:) = [];

% Inputs
u = r.u(:,1);

% Transitions: first column - to; second column - from;
ufrom = [1; u];
ufrom(end) = [];
tr = [u ufrom];

% Weed transitions from irregular trials out
tr(r.irr,:) = [];

% Calculate probabilities of transitions
for k = 1:length(u)
    p(k) = pred(k,tr(k,1),tr(k,2));
end

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = log(p);
yhat(reg) = p;
res(reg) = -log(p);

