function [pi_j, mu_j, v_jm1, w_jm1] = hgf_volatility_update(muhat_j, pihat_j, ...
    ka_jm1, pihat_jm1, da_jm1, mu_prev_j, om_jm1, pi_prev_jm1, ...
    pi_jm1, mu_jm1, muhat_jm1, t_k, update_type)
% Computes the posterior precision and mean update at a volatility level of the HGF.
%
% This is the key function that implements the difference between the standard HGF,
% enhanced HGF (eHGF), and unbounded HGF (uHGF). At volatility levels (j >= 2 in
% continuous models, j >= 3 in binary models), the precision update differs between
% the three variants.
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
%   update_type   'hgf' for standard, 'ehgf' for enhanced, or 'uhgf' for unbounded
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

elseif strcmp(update_type, 'uhgf')
    % Unbounded HGF: Dual quadratic approximation with Lambert W mode-finding
    % and Gaussian mixture moment matching.
    %
    % Expansion 1 is the quadratic expansion at the prediction (prior mean).
    % Expansion 2 is the quadratic expansion at the approximate posterior mode
    % obtained via the Lambert W_0 function, which solves the mode equation
    % exactly in the limit alpha -> 0.
    %
    % The two Gaussians are blended via a softmax weight based on the
    % variational energy I, and the final posterior is the moment-matched
    % Gaussian of the resulting two-component mixture.
    %
    % Posterior precision is always positive.

    % Recompute v and w using muhat_j (predicted mean) instead of mu_prev_j
    v_jm1 = t_k * exp(ka_jm1 * muhat_j + om_jm1);
    w_jm1 = v_jm1 / (1/pi_prev_jm1 + v_jm1);

    % -- Expansion 1: quadratic expansion at the prediction --
    pi1 = pihat_j + 1/2 * ka_jm1^2 * w_jm1 * (1 - w_jm1);
    mu1 = muhat_j + 1/2 * 1/pi1 * ka_jm1 * w_jm1 * da_jm1;

    % -- Auxiliary quantities --
    al_aux = 1/pi_prev_jm1;                                % sigma_dagger^0
    be_aux = 1/pi_jm1 + (mu_jm1 - muhat_jm1)^2;           % total posterior uncertainty

    % -- Expansion 2: quadratic expansion at the Lambert W_0 approximate mode --
    % In canonical variable y = log(t) + kappa*x + omega, the mode equation
    % (with alpha -> 0) reduces to v*exp(v) = beta/(2*pihat_y)*exp(1/(2*pihat_y) - gamma_c)
    % where gamma_c = log(t) + kappa*muhat + omega and pihat_y = pihat/kappa^2.
    gamma_c = log(t_k) + ka_jm1 * muhat_j + om_jm1;
    pihat_y = pihat_j / ka_jm1^2;

    W_arg  = be_aux / (2 * pihat_y) * exp(0.5/pihat_y - gamma_c);
    v_W    = lambert_w0(W_arg);
    y_star = gamma_c + v_W - 0.5/pihat_y;

    % Convert back to native x
    x_star = (y_star - log(t_k) - om_jm1) / ka_jm1;

    % Evaluate quadratic expansion at x_star
    s2   = t_k * exp(ka_jm1 * x_star + om_jm1);
    w2   = s2 / (al_aux + s2);
    da2  = be_aux / (al_aux + s2) - 1;
    pi2  = pihat_j + 1/2 * ka_jm1^2 * w2 * (w2 + (2*w2 - 1) * da2);
    if pi2 <= 0
        pi2 = pihat_j + 1/2 * ka_jm1^2 * w2 * (1 - w2);
    end
    mu2 = x_star + (1/2 * ka_jm1 * w2 * da2 - pihat_j * (x_star - muhat_j)) / pi2;

    % -- Softmax blend weight based on variational energy I --
    ey1 = t_k * exp(ka_jm1 * mu1 + om_jm1);
    I1  = -1/2 * log(al_aux + ey1) - 1/2 * be_aux / (al_aux + ey1) ...
           - 1/2 * pihat_j * (mu1 - muhat_j)^2;

    ey2 = t_k * exp(ka_jm1 * mu2 + om_jm1);
    I2  = -1/2 * log(al_aux + ey2) - 1/2 * be_aux / (al_aux + ey2) ...
           - 1/2 * pihat_j * (mu2 - muhat_j)^2;

    b = 1 / (1 + exp(I1 - I2));   % higher I -> higher weight

    % -- Gaussian mixture moment matching --
    mu_j = (1 - b) * mu1 + b * mu2;
    sig2 = (1 - b) / pi1 + b / pi2 + b * (1 - b) * (mu1 - mu2)^2;
    pi_j = 1 / sig2;

else
    error('tapas:hgf:UnknownUpdateType', ...
        'Unknown update type: %s. Must be ''hgf'', ''ehgf'', or ''uhgf''.', update_type);
end

end
