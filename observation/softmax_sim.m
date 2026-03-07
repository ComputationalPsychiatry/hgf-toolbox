function y = softmax_sim(r, infStates, p)
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

% Predictions or posteriors?
pop = 1; % Default: predictions
if r.c_obs.predorpost == 2
    pop = 3; % Alternative: posteriors
end

% Inverse decision temperature beta
be = p;

% Assumed structure of infStates:
% dim 1: time (ie, input sequence number)
% dim 2: HGF level
% dim 3: choice number
% dim 4: 1: muhat, 2: sahat, 3: mu, 4: sa

% Number of choices
nc = size(infStates,3);

% Belief trajectories at 1st level
states = squeeze(infStates(:,1,:,pop));

% Partition functions
Z = sum(exp(be*states),2);
Z = repmat(Z,1,nc);

% Softmax probabilities
prob = exp(be*states)./Z;

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Draw responses
n = size(infStates,1);
y = NaN(n,1);

for j=1:n
    y(j) = find(mnrnd(1, prob(j,:)));
end

end
