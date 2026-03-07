function y = gaussian_obs_offset_sim(r, infStates, p)
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

% Get parameters
ze = p(1);
la = p(2);

% Get observation prediction trajectory
yhat = la + infStates(:,1,1);

% Number of trials
n = length(yhat);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate
y = yhat +sqrt(ze)*randn(n, 1);

