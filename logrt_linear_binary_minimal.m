function [logp, yhat, res] = logrt_linear_binary_minimal(r, infStates, ptrans)
% Calculates the log-probability of log-reaction times
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

% Transform parameters to their native space
be0  = ptrans(1);
be1  = ptrans(2);
be2  = ptrans(3);
ze   = exp(ptrans(4));

% Initialize returned log-probabilities, predictions,
% and residuals as NaNs so that NaN is returned for all
% irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Weed irregular trials out from responses and inputs
y = r.y(:,1);
y(r.irr) = [];

u = r.u(:,1);
u(r.irr) = [];

% Extract trajectories of interest from infStates
mu1hat = infStates(:,1,1);
sa1hat = mu1hat.*(1-mu1hat);

% Surprise
% ~~~~~~~~
m1hreg = mu1hat;
m1hreg(r.irr) = [];
poo = m1hreg.^u.*(1-m1hreg).^(1-u); % probability of observed outcome
surp = -log2(poo);

% Bernoulli variance (aka irreducible uncertainty, risk) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bernv = sa1hat;
bernv(r.irr) = [];

% Calculate predicted log-reaction time
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
logrt = be0 +be1.*surp +be2.*bernv;

% Calculate log-probabilities for non-irregular trials
% Note: 8*atan(1) == 2*pi (this is used to guard against
% errors resulting from having used pi as a variable).
reg = ~ismember(1:n,r.irr);
logp(reg) = -1/2.*log(8*atan(1).*ze) -(y-logrt).^2./(2.*ze);
yhat(reg) = logrt;
res(reg) = y-logrt;

end
