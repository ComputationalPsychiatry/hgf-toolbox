function [pvec, pstruct] = gaussian_obs_offset_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)    = exp(ptrans(1));         % ze
pstruct.ze = pvec(1);
pvec(2)    = ptrans(2);              % la
pstruct.la = pvec(2);

