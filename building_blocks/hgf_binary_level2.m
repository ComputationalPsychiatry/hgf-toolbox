function [pi_2, mu_2, da_2] = hgf_binary_level2(muhat_2, pihat_2, ka_1, pihat_1, da_1)
% Computes the level-2 update for binary HGF models.
%
% In the binary HGF, level 2 is a continuous value updated based on the
% binary prediction error from level 1. This update is the same for
% both standard HGF and eHGF.
%
% INPUT:
%   muhat_2   Predicted mean at level 2
%   pihat_2   Predicted precision at level 2
%   ka_1      Coupling from level 2 to level 1
%   pihat_1   Predicted precision at level 1
%   da_1      Prediction error at level 1
%
% OUTPUT:
%   pi_2      Posterior precision at level 2
%   mu_2      Posterior mean at level 2
%   da_2      Volatility prediction error at level 2

% Precision update
pi_2 = pihat_2 + ka_1^2/pihat_1;

% Mean update
mu_2 = muhat_2 + ka_1/pi_2 * da_1;

% Volatility prediction error
da_2 = (1/pi_2 + (mu_2 - muhat_2)^2) * pihat_2 - 1;

end
