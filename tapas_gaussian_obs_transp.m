function [pvec, pstruct] = tapas_gaussian_obs_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)    = exp(ptrans(1));         % ze
pstruct.ze = pvec(1);

