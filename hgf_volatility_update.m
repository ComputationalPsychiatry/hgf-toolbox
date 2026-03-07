function [pi_j, mu_j, v_jm1, w_jm1] = hgf_volatility_update(muhat_j, pihat_j, ...
    ka_jm1, pihat_jm1, da_jm1, mu_prev_j, om_jm1, pi_prev_jm1, ...
    pi_jm1, mu_jm1, muhat_jm1, t_k, update_type)
% Computes the posterior precision and mean update at a volatility level of the HGF.
%
% This is the key function that implements the difference between the standard HGF
% and the enhanced HGF (eHGF). At volatility levels (j >= 2 in continuous models,
% j >= 3 in binary models), the precision update differs between the two variants.
%
% USAGE:
%   [pi_j, mu_j, v_jm1, w_jm1] = hgf_volatility_update(muhat_j, pihat_j, ...
%       ka_jm1, pihat_jm1, da_jm1, mu_prev_j, om_jm1, pi_prev_jm1, ...
%       pi_jm1, mu_jm1, muhat_jm1, t_k, update_type)
%
% INPUT:
%   muhat_j       Predicted mean at level j
%   pihat_j       Predicted precision at level j
%   ka_jm1        Coupling strength from level j to level j-1
%   pihat_jm1     Predicted precision at level j-1
%   da_jm1        Volatility prediction error at level j-1
%   mu_prev_j     Previous posterior mean at level j (from trial k-1)
%   om_jm1        Log-volatility offset at level j-1
%   pi_prev_jm1   Previous posterior precision at level j-1 (from trial k-1)
%   pi_jm1        Current posterior precision at level j-1 (from trial k)
%   mu_jm1        Current posterior mean at level j-1 (from trial k)
%   muhat_jm1     Current predicted mean at level j-1 (from trial k)
%   t_k           Time step
%   update_type   'hgf' for standard or 'ehgf' for enhanced (safe) updates
%
% OUTPUT:
%   pi_j          Updated posterior precision at level j
%   mu_j          Updated posterior mean at level j
%   v_jm1         Variance of the random walk at level j-1
%   w_jm1         Weighting factor at level j-1

% Weighting factor (same for both variants)
v_jm1 = t_k * exp(ka_jm1 * mu_prev_j + om_jm1);
w_jm1 = v_jm1 * pihat_jm1;

if strcmp(update_type, 'hgf')
    % Standard HGF: Non-linear precision update
    pi_j = pihat_j + 1/2 * ka_jm1^2 * w_jm1 * (w_jm1 + (2 * w_jm1 - 1) * da_jm1);

    if pi_j <= 0
        error('tapas:hgf:NegPostPrec', ...
            'Negative posterior precision. Parameters are in a region where model assumptions are violated.');
    end

    mu_j = muhat_j + 1/2 * 1/pi_j * ka_jm1 * w_jm1 * da_jm1;

elseif strcmp(update_type, 'ehgf')
    % Enhanced HGF: Mean update first, then safe precision update
    mu_j = muhat_j + 1/2 * 1/pihat_j * ka_jm1 * w_jm1 * da_jm1;

    % Ingredients of precision update which depend on the mean update
    vv = t_k * exp(ka_jm1 * mu_j + om_jm1);
    pimhat = 1/(1/pi_prev_jm1 + vv);
    ww = vv * pimhat;
    rr = (vv - 1/pi_prev_jm1) * pimhat;
    dd = (1/pi_jm1 + (mu_jm1 - muhat_jm1)^2) * pimhat - 1;

    % Safe precision update (prevents negative precision)
    pi_j = pihat_j + max(0, 1/2 * ka_jm1^2 * ww * (ww + rr * dd));
else
    error('tapas:hgf:UnknownUpdateType', ...
        'Unknown update type: %s. Must be ''hgf'' or ''ehgf''.', update_type);
end

end
