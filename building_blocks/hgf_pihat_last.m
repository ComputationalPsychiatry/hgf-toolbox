function pihat_l = hgf_pihat_last(pi_prev_l, t_k, th)
% Computes the predicted precision at the last level of the HGF.
%
% pihat_l = 1/(1/pi_{k-1,l} + t * th)
%
% INPUT:
%   pi_prev_l   Previous posterior precision at last level
%   t_k         Time step
%   th          Tonic volatility at the last level (meta-volatility)
%
% OUTPUT:
%   pihat_l      Predicted precision at last level

pihat_l = 1/(1/pi_prev_l + t_k * th);

end
