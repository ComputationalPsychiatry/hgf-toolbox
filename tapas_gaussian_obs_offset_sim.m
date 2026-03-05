function y = tapas_gaussian_obs_offset_sim(r, infStates, p)
% Simulates observations with Gaussian noise

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

