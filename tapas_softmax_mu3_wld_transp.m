function [pvec, pstruct] = tapas_softmax_mu3_wld_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)       = ptrans(1);         % la_wd
pstruct.la_wd = pvec(1);
pvec(2)       = ptrans(2);         % la_ld
pstruct.la_ld = pvec(2);

