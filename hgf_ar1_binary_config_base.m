function c = hgf_ar1_binary_config_base(update_type)
% Base configuration for the HGF with AR(1) processes for binary inputs.
% This factory function generates configs for both HGF and eHGF variants.
%
% Usage:
%   c = hgf_ar1_binary_config_base('hgf')   % classic HGF
%   c = hgf_ar1_binary_config_base('ehgf')  % enhanced HGF
%
% NOTE: The eHGF variant includes additional rho parameters and uses different
% default priors for logsa_0, phi, and omega compared to the HGF variant.

% Validate update_type
if ~ismember(update_type, {'hgf', 'ehgf'})
    error('tapas:hgf:InvalidUpdateType', 'update_type must be ''hgf'' or ''ehgf''.');
end

% Config structure
c = struct;

% Model name
c.model = [update_type, '_ar1_binary'];

% Number of levels (minimum: 3)
c.n_levels = 3;

% Input intervals
c.irregular_intervals = false;

% Sufficient statistics of Gaussian parameter priors

% Initial mus and sigmas
c.mu_0mu = [NaN, 0, 1];
c.mu_0sa = [NaN, 0, 0];

switch update_type
    case 'hgf'
        c.logsa_0mu = [NaN, log(0.006), log(4)];
    case 'ehgf'
        c.logsa_0mu = [NaN,   log(0.1), log(1)];
end
c.logsa_0sa = [NaN, 0, 0];

% Phis
% Format: row vector of length n_levels.
% Undefined (therefore NaN) at the first level.
% Fix this to zero (-Inf in logit space) to set to zero.
switch update_type
    case 'hgf'
        c.logitphimu = [NaN, -Inf, tapas_logit(0.1,1)];
    case 'ehgf'
        c.logitphimu = [NaN, -Inf, tapas_logit(0.5,1)];
end
c.logitphisa = [NaN, 0, 2];

% ms
% Format: row vector of length n_levels.
c.mmu = [NaN, c.mu_0mu(2), c.mu_0mu(3)];
c.msa = [NaN,           0,           1];

% Kappas
c.logkamu = [log(1), log(1)];
c.logkasa = [     0,      0];

% Omegas
switch update_type
    case 'hgf'
        c.ommu = [NaN,  -2,  -6];
        c.omsa = [NaN, 4^2, 4^2];
    case 'ehgf'
        c.ommu = [NaN,  -3,   2];
        c.omsa = [NaN,   4,   4];
end

% Gather prior settings in vectors
% NOTE: eHGF includes rho parameters; HGF does not.
switch update_type
    case 'hgf'
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

    case 'ehgf'
        % Rhos (only in eHGF)
        c.rhomu = [NaN, 0, 0];
        c.rhosa = [NaN, 0, 0];

        c.priormus = [
            c.mu_0mu,...
            c.logsa_0mu,...
            c.logitphimu,...
            c.mmu,...
            c.rhomu,...
            c.logkamu,...
            c.ommu,...
                 ];

        c.priorsas = [
            c.mu_0sa,...
            c.logsa_0sa,...
            c.logitphisa,...
            c.msa,...
            c.rhosa,...
            c.logkasa,...
            c.omsa,...
                 ];

        % Check whether we have the right number of priors
        expectedLength = 5*c.n_levels+2*(c.n_levels-1)+1;
end

if length([c.priormus, c.priorsas]) ~= 2*expectedLength;
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Update type
c.update_type = update_type;

% Model function handle
c.prc_fun = str2func([update_type, '_ar1_binary']);

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = str2func([update_type, '_ar1_binary_transp']);

end
