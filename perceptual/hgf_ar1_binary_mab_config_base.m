function c = hgf_ar1_binary_mab_config_base(update_type)
% Base configuration for the HGF with AR(1) processes in a multi-armed bandit situation
% for binary inputs.
% This factory function generates configs for both HGF and eHGF variants.
%
% Usage:
%   c = hgf_ar1_binary_mab_config_base('hgf')   % classic HGF
%   c = hgf_ar1_binary_mab_config_base('ehgf')  % enhanced HGF
%   c = hgf_ar1_binary_mab_config_base('uhgf')  % unbounded HGF
%
% NOTE: The eHGF and uHGF variants use different default priors and n_bandits compared to HGF.

% Validate update_type
if ~ismember(update_type, {'hgf', 'ehgf', 'uhgf'})
    error('tapas:hgf:InvalidUpdateType', 'update_type must be ''hgf'', ''ehgf'', or ''uhgf''.');
end

% Config structure
c = struct;

% Model name
c.model = [update_type, '_ar1_binary_mab'];

% Number of levels (minimum: 3)
c.n_levels = 3;

% Number of bandits
switch update_type
    case 'hgf'
        c.n_bandits = 3;
    case {'ehgf', 'uhgf'}
        c.n_bandits = 4;
end

% Coupling
c.coupled = false;

% Input intervals
c.irregular_intervals = false;

% Sufficient statistics of Gaussian parameter priors

% Initial mus and sigmas
c.mu_0mu = [NaN, 0, 1];
c.mu_0sa = [NaN, 1, 1];

c.logsa_0mu = [NaN,   log(0.1), log(1)];
c.logsa_0sa = [NaN,          1,      1];

% Phis
switch update_type
    case 'hgf'
        c.logitphimu = [NaN, tapas_logit(0.4,1), tapas_logit(0.2,1)];
        c.logitphisa = [NaN,                  1,                   1];
    case {'ehgf', 'uhgf'}
        c.logitphimu = [NaN, tapas_logit(0.4,1), tapas_logit(0.2,1)];
        c.logitphisa = [NaN,                  0,                   0];
end

% ms
c.mmu = [NaN, c.mu_0mu(2), c.mu_0mu(3)];
switch update_type
    case 'hgf'
        c.msa = [NaN, 0, 0];
    case {'ehgf', 'uhgf'}
        c.msa = [NaN, 0, 1];
end

% Kappas
c.logkamu = [log(1), log(1)];
c.logkasa = [     0,    0.1];

% Omegas
switch update_type
    case 'hgf'
        c.ommu = [NaN,   -2,   -2];
        c.omsa = [NaN,    1,    1];
    case {'ehgf', 'uhgf'}
        c.ommu = [NaN,   -3,    2];
        c.omsa = [NaN,    4,    4];
end

% Gather prior settings in vectors
c.priormus = [
    c.mu_0mu,...
    c.logsa_0mu,...
    c.logitphimu,...
    c.mmu,...
    c.logkamu,...
    c.ommu,...
         ];

c.priorsas = [
    c.mu_0sa,...
    c.logsa_0sa,...
    c.logitphisa,...
    c.msa,...
    c.logkasa,...
    c.omsa,...
         ];

% Check whether we have the right number of priors
expectedLength = 5*c.n_levels+(c.n_levels-1);
if length([c.priormus, c.priorsas]) ~= 2*expectedLength;
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Update type
c.update_type = update_type;

% Model function handle
c.prc_fun = str2func([update_type, '_ar1_binary_mab']);

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = str2func([update_type, '_ar1_binary_mab_transp']);

end
