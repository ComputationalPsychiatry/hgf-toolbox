function [pvec, pstruct] = tapas_hgf_binary_mab_transp(r, ptrans)


pvec    = NaN(1,length(ptrans));
pstruct = struct;

l = r.c_prc.n_levels;

pvec(1:l)         = ptrans(1:l);                                 % mu_0
pstruct.mu_0      = pvec(1:l);
pvec(l+1:2*l)     = exp(ptrans(l+1:2*l));                        % sa_0
pstruct.sa_0      = pvec(l+1:2*l);
pvec(2*l+1:3*l)   = ptrans(2*l+1:3*l);                           % rho
pstruct.rho       = pvec(2*l+1:3*l);
pvec(3*l+1:4*l-1) = exp(ptrans(3*l+1:4*l-1));                    % ka
pstruct.ka        = pvec(3*l+1:4*l-1);
pvec(4*l:5*l-1)   = ptrans(4*l:5*l-1);                           % om
pstruct.om        = pvec(4*l:5*l-1);

return;
