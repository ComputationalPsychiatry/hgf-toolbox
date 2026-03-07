function [pvec, pstruct] = softmax_2beta_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1:2)    = exp(ptrans(1:2));         % be
pstruct.be = pvec(1:2);

