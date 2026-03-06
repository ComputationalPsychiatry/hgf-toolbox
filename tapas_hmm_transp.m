function [pvec, pstruct] = hmm_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

% Number of hidden states
d = r.c_prc.n_states;

pvec(1:d-1)    = tapas_sgm(ptrans(1:d-1),1);   % ppired
pstruct.ppired = pvec(1:d-1);
pvec(d:d^2-1)  = tapas_sgm(ptrans(d:d^2-1),1); % Ared
pstruct.Ared   = pvec(d:d^2-1);

