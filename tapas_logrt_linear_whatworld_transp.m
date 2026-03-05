function [pvec, pstruct] = tapas_logrt_linear_whatworld_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)     = ptrans(1);         % be0
pstruct.be0 = pvec(1);
pvec(2)     = ptrans(2);         % be1
pstruct.be1 = pvec(2);
pvec(3)     = ptrans(3);         % be2
pstruct.be2 = pvec(3);
pvec(4)     = ptrans(4);         % be3
pstruct.be3 = pvec(4);
pvec(5)     = exp(ptrans(5));    % ze
pstruct.ze  = pvec(5);

return;
