function pihat_j = hgf_pihat(pi_prev_j, t_k, ka_j, mu_prev_jplus1, om_j)
% Computes the predicted precision at an intermediate level of the HGF.
%
% pihat_j = 1/(1/pi_{k-1,j} + t * exp(ka_j * mu_{k-1,j+1} + om_j))
%
% INPUT:
%   pi_prev_j       Previous posterior precision at level j
%   t_k             Time step
%   ka_j            Coupling strength from level j+1 to level j
%   mu_prev_jplus1  Previous posterior mean at level j+1
%   om_j            Log-volatility offset at level j
%
% OUTPUT:
%   pihat_j          Predicted precision at level j

pihat_j = 1/(1/pi_prev_j + t_k * exp(ka_j * mu_prev_jplus1 + om_j));

end
