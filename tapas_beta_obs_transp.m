function [pvec, pstruct] = tapas_beta_obs_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)      = exp(ptrans(1));         % nupr
pstruct.nupr = pvec(1);

return;