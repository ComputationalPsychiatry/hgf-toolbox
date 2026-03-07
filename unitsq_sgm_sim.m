function [y, prob] = unitsq_sgm_sim(r, infStates, p)
% Simulates observations from a Bernoulli distribution
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
%   prob       Response probabilities (n_trials x 1)

% Predictions or posteriors?
pop = 1; % Default: predictions
if r.c_obs.predorpost == 2
    pop = 3; % Alternative: posteriors
end

% Inverse decision temperature zeta
ze = p;

% Assumed structure of infStates:
% dim 1: time (ie, input sequence number)
% dim 2: HGF level
% dim 3: 1: muhat, 2: sahat, 3: mu, 4: sa

% Belief trajectories at 1st level
states = squeeze(infStates(:,1,pop));

% Apply the unit-square sigmoid to the inferred states
prob = states.^ze./(states.^ze+(1-states).^ze);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate
y = binornd(1, prob);

end
