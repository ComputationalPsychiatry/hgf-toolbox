function [logp, yhat, res] = unitsq_sgm_mu3(r, infStates, ptrans)
% Calculates the log-probability of response y=1 under the unit-square sigmoid model

% Initialize returned log-probabilities as NaNs so that NaN is
% returned for all irregualar trials
n = size(infStates,1);
logp = NaN(n,1);
yhat = NaN(n,1);
res  = NaN(n,1);

% Weed irregular trials out from inferred states and responses
mu1hat = infStates(:,1,1);
mu1hat(r.irr) = [];
mu3hat = infStates(:,3,1);
mu3hat(r.irr) = [];
y = r.y(:,1);
y(r.irr) = [];

% Decision temperature is exponential of log-volatility
% (i.e., inverse decision temperature is exponential of negative log-volatility)
ze = exp(-mu3hat);

% Avoid any numerical problems when taking logarithms close to 1
x = mu1hat;
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

