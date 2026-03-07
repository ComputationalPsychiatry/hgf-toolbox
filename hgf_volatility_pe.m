function da_j = hgf_volatility_pe(pi_j, mu_j, muhat_j, pihat_j)
% Computes the volatility prediction error at any level of the HGF.
%
% da_j = (1/pi_j + (mu_j - muhat_j)^2) * pihat_j - 1
%
% This is the same equation for both standard HGF and eHGF, and for
% all levels of the hierarchy.
%
% INPUT:
%   pi_j      Posterior precision at level j
%   mu_j      Posterior mean at level j
%   muhat_j   Predicted mean at level j
%   pihat_j   Predicted precision at level j
%
% OUTPUT:
%   da_j      Volatility prediction error at level j

da_j = (1/pi_j + (mu_j - muhat_j)^2) * pihat_j - 1;

end
