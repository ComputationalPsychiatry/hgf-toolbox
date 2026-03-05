function pstruct = tapas_hgf_categorical_namep(pvec)

no = 3;

pstruct = struct;

pstruct.mu2_0 = pvec(1:no);
pstruct.sa2_0 = pvec(no+1:2*no);
pstruct.mu3_0 = pvec(2*no+1);
pstruct.sa3_0 = pvec(2*no+2);
pstruct.ka    = pvec(2*no+3);
pstruct.om    = pvec(2*no+4);
pstruct.th    = pvec(2*no+5);

return;
