function y = beta_obs_sim(r, infStates, p)
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

% Inferred states
if strcmp(r.c_prc.model,'rw_binary')
    mu = infStates(:,1,1); % Default: predictions (ie, mu1hat)
else
    mu = infStates(:,1,1); % Default: predictions (ie, mu1hat)
    if r.c_obs.predorpost == 2
        mu = tapas_sgm(infStates(:,2,3), 1); % Alternative: posteriors (ie, tapas_sgm(mu2))
    end
end
if strcmp(r.c_prc.model,'hgf_whichworld')
    mu = tapas_sgm(infStates(:,2,1,3), 1);
end
if strcmp(r.c_prc.model,'ph_binary')
    mu = infStates(:,2);
end

% Parameter nu-prime
nupr = p;

% Nu is nu-prime plus two (sometimes)
%nu = nupr+2;
nu = nupr;

% Calculate alpha and beta from mu and nu
al = mu.*nu;
be = nu - al;

% Initialize random number generator
if isnan(r.c_sim.seed)
    rng('shuffle');
else
    rng(r.c_sim.seed);
end

% Simulate
y = betarnd(al, be);

