function pstruct = tapas_ehgf_jget_namep(pvec)


pstruct = struct;

l = length(pvec)/8;

if l ~= floor(l)
    error('tapas:hgf:UndetNumLevels', 'Cannot determine number of levels');
end

pstruct.mux_0     = pvec(1:l);
pstruct.sax_0     = pvec(l+1:2*l);
pstruct.mua_0     = pvec(2*l+1:3*l);
pstruct.saa_0     = pvec(3*l+1:4*l);
pstruct.kau       = pvec(4*l+1);
pstruct.kax       = pvec(4*l+2:5*l);
pstruct.kaa       = pvec(5*l+1:6*l-1);
pstruct.omu       = pvec(6*l);
pstruct.omx       = pvec(6*l+1:7*l);
pstruct.oma       = pvec(7*l+1:8*l);

end
