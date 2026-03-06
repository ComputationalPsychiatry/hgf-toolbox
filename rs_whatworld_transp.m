function [pvec, pstruct] = rs_whatworld_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)      = exp(ptrans(1));         % ze1
pstruct.ze   = pvec(1);
pvec(2)      = exp(ptrans(2));         % ze2
pstruct.ze2  = pvec(2);
pvec(3)      = exp(ptrans(3));         % ze3
pstruct.ze3  = pvec(3);

