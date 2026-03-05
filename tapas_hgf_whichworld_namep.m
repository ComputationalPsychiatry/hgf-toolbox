function pstruct = tapas_hgf_whichworld_namep(pvec)

nw = 4;

pstruct = struct;

pstruct.mu2_0 = pvec(1:nw);
pstruct.sa2_0 = pvec(nw+1:2*nw);
pstruct.mu3_0 = pvec(2*nw+1);
pstruct.sa3_0 = pvec(2*nw+2);
pstruct.ka    = pvec(2*nw+3);
pstruct.om    = pvec(2*nw+4);
pstruct.th    = pvec(2*nw+5);
pstruct.m     = pvec(2*nw+6);
pstruct.phi   = pvec(2*nw+7);

return;