function pstruct = hgf_ar1_binary_namep(pvec)


pstruct = struct;

l = (length(pvec)+1)/6;
    
if l ~= floor(l)
    error('tapas:hgf:UndetNumLevels', 'Cannot determine number of levels');
end

pstruct.mu_0      = pvec(1:l);
pstruct.sa_0      = pvec(l+1:2*l);
pstruct.phi       = pvec(2*l+1:3*l);
pstruct.m         = pvec(3*l+1:4*l);
pstruct.ka        = pvec(4*l+1:5*l-1);
pstruct.om        = pvec(5*l:6*l-1);

