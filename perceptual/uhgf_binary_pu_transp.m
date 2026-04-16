function [pvec, pstruct] = uhgf_binary_pu_transp(r, ptrans)
% Parameter transformation for uHGF binary variant with perceptual uncertainty.
% Delegates to hgf_binary_pu_transp (identical transformation).

[pvec, pstruct] = hgf_binary_pu_transp(r, ptrans);

end
