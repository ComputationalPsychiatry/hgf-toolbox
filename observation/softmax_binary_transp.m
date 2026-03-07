function [pvec, pstruct] = softmax_binary_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

pvec(1)    = exp(ptrans(1));         % be
pstruct.be = pvec(1);

