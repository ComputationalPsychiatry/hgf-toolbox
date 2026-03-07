function y = condhalluc_obs2_sim(r, infStates, p)
% Simulates responses according to the condhalluc_obs model
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
be = p(1);
nu = p(2);

% Prediction trajectory
mu1hat = infStates(:,1,1);

% Get true-positive rate corresponding to stimuli
tp = r.u(:,2);

% Update belief using precision-weighted prediction error
% with nu the generalized precision
x = mu1hat + 1/(1 + nu)*(tp - mu1hat);

% Apply the logistic sigmoid to the inferred beliefs
prob = tapas_sgm(be.*(2.*x-1),1);

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate
y = binornd(1, prob);

