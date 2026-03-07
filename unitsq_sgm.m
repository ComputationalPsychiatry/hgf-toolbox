function [logp, yhat, res] = unitsq_sgm(r, infStates, ptrans)
% Calculates the log-probability of response y=1 under the unit-square sigmoid model
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

% Transform zeta to its native space
ze = exp(ptrans(1));

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Weed irregular trials out from inferred states and responses
x = infStates(:,1,pop);
x(r.irr) = [];
y = r.y(:,1);
y(r.irr) = [];

% Avoid any numerical problems when taking logarithms close to 1
logx = log(x);
log1pxm1 = log1p(x-1);
logx(1-x<1e-4) = log1pxm1(1-x<1e-4);
log1mx = log(1-x);
log1pmx = log1p(-x);
log1mx(x<1e-4) = log1pmx(x<1e-4); 

% Calculate log-probabilities for non-irregular trials
reg = ~ismember(1:n,r.irr);
logp(reg) = y.*ze.*(logx -log1mx) +ze.*log1mx -log((1-x).^ze +x.^ze);
yhat(reg) = x;
res(reg) = (y-x)./sqrt(x.*(1-x));

