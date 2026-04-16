function c = hgf_binary_pu_tbt_config_base(update_type)
% Base configuration for the HGF for binary inputs with trial-by-trial perceptual uncertainty.
% This factory function generates configs for both HGF and eHGF variants.
%
% Usage:
%   c = hgf_binary_pu_tbt_config_base('hgf')   % classic HGF
%   c = hgf_binary_pu_tbt_config_base('ehgf')  % enhanced HGF
%   c = hgf_binary_pu_tbt_config_base('uhgf')  % unbounded HGF
%
% The uncertainty (alpha) is expected by the model in the second column of the input matrix.

% Validate update_type
if ~ismember(update_type, {'hgf', 'ehgf', 'uhgf'})
    error('tapas:hgf:InvalidUpdateType', 'update_type must be ''hgf'', ''ehgf'', or ''uhgf''.');
end

% Config structure
c = struct;

% Model name
c.model = [update_type, '_binary_pu_tbt'];

% Number of levels (minimum: 3)
c.n_levels = 3;

% Input intervals
c.irregular_intervals = false;

% Sufficient statistics of Gaussian parameter priors

% Initial mus and sigmas
c.mu_0mu = [NaN, 0, 1];
c.mu_0sa = [NaN, 0, 0];

c.logsa_0mu = [NaN,   log(0.1), log(1)];
c.logsa_0sa = [NaN,          0,      0];

% Rhos
c.rhomu = [NaN, 0, 0];
c.rhosa = [NaN, 0, 0];

% Kappas
c.logkamu = [log(1), log(1)];
c.logkasa = [     0,      0];

% Omegas
c.ommu = [NaN,  -5,  -6];
c.omsa = [NaN, 4^2, 4^2];

% Eta0
c.eta0mu = 0;
c.eta0sa = 0;

% Eta1
c.eta1mu = 1;
c.eta1sa = 0;

% Gather prior settings in vectors
c.priormus = [
    c.mu_0mu,...
    c.logsa_0mu,...
    c.rhomu,...
    c.logkamu,...
    c.ommu,...
    c.eta0mu,...
    c.eta1mu,...
         ];

c.priorsas = [
    c.mu_0sa,...
    c.logsa_0sa,...
    c.rhosa,...
    c.logkasa,...
    c.omsa,...
    c.eta0sa,...
    c.eta1sa,...
         ];

% Check whether we have the right number of priors
expectedLength = 3*c.n_levels+2*(c.n_levels-1)+3;
if length([c.priormus, c.priorsas]) ~= 2*expectedLength;
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Update type
c.update_type = update_type;

% Model function handle
c.prc_fun = str2func([update_type, '_binary_pu_tbt']);

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = str2func([update_type, '_binary_pu_tbt_transp']);

end
