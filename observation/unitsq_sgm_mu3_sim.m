function y = unitsq_sgm_mu3_sim(r, infStates, p)
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

mu1hat = infStates(:,1,1);
mu3hat = infStates(:,3,1);
ze = exp(-mu3hat);

% Apply the unit-square sigmoid to the inferred states
prob = mu1hat.^ze./(mu1hat.^ze+(1-mu1hat).^ze);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate
y = binornd(1, prob);

