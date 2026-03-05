function [pvec, pstruct] = tapas_hgf_jget_transp(r, ptrans)


pvec    = NaN(1,length(ptrans));
pstruct = struct;

l = r.c_prc.n_levels;

pvec(1:l)         = ptrans(1:l);                                  % mux_0
pstruct.mux_0     = pvec(1:l);
pvec(l+1:2*l)     = exp(ptrans(l+1:2*l));                         % sax_0
pstruct.sax_0     = pvec(l+1:2*l);
pvec(2*l+1:3*l)   = ptrans(2*l+1:3*l);                            % mua_0
pstruct.mua_0     = pvec(2*l+1:3*l);
pvec(3*l+1:4*l)   = exp(ptrans(3*l+1:4*l));                       % saa_0
pstruct.saa_0     = pvec(3*l+1:4*l);
pvec(4*l+1)       = exp(ptrans(4*l+1));                           % kau
pstruct.kau       = pvec(4*l+1);
pvec(4*l+2:5*l)   = exp(ptrans(4*l+2:5*l));                       % kax
pstruct.kax       = pvec(4*l+2:5*l);
pvec(5*l+1:6*l-1) = exp(ptrans(5*l+1:6*l-1));                     % kaa
pstruct.kaa       = pvec(5*l+1:6*l-1);
pvec(6*l)         = ptrans(6*l);                                  % omu
pstruct.omu       = pvec(6*l);
pvec(6*l+1:7*l)   = ptrans(6*l+1:7*l);                            % omx
pstruct.omx       = pvec(6*l+1:7*l);
pvec(7*l+1:8*l)   = ptrans(7*l+1:8*l);                            % oma
pstruct.oma       = pvec(7*l+1:8*l);

