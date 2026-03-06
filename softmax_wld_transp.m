function [pvec, pstruct] = softmax_wld_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)       = exp(ptrans(1));    % be
pstruct.be    = pvec(1);
pvec(2)       = ptrans(2);         % la_wd
pstruct.la_wd = pvec(2);
pvec(3)       = ptrans(3);         % la_ld
pstruct.la_ld = pvec(3);

