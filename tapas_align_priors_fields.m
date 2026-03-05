function c = tapas_align_priors_fields(c)
% Aligns parameter fields with the explicit prior definitions with the 
% content of the vectors c.priormus and c.priorsas (vice-versa of function 
% 'tapas_align_priors.m').
%   Example:
%   >> c_prc = tapas_ehgf_binary_config;
%   >> c_prc.priormus(13) = -2;
%   >> c_prc = tapas_align_priors_fields(c_prc)


% Get fieldnames. If a name ends on 'mu', that field defines a prior mean.
% If it ends on 'sa', it defines a prior variance.
names = fieldnames(c);
pm = 0;
ps = 0;

% Loop over fields and overwrite fiels whose name ends on 'mu or 'sa'
for i = 1:length(names)
    if regexp(names{i}, 'mu$')
        c.(names{i}) = c.priormus(pm+1:pm+length(c.(names{i})));
        pm = pm+length(c.(names{i}));
    elseif regexp(names{i}, 'sa$')
        c.(names{i}) = c.priorsas(ps+1:ps+length(c.(names{i})));
        ps = ps+length(c.(names{i}));
    end
end

end
