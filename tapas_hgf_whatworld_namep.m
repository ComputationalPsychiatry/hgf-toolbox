function pstruct = tapas_hgf_whatworld_namep(pvec)

ntr = 16;

pstruct = struct;

pstruct.mu2_0 = pvec(1:ntr);
pstruct.sa2_0 = pvec(ntr+1:2*ntr);
pstruct.mu3_0 = pvec(2*ntr+1);
pstruct.sa3_0 = pvec(2*ntr+2);
pstruct.ka    = pvec(2*ntr+3);
pstruct.om    = pvec(2*ntr+4);
pstruct.th    = pvec(2*ntr+5);

return;
