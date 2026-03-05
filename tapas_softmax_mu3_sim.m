function y = tapas_softmax_mu3_sim(r, infStates, p)
% Simulates observations from a Boltzmann distribution with volatility as temperature

% Predictions or posteriors?
pop = 1; % Default: predictions
if r.c_obs.predorpost == 2
    pop = 3; % Alternative: posteriors
end

% Assumed structure of infStates:
% dim 1: time (ie, input sequence number)
% dim 2: HGF level
% dim 3: choice number
% dim 4: 1: muhat, 2: sahat, 3: mu, 4: sa

% Number of choices
nc = size(infStates,3);

% Belief trajectories at 1st level
states = squeeze(infStates(:,1,:,pop));

% Log-volatility trajectory
mu3 = squeeze(infStates(:,3,1,3));

% Inverse decision temperature
be = exp(-mu3);
be = repmat(be,1,nc);

% Partition functions
Z = sum(exp(be.*states),2);
Z = repmat(Z,1,nc);

% Softmax probabilities
prob = exp(be.*states)./Z;

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
