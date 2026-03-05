function [pvec, pstruct] = tapas_hgf_categorical_norm_transp(r, ptrans)
% Number of states whose contingencies have to be learned
no = r.c_prc.n_outcomes;

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1:no)       = ptrans(1:no);                           % mu2_0
pstruct.mu2_0    = pvec(1:no);
pvec(no+1:2*no)  = exp(ptrans(no+1:2*no));                 % sa2_0
pstruct.sa2_0    = pvec(no+1:2*no);
pvec(2*no+1)     = ptrans(2*no+1);                         % mu3_0
pstruct.mu3_0    = pvec(2*no+1);
pvec(2*no+2)     = exp(ptrans(2*no+2));                    % sa3_0
pstruct.sa3_0    = pvec(2*no+2);
pvec(2*no+3)     = tapas_sgm(ptrans(2*no+3),r.c_prc.kaub); % ka
pstruct.ka       = pvec(2*no+3);
pvec(2*no+4)     = ptrans(2*no+4);                         % om
pstruct.om       = pvec(2*no+4);
pvec(2*no+5)     = tapas_sgm(ptrans(2*no+5),r.c_prc.thub); % th
pstruct.th       = pvec(2*no+5);

return;
