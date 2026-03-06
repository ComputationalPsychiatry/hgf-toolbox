function [pvec, pstruct] = rs_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)      = exp(ptrans(1));         % ze1v
pstruct.ze1v = pvec(1);
pvec(2)      = exp(ptrans(2));         % ze1i
pstruct.ze1i = pvec(2);
pvec(3)      = exp(ptrans(3));         % ze2
pstruct.ze2  = pvec(3);
pvec(4)      = exp(ptrans(4));         % ze3
pstruct.ze3  = pvec(4);

