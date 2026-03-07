function [mu_1, pi_1, muhat_1, pihat_1, da_1] = hgf_binary_level1(u_k, ka_1, muhat_2, varargin)
% Computes the level-1 update for binary HGF models.
%
% In the binary HGF, level 1 represents the binary outcome directly.
% The prediction is formed via the logistic sigmoid of the level-2 prediction.
%
% USAGE:
%   [mu_1, pi_1, muhat_1, pihat_1, da_1] = hgf_binary_level1(u_k, ka_1, muhat_2)
%       Standard binary update: mu_1 = u_k, pi_1 = Inf
%
%   [mu_1, pi_1, muhat_1, pihat_1, da_1] = hgf_binary_level1(u_k, ka_1, muhat_2, ...
%       'pu', al, eta0, eta1)
%       Binary update with perceptual uncertainty
%
% INPUT:
%   u_k       Input (binary observation or continuous in PU case)
%   ka_1      Coupling from level 2 to level 1
%   muhat_2   Predicted mean at level 2
%   Optional name-value pair:
%     'pu'    Followed by [al, eta0, eta1] for perceptual uncertainty
%
% OUTPUT:
%   mu_1      Posterior mean at level 1
%   pi_1      Posterior precision at level 1
%   muhat_1   Predicted probability at level 1
%   pihat_1   Predicted precision at level 1
%   da_1      Prediction error at level 1

% Prediction via logistic sigmoid
muhat_1 = tapas_sgm(ka_1 * muhat_2, 1);

% Ensure numerical stability
muhat_1 = max(muhat_1, 0.001);
muhat_1 = min(muhat_1, 0.999);

% Precision of prediction
pihat_1 = 1/(muhat_1 * (1 - muhat_1));

% Parse optional PU arguments
use_pu = false;
i = 1;
while i <= length(varargin)
    switch varargin{i}
        case 'pu'
            use_pu = true;
            al   = varargin{i+1};
            eta0 = varargin{i+2};
            eta1 = varargin{i+3};
            i = i + 4;
        otherwise
            error('tapas:hgf:UnknownOption', 'Unknown option: %s', varargin{i});
    end
end

if use_pu
    % Perceptual uncertainty: Bayesian update with sensory likelihood
    und1 = exp(-(u_k - eta1)^2/(2*al));
    und0 = exp(-(u_k - eta0)^2/(2*al));
    mu_1 = muhat_1 * und1 / (muhat_1 * und1 + (1 - muhat_1) * und0);
    pi_1 = Inf;
else
    % Standard binary: perfect observation
    pi_1 = Inf;
    mu_1 = u_k;
end

% Prediction error
da_1 = mu_1 - muhat_1;

end
