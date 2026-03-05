function [logp, yhat, res] = tapas_softmax_mu3(r, infStates, ptrans)
% Calculates the log-probability of responses under the softmax model

% Predictions or posteriors?
pop = 1; % Default: predictions
if r.c_obs.predorpost == 2
    pop = 3; % Alternative: posteriors
end

% Initialize returned log-probabilities, predictions,
% and residuals as NaNs so that NaN is returned for all
% irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Assumed structure of infStates:
% dim 1: time (ie, input sequence number)
% dim 2: HGF level
% dim 3: choice number
% dim 4: 1: muhat, 2: sahat, 3: mu, 4: sa

% Number of choices
nc = size(infStates,3);

% Belief trajectories at 1st level
states = squeeze(infStates(:,1,:,pop));

% Log-volatility trajectory
mu3 = squeeze(infStates(:,3,1,3));

% Responses
y = r.y(:,1);

% Weed irregular trials out from inferred states and responses
states(r.irr,:) = [];
mu3(r.irr) = [];
y(r.irr) = [];

% Inverse decision temperature
be = exp(-mu3);
be = repmat(be,1,nc);

% Partition functions
Z = sum(exp(be.*states),2);
Z = repmat(Z,1,nc);

% Softmax probabilities
prob = exp(be.*states)./Z;

% Extract probabilities of chosen options
probc = prob(sub2ind(size(prob), 1:length(y), y'));

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = log(probc);
yhat(reg) = probc;
res(reg) = -log(probc);

end
