function [pvec, pstruct] = uhgf_ar1_binary_transp(r, ptrans)
% Parameter transformation for uHGF AR(1) binary variant.
% Delegates to ehgf_ar1_binary_transp (identical transformation, includes rho).

[pvec, pstruct] = ehgf_ar1_binary_transp(r, ptrans);

end
