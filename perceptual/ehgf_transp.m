function [pvec, pstruct] = ehgf_transp(r, ptrans)
% Parameter transformation for eHGF variant.
% Delegates to hgf_transp (identical transformation).

[pvec, pstruct] = hgf_transp(r, ptrans);

end
