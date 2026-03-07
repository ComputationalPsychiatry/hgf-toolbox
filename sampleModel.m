function r = sampleModel(inputs, varargin)
% Samples parameter values from the prior and computes the implied belief
% trajectories. If an observation model is specified, also simulates
% responses from the sampled observation model parameters.
%
% This is useful for prior predictive checks: understanding what behavior
% the prior implies before fitting any data.
%
% USAGE:
%     sam = sampleModel(inputs, perceptual_config)
%     sam = sampleModel(inputs, perceptual_config, observational_config)
%     sam = sampleModel(inputs, perceptual_config, observational_config, seed)
%
% INPUT:
%   inputs               Array of inputs (column vector). See fitModel for
%                         details on coding of irregular/ignored trials.
%   perceptual_config    Either the name of a perceptual config function
%                         (e.g., 'ehgf_binary_config') or a config struct.
%                         Default: ehgf_binary_config
%   observational_config (Optional) Either the name of an observation
%                         config function (e.g., 'unitsq_sgm_config') or a
%                         config struct. If omitted, no responses are
%                         simulated.
%   seed                  (Optional) Seed for the random number generator.
%                         Default: NaN (random seed)
%
% OUTPUT:
%   sam.u        Inputs
%   sam.y        Simulated responses (only if observation model specified)
%   sam.c_prc    Perceptual model config (including priors)
%   sam.c_obs    Observation model config (if specified)
%   sam.p_prc    Sampled perceptual parameters (in native and transformed space)
%   sam.p_obs    Sampled observation parameters (if observation model specified)
%   sam.traj     Belief trajectories implied by sampled parameters
%
% EXAMPLE:
%   u = load('example_binary_input.txt');
%   sam = sampleModel(u, 'ehgf_binary_config', 'unitsq_sgm_config', 12345);
%   hgf_binary_plotTraj(sam)

% Store responses, inputs, and information about irregular trials in newly
% initialized structure r
r = dataPrep(inputs);

% THE DEFAULTS DEFINED HERE WILL BE OVERWRITTEN BY ANY ARGUMENTS GIVEN WHEN CALLING fitModel.m
% Default perceptual model
% ~~~~~~~~~~~~~~~~~~~~~~~~
r.c_prc = ehgf_binary_config;

% Default observation model
% ~~~~~~~~~~~~~~~~~~~~~~~~~
r.c_obs = [];


% Override default settings with arguments from the command line
if nargin > 1 && ~isempty(varargin{1})
    if isstr(varargin{1})
        fh = str2func(varargin{1});
        r.c_prc = fh();
    else
        r.c_prc = varargin{1};
        % Ensure consistency of configuration of priors
        r.c_prc = align_priors(r.c_prc);
    end
end

if nargin > 2 && ~isempty(varargin{2})
    if isstr(varargin{2})
        fh = str2func(varargin{2});
        r.c_obs = fh();
    else
        r.c_obs = varargin{2};
        % Ensure consistency of configuration of priors
        r.c_obs = align_priors(r.c_obs);
    end
end

% Replace placeholders in parameter vectors with their calculated values
r.c_prc.priormus(r.c_prc.priormus==99991) = r.plh.p99991;
r.c_prc.priorsas(r.c_prc.priorsas==99991) = r.plh.p99991;

r.c_prc.priormus(r.c_prc.priormus==99992) = r.plh.p99992;
r.c_prc.priorsas(r.c_prc.priorsas==99992) = r.plh.p99992;

r.c_prc.priormus(r.c_prc.priormus==99993) = r.plh.p99993;
r.c_prc.priorsas(r.c_prc.priorsas==99993) = r.plh.p99993;

r.c_prc.priormus(r.c_prc.priormus==-99993) = -r.plh.p99993;
r.c_prc.priorsas(r.c_prc.priorsas==-99993) = -r.plh.p99993;

r.c_prc.priormus(r.c_prc.priormus==99994) = r.plh.p99994;
r.c_prc.priorsas(r.c_prc.priorsas==99994) = r.plh.p99994;

r = rmfield(r, 'plh');

% Store model name also in c_sim field
r.c_sim.prc_model = r.c_prc.model;

% Set seed for random number generator
r.c_sim.seed = NaN;
if nargin > 3
    r.c_sim.seed = varargin{3};
end
    
% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Add random values to prior means, drawn from a Gaussian with prior sd
np_prc = length(r.c_prc.priorsas);
ptrans = r.c_prc.priormus + randn(1,np_prc).*sqrt(r.c_prc.priorsas);

% Transform parameters to their native space
[dummy, r.p_prc] = r.c_prc.transp_prc_fun(r, ptrans);
r.p_prc.p        = r.c_prc.transp_prc_fun(r, ptrans);
r.p_prc.ptrans   = ptrans;

% Compute perceptual states
[r.traj, infStates] = r.c_prc.prc_fun(r, r.p_prc.p);

if nargin > 2
    % Store model name also in c_sim field
    r.c_sim.obs_model = r.c_obs.model;

    % Add random values to prior means, drawn from a Gaussian with prior sd
    np_obs = length(r.c_obs.priorsas);
    ptrans = r.c_obs.priormus + randn(1,np_obs).*sqrt(r.c_obs.priorsas);

    % Transform parameters to their native space
    [dummy, r.p_obs]   = r.c_obs.transp_obs_fun(r, ptrans);
    r.p_obs.p          = r.c_obs.transp_obs_fun(r, ptrans);
    r.p_obs.ptrans     = ptrans;

    % Get function handle to observation model
    obs_fun = str2func([r.c_obs.model, '_sim']);
    
    % Simulate decisions
    r.y = obs_fun(r, infStates, r.p_obs.p);
end

end % function sampleModel

function r = dataPrep(inputs)

% Initialize data structure to be returned
r = struct;

% Check if inputs look like column vectors
if size(inputs,1) <= size(inputs,2)
    disp(' ')
    disp('Warning: ensure that input sequences are COLUMN vectors.')
end

% Store inputs
r.u  = inputs;

% Determine ignored trials
ign = [];
for k = 1:size(r.u,1)
    if isnan(r.u(k,1))
        ign = [ign, k];
    end
end

r.ign = ign;

if isempty(ign)
    ignout = 'none';
else
    ignout = ign;
end
disp(['Ignored trials: ', num2str(ignout)])

% Calculate placeholder values for configuration files

% First input
% Usually a good choice for the prior mean of mu_1
r.plh.p99991 = r.u(1,1);

% Variance of first 20 inputs
% Usually a good choice for the prior variance of mu_1
if length(r.u(:,1)) > 20
    r.plh.p99992 = var(r.u(1:20,1),1);
else
    r.plh.p99992 = var(r.u(:,1),1);
end

% Log-variance of first 20 inputs
% Usually a good choice for the prior means of log(sa_1) and alpha
if length(r.u(:,1)) > 20
    r.plh.p99993 = log(var(r.u(1:20,1),1));
else
    r.plh.p99993 = log(var(r.u(:,1),1));
end

% Log-variance of first 20 inputs minus two
% Usually a good choice for the prior mean of omega_1
if length(r.u(:,1)) > 20
    r.plh.p99994 = log(var(r.u(1:20,1),1))-2;
else
    r.plh.p99994 = log(var(r.u(:,1),1))-2;
end

end % function dataPrep
