function [pvec, pstruct] = ehgf_jget_transp(r, ptrans)
% Parameter transformation for eHGF variant.
% Delegates to hgf_jget_transp (identical transformation).

[pvec, pstruct] = hgf_jget_transp(r, ptrans);

end
