function [y, prob] = tapas_unitsq_sgm_sim(r, infStates, p)
% Simulates observations from a Bernoulli distribution

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
