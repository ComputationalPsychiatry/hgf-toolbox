function [pvec, pstruct] = kf_transp(r, ptrans)


pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)         = exp(ptrans(1));                      % g_0
pstruct.g_0     = pvec(1);
pvec(2)         = ptrans(2);                           % mu_0
pstruct.mu_0    = pvec(2);
pvec(3)         = ptrans(3);                           % om
pstruct.om      = pvec(3);
pvec(4)         = exp(ptrans(4));                      % pi_u
pstruct.pi_u    = pvec(4);

