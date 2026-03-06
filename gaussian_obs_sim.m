function y = gaussian_obs_sim(r, infStates, p)
% Simulates observations with Gaussian noise

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

