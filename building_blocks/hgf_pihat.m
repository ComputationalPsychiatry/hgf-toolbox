function pihat_j = hgf_pihat(pi_prev_j, t_k, ka_j, muhat_jplus1, om_j)
% Computes the predicted precision at an intermediate level of the HGF.
%
% pihat_j = 1/(1/pi_{k-1,j} + t * exp(ka_j * muhat_{k,j+1} + om_j))
%
% The step size of level j at trial k depends on the value of level j+1 at
% trial k. It is therefore evaluated at the prediction of level j+1 for trial
% k, which includes its drift and mean reversion over the time step, and
% equals its posterior mean at trial k-1 when level j+1 has neither.
%
% INPUT:
%   pi_prev_j       Previous posterior precision at level j
%   t_k             Time step
%   ka_j            Coupling strength from level j+1 to level j
%   muhat_jplus1    Predicted mean at level j+1 for trial k
%   om_j            Log-volatility offset at level j
%
% OUTPUT:
%   pihat_j          Predicted precision at level j

pihat_j = 1/(1/pi_prev_j + t_k * exp(ka_j * muhat_jplus1 + om_j));

end
