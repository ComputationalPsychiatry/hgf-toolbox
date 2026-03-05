function [pvec, pstruct] = tapas_ph_binary_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)       = tapas_sgm(ptrans(1),1); % v_0
pstruct.v_0   = pvec(1);
pvec(2)       = tapas_sgm(ptrans(2),1); % al_0
pstruct.al_0  = pvec(2);
pvec(3)       = exp(ptrans(3));         % S
pstruct.S     = pvec(3);

