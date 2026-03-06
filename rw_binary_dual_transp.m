function [pvec, pstruct] = rw_binary_dual_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1:2)     = tapas_sgm(ptrans(1:2),1); % v_0
pstruct.v_0   = pvec(1:2);
pvec(3)       = tapas_sgm(ptrans(3),1);   % alpha
pstruct.al    = pvec(3);
pvec(4)       = tapas_sgm(ptrans(4),1);   % kappa
pstruct.ka    = pvec(4);

