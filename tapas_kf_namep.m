function pstruct = tapas_kf_namep(pvec)


pstruct = struct;

pstruct.g_0       = pvec(1);
pstruct.mu_0      = pvec(2);
pstruct.om        = pvec(3);
pstruct.pi_u      = pvec(4);

