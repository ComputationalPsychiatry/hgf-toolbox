function [pvec, pstruct] = tapas_condhalluc_obs2_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)    = exp(ptrans(1));         % be
pstruct.be = pvec(1);

pvec(2)    = exp(ptrans(2));         % nu
pstruct.nu = pvec(2);

