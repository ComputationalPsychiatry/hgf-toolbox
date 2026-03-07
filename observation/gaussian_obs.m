function [logp, yhat, res] = gaussian_obs(r, infStates, ptrans)
% Calculates the log-probability of response y under the Gaussian noise model
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

% Transform zeta to its native space
ze = exp(ptrans(1));

% Initialize returned log-probabilities, predictions,
% and residuals as NaNs so that NaN is returned for all
% irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Weed irregular trials out from inferred states and responses
x = infStates(:,1,1);
x(r.irr) = [];
y = r.y(:,1);
y(r.irr) = [];

% Calculate log-probabilities for non-irregular trials
% Note: 8*atan(1) == 2*pi (this is used to guard against
% errors resulting from having used pi as a variable).
reg = ~ismember(1:n,r.irr);
logp(reg) = -1/2.*log(8*atan(1).*ze) -(y-x).^2./(2.*ze);
yhat(reg) = x;
res(reg) = y-x;

