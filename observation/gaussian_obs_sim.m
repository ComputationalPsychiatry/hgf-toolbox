function y = gaussian_obs_sim(r, infStates, p)
% Simulates observations with Gaussian noise
%
% INPUT:
%   r          Result struct. Relevant fields:
%                r.c_sim.seed - RNG seed (NaN for random)
%                r.c_obs      - observation model config
%   infStates  Inferred states from the perceptual model
%              (n_trials x n_levels x 4; see ARCHITECTURE.md)
%   p          Observation model parameters in native space
%
% OUTPUT:
%   y          Simulated responses (n_trials x 1)

% Get parameter
ze = p;

% Get observation prediction trajectory
muhat = infStates(:,1,1);

% Number of trials
n = length(muhat);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate
y = muhat +sqrt(ze)*randn(n, 1);

