function [logp, yhat, res] = softmax(r, infStates, ptrans)
% Calculates the log-probability of responses under the softmax model
%
% INPUT:
%   r          Result struct. Relevant fields:
%                r.y    - responses (n_trials x 1)
%                r.irr  - index of irregular trials
%                r.c_obs - observation model config
%   infStates  Inferred states from the perceptual model
%              (n_trials x n_levels x 4; see ARCHITECTURE.md)
%   ptrans     Observation model parameters in transformed (optimization) space
%
% OUTPUT:
%   logp       Log-probabilities of observed responses (n_trials x 1)
%   yhat       Predicted responses (n_trials x 1)
%   res        Residuals: y - yhat (n_trials x 1)

% Predictions or posteriors?
pop = 1; % Default: predictions
if r.c_obs.predorpost == 2
    pop = 3; % Alternative: posteriors
end

% Transform beta to its native space
be = exp(ptrans(1));

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

% Responses
y = r.y(:,1);

% Weed irregular trials out from inferred states and responses
states(r.irr,:) = [];
y(r.irr) = [];

% Partition functions
Z = sum(exp(be*states),2);
Z = repmat(Z,1,nc);

% Softmax probabilities
prob = exp(be*states)./Z;

% Extract probabilities of chosen options
probc = prob(sub2ind(size(prob), 1:length(y), y'));

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = log(probc);
yhat(reg) = probc;
res(reg) = -log(probc);

end
