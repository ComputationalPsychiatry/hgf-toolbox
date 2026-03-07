function muhat_j = hgf_prediction(mu_prev_j, t_k, varargin)
% Computes the one-step-ahead prediction for level j of the HGF.
%
% Supports three modes:
%   muhat_j = hgf_prediction(mu_prev_j, t_k)
%       Standard prediction without drift: muhat = mu_{k-1}
%
%   muhat_j = hgf_prediction(mu_prev_j, t_k, 'rho', rho_j)
%       Prediction with constant drift: muhat = mu_{k-1} + t * rho
%
%   muhat_j = hgf_prediction(mu_prev_j, t_k, 'rho', rho_j, 'phi', phi_j, 'm', m_j)
%       Prediction with drift and AR(1) mean reversion:
%       muhat = mu_{k-1} + t * rho + t * phi * (m - mu_{k-1})
%
% INPUT:
%   mu_prev_j   Previous posterior mean at level j
%   t_k          Time step (interval since last trial)
%   Optional name-value pairs:
%     'rho'      Drift rate (default: 0)
%     'phi'      AR(1) mean-reversion rate (default: 0)
%     'm'        AR(1) equilibrium mean (default: 0)
%
% OUTPUT:
%   muhat_j      Predicted mean at level j

% Parse optional inputs
rho_j = 0;
phi_j = 0;
m_j = 0;

i = 1;
while i <= length(varargin)
    switch varargin{i}
        case 'rho'
            rho_j = varargin{i+1};
            i = i + 2;
        case 'phi'
            phi_j = varargin{i+1};
            i = i + 2;
        case 'm'
            m_j = varargin{i+1};
            i = i + 2;
        otherwise
            error('tapas:hgf:UnknownOption', 'Unknown option: %s', varargin{i});
    end
end

muhat_j = mu_prev_j + t_k * rho_j + t_k * phi_j * (m_j - mu_prev_j);

end
