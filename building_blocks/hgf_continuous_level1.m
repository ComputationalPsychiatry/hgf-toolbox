function [pi_1, mu_1, dau, da_1] = hgf_continuous_level1(u_k, muhat_1, pihat_1, al)
% Computes the level-1 update for continuous HGF models.
%
% In the continuous HGF, level 1 is a Gaussian variable updated with
% the input observation. This update is the same for both standard HGF
% and eHGF.
%
% INPUT:
%   u_k       Input value (continuous observation)
%   muhat_1   Predicted mean at level 1
%   pihat_1   Predicted precision at level 1
%   al        Observation noise variance (alpha = 1/pi_u)
%
% OUTPUT:
%   pi_1      Posterior precision at level 1
%   mu_1      Posterior mean at level 1
%   dau       Input prediction error (value PE)
%   da_1      Volatility prediction error at level 1

% Input prediction error
dau = u_k - muhat_1;

% Precision update
pi_1 = pihat_1 + 1/al;

% Mean update
mu_1 = muhat_1 + 1/pihat_1 * 1/(1/pihat_1 + al) * dau;

% Volatility prediction error
da_1 = (1/pi_1 + (mu_1 - muhat_1)^2) * pihat_1 - 1;

end
