function c = hgf_binary_config_base(update_type)
% Base configuration for the HGF for binary inputs (no perceptual uncertainty).
% This factory function generates configs for HGF, eHGF, and uHGF variants.
%
% Usage:
%   c = hgf_binary_config_base('hgf')   % classic HGF
%   c = hgf_binary_config_base('ehgf')  % enhanced HGF
%   c = hgf_binary_config_base('uhgf')  % unbounded HGF
%
% The HGF is the model introduced in
% Mathys C, Daunizeau J, Friston, KJ, and Stephan KE. (2011). A Bayesian foundation
% for individual learning under uncertainty. Frontiers in Human Neuroscience, 5:39.
%
% The binary HGF model has since been augmented with a positive factor kappa1 which
% scales the second level with respect to the first, i.e., the relation between the
% first and second level is
% p(x1=1|x2) = s(kappa1*x2), where s(.) is the logistic sigmoid.
% By default, kappa1 is fixed to 1, leading exactly to the model introduced in
% Mathys et al. (2011).
%
% This file refers to BINARY inputs (Eqs 1-3 in Mathys et al., (2011));
% for continuous inputs, refer to hgf_config.
%
% The HGF configuration consists of the priors of parameters and initial values. All priors are
% Gaussian in the space where the quantity they refer to is estimated. They are specified by their
% sufficient statistics: mean and variance (NOT standard deviation).
% Quantities are estimated in their native space if they are unbounded (e.g., the omegas). They are
% estimated in log-space if they have a natural lower bound at zero (e.g., the sigmas).
% Parameters can be fixed (i.e., set to a fixed value) by setting the variance of their prior to
% zero.
%
% Fitted trajectories can be plotted by using the command
% >> hgf_binary_plotTraj(est)
% where est is the stucture returned by fitModel. This structure contains the estimated
% perceptual parameters in est.p_prc and the estimated trajectories of the agent's
% representations (cf. Mathys et al., 2011). Their meanings are:
%         est.p_prc.mu_0       row vector of initial values of mu (in ascending order of levels)
%         est.p_prc.sa_0       row vector of initial values of sigma (in ascending order of levels)
%         est.p_prc.rho        row vector of rhos (representing drift; in ascending order of levels)
%         est.p_prc.ka         row vector of kappas (in ascending order of levels)
%         est.p_prc.om         row vector of omegas (in ascending order of levels)
%
% Tips:
%   >> est = fitModel([], u, 'hgf_binary_config', 'bayes_optimal_binary_config');
%   >> est = fitModel([], u, 'ehgf_binary_config', 'bayes_optimal_binary_config');
%   to determine the Bayes optimal perceptual parameters.

% Validate update_type
if ~ismember(update_type, {'hgf', 'ehgf', 'uhgf'})
    error('tapas:hgf:InvalidUpdateType', 'update_type must be ''hgf'', ''ehgf'', or ''uhgf''.');
end

% Config structure
c = struct;

% Model name
c.model = [update_type, '_binary'];

% Number of levels (minimum: 3)
c.n_levels = 3;

% Input intervals
% If input intervals are irregular, the last column of the input
% matrix u has to contain the interval between inputs k-1 and k
% in the k-th row, and this flag has to be set to true
c.irregular_intervals = false;

% Sufficient statistics of Gaussian parameter priors

% Initial mus and sigmas
% Format: row vectors of length n_levels
% For all but the first two levels, this is usually best
% kept fixed to 1 (determines origin on x_i-scale). The 
% first level is NaN because it is determined by the second,
% and the second implies neutrality between outcomes when it
% is centered at 0.
c.mu_0mu = [NaN, 0, 1];
c.mu_0sa = [NaN, 0, 0];

c.logsa_0mu = [NaN,   log(0.1), log(1)];
c.logsa_0sa = [NaN,          0,      0];

% Rhos
% Format: row vector of length n_levels.
% Undefined (therefore NaN) at the first level.
% Fix this to zero to turn off drift.
c.rhomu = [NaN, 0, 0];
c.rhosa = [NaN, 0, 0];

% Kappas
% Format: row vector of length n_levels-1.
% Fixing log(kappa1) to log(1) leads to the original HGF model.
% Higher log(kappas) should be fixed (preferably to log(1)) if the
% observation model does not use mu_i+1 (kappa then determines the
% scaling of x_i+1).
c.logkamu = [log(1), log(1)];
c.logkasa = [     0,      0];

% Omegas
% Format: row vector of length n_levels.
% Undefined (therefore NaN) at the first level.
% NOTE: Prior values differ between HGF and eHGF variants.
switch update_type
    case 'hgf'
        c.ommu = [NaN,  -3,  -6];
        c.omsa = [NaN, 4^2, 4^2];
    case 'ehgf'
        c.ommu = [NaN,  -3,   2];
        c.omsa = [NaN,   4,   4];
    case 'uhgf'
        c.ommu = [NaN,  -3,  -6];
        c.omsa = [NaN,   4,   4];
end

% Gather prior settings in vectors
c.priormus = [
    c.mu_0mu,...
    c.logsa_0mu,...
    c.rhomu,...
    c.logkamu,...
    c.ommu,...
         ];

c.priorsas = [
    c.mu_0sa,...
    c.logsa_0sa,...
    c.rhosa,...
    c.logkasa,...
    c.omsa,...
         ];

% Check whether we have the right number of priors
expectedLength = 3*c.n_levels+2*(c.n_levels-1)+1;
if length([c.priormus, c.priorsas]) ~= 2*expectedLength;
    error('tapas:hgf:PriorDefNotMatchingLevels', 'Prior definition does not match number of levels.')
end

% Update type
c.update_type = update_type;

% Model function handle
c.prc_fun = str2func([update_type, '_binary']);

% Handle to function that transforms perceptual parameters to their native space
% from the space they are estimated in
c.transp_prc_fun = str2func([update_type, '_binary_transp']);

end
