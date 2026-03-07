function [logp, yhat, res] = bayes_optimal_whichworld(r, infStates, ptrans)
% Calculates the log-probability of the inputs given the current predictions

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Number of worlds
nw = 4;

% Bernoulli parameters that characterize
% worlds (row vector)
bp = [0.85, 0.65, 0.35, 0.15];

% Weed irregular trials out from predictions and inputs
% States
pred = squeeze(infStates(:,1,:,1,1));
%states = squeeze(infStates(:,1,:,1));
%pred = [1/nw*ones(1,nw); states];
%pred(end,:) = [];
pred(r.irr,:) = [];

% Inputs
u = r.u(:,1);
u(r.irr) = [];

% Calculate probabilities of inputs

% Likelihood of outcome u(k)
bpm = repmat(bp, length(u), 1);
um  = repmat(u, 1, nw);
llh = bpm.^um.*(1-bpm).^(1-um);

% Marginal likelihood of outcome
mllhm = llh.*pred;
mllh = sum(mllhm,2);

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = log(mllh);
yhat(reg) = mllh;
res(reg) = -log(mllh);

