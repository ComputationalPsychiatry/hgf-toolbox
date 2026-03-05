function [pvec, pstruct] = tapas_hhmm_transp(r, ptrans)

pvec    = NaN(1,length(ptrans));
pstruct = struct;

% Number of outcomes
m = r.c_prc.n_outcomes;

% Transform back to native space
pvec = tapas_sgm(ptrans,1);

% Fill into tree
cN = r.c_prc.N;
N = {};

pv = pvec;
for id = 1:length(cN)
    N{id}.parent   = cN{id}.parent;
    N{id}.children = cN{id}.children;

    if ~isempty(cN{id}.V)
        N{id}.V = pv(1);
        pv(1) = [];
    else
        N{id}.V = [];
    end

    if ~isempty(cN{id}.A)
        nc = length(cN{id}.children);
        N{id}.A = reshape(pv(1:nc^2),nc,nc);
        pv(1:nc^2) = [];
    else
        N{id}.A = [];
    end

    N{id}.B = cN{id}.B;
end

if ~isempty(pv)
    error('tapas:hgf:hhmm:ParamVecNotMatchingTree', 'Parameter vector does not match node tree.');
end

pstruct.N = N;

return;