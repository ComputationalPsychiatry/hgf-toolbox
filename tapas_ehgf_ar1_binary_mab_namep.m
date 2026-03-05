function pstruct = tapas_ehgf_ar1_binary_mab_namep(pvec)


pstruct = struct;

l = (length(pvec)+1)/7;
    
if l ~= floor(l)
    error('tapas:hgf:UndetNumLevels', 'Cannot determine number of levels');
end

pstruct.mu_0      = pvec(1:l);
pstruct.sa_0      = pvec(l+1:2*l);
pstruct.phi       = pvec(2*l+1:3*l);
pstruct.m         = pvec(3*l+1:4*l);
pstruct.rho       = pvec(4*l+1:5*l);
pstruct.ka        = pvec(5*l+1:6*l-1);
pstruct.om        = pvec(6*l:7*l-1);


end
